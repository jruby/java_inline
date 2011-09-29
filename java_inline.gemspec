Gem::Specification.new do |s|
  s.platform = "java"
  s.name = "java_inline"
  s.version = "0.0.4"
  s.date = "2009-11-23"
  s.summary = "JVM language support for RubyInline"
  s.description = %q{A set of plugins for RubyInline to allow embedding JVM languages into Ruby code running on JRuby}

  s.files = Dir['README', 'lib/**/*', 'examples/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true

  s.authors = [
    "Charles Oliver Nutter",
    "Nilanjan Raychaudhuri"
  ]
  s.email = [
    "headius@headius.com",
    "nraychaudhuri@gmail.com"
  ]
  s.homepage = "http://github.com/jruby/java_inline"
  s.rubyforge_project = "java_inline"

  s.add_dependency 'RubyInline'
end
