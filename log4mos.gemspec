# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'log4mos/version'

Gem::Specification.new do |s|
  s.name = 'log4mos'
  s.version = Log4Mos::VERSION
  s.required_ruby_version = '>= 2'

  s.summary = 'Logging Mos Style'
  s.description = 'A logging gem for MOS applications. This is aimed to replace other approaches that rely on ActiveSupport::Notifications.'
  s.authors = %w[nX8igTYAm2iskVhn]
  s.email = 'nX8igTYAm2iskVhn-dev@nX8igTYAm2iskVhn.com'

  s.add_dependency 'i18n'
  s.add_dependency 'railties'
  s.add_dependency 'activerecord'
  s.add_dependency 'airbrake', '~> 4'

  s.files = Dir.glob('{lib}/**/*') + %w(README.md)
end
