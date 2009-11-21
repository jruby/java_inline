Gem::Specification.new do |s|
  s.platform = "java"
  s.name = "scala-inline"
  s.version = "0.0.1"
  s.date = "2009-11-20"
  s.summary = "Scala language support for RubyInline"
  s.description = %q{A set of plugins for RubyInline to allow embedding JVM languages into Ruby code running on JRuby}

  s.files = Dir['README', 'lib/**/*', 'examples/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true

  s.author = "Nilanjan Raychaudhuri"
  s.email = "nraychaudhuri@gmail.com"
  s.homepage = ""
  s.rubyforge_project = "scala-inline"

  s.add_dependency 'RubyInline'
end
