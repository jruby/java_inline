require 'rubygems'
require 'inline'
require 'java'
include_class Java::java.lang.System

# Add the inline cache dir to CLASSPATH
$CLASSPATH << Inline.directory
$CLASSPATH << "#{System.getProperty('scala.home')}/lib/scala-compiler.jar"
$CLASSPATH << "#{System.getProperty('scala.home')}/lib/scala-library.jar"      

module Inline
  
  # A Java builder for RubyInline. Provides the basic methods needed to
  # allow assembling a set of Java methods that compile into a class and
  # get bound to the same names in the containing module.
  class Scala
    JFile = java.io.File
    include_class Java::scala.tools.nsc.Main
    
    def initialize(mod)
      @context = mod
      @src = ""
      @imports = []
      @sigs = []
    end

    def load_cache
      false
    end
    
    # Set the package to use for the Java class being generated, as in
    # builder.package "org.foo.bar"
    def package(pkg)
      @pkg = pkg
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

    # Add a Scala method to the built Scala source. This expects the method to
    # be public and static, so it can be called as a function.
    def scala(src)
      @src << src << "\n"
      signature = src.match(/def\W+([a-zA-Z0-9_]+)\((.*)\)/)
      raise "Could not parse method signature" unless signature
      @sigs << [signature[1], signature[2]]
    end

    def build      
      if @pkg
        directory = "#{Inline.directory}/#{@pkg.gsub('.', '/')}"
        unless File.directory? directory then
          $stderr.puts "NOTE: creating #{directory} for RubyInline" if $DEBUG
          FileUtils.mkdir_p directory
        end
        
        @name = "Scala#{@src.hash.abs}"
        @load_name = "#{@pkg}.#{@name}"
        filename = "#{directory}/#{@name}.scala"
      
        imports = "import " + @imports.join("\nimport ") if @imports.size > 0
        full_src = "
          package #{@pkg}
          #{imports}
          object #{@name} {
          #{@src}
          }
        "
      else
        @load_name = @name = "Java#{@src.hash.abs}"
        filename = "#{Inline.directory}/#{@name}.scala"
      
        imports = "import " + @imports.join("\nimport ") if @imports.size > 0
        full_src = "
          #{imports}
          object #{@name} {
          #{@src}
          }
        "
      end
      
      File.open(filename, "w") {|file| file.write(full_src)}
      cmd_args = [filename, "-classpath", "#{System.getProperty('scala.home')}/lib/scala-library.jar", "-d", "#{Inline.directory}"]
      Main.process(cmd_args.to_java(:string))
    end

    def load
      @context.module_eval "const_set :#{@name}, ::Java::#{@load_name}"
      @sigs.each do |sig|
        @context.module_eval "def #{sig[0]}(*args); #{@name}.#{sig[0]}(*args); end"
      end
    end
  end
end
