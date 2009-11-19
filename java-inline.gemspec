Gem::Specification.new do |s|
  s.platform = "java"
  s.name = "java-inline"
  s.version = "0.0.1"
  s.date = "2009-11-18"
  s.summary = "JVM language support for RubyInline"
  s.description = %q{A set of plugins for RubyInline to allow embedding JVM languages into Ruby code running on JRuby}

  s.files = Dir['README', 'lib/**/*', 'examples/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true

  s.author = "Charles Oliver Nutter"
  s.email = "headius@headius.com"
  s.homepage = "http://kenai.com/projects/java-inline"
  s.rubyforge_project = "java-inline"

  s.add_dependency 'RubyInline'
end
