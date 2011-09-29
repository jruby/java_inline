require 'rubygems'
require 'inline'
require 'java'
require 'mirah'

# Add the inline cache dir to CLASSPATH
$CLASSPATH << Inline.directory

module Inline
  
  # A Mirah builder for RubyInline. Provides the basic methods needed to
  # allow assembling a set of Mirah methods that compile into a class and
  # get bound to the same names in the containing module.
  class Mirah
    def initialize(mod)
      @context = mod
      @src = ""
      @imports = []
      @sigs = []
    end
    
    def load_cache
      false
    end

    # Add an "import" line with the given class, as in
    # builder.import "java.util.ArrayList". The imports will be composed
    # into an appropriate block of code and added to the top of the source.
    def import(cls)
      if cls.respond_to? :java_class
        @imports << cls.java_class.name
      else
        @imports << cls.to_s
      end
    end

    # Add a Java method to the built Java source. This expects the method to
    # be public and static, so it can be called as a function.
    def duby(src)
      @src << src << "\n"
      signature = src.match(/def ([a-zA-Z0-9_]+)\((.*)\)/)
      raise "Could not parse method signature" unless signature
      @sigs << [nil, signature[1], signature[2]]
    end

    def build
      @load_name = @name = "Mirah#{@src.hash.abs}"
      filename = "#{@name}.mirah"

      imports = "import " + @imports.join("\nimport ") if @imports.size > 0
      full_src = "
        #{imports}
        class #{@name}
        #{@src}
        end
      "

      File.open(filename, "w") {|file| file.write(full_src)}
      Dir.chdir(Inline.directory) do
        ::Mirah.compile(filename)
      end
    end

    def load
      @context.module_eval "const_set :#{@name}, ::Java::#{@load_name}.new"
      @sigs.each do |sig|
        @context.module_eval "def #{sig[1]}(*args); #{@name}.#{sig[1]}(*args); end"
      end
    end
  end
end
