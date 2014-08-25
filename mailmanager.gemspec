# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mailmanager/version'

spec = Gem::Specification.new do |s|
  s.name = 'mailmanager'
  s.version = MailManager::VERSION
  s.licenses = "BSD-3-Clause"
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.summary = "GNU Mailman wrapper for Ruby"
  s.description = %{Ruby wrapper library for GNU Mailman's admin functions}
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files spec`.split("\n")
  s.require_paths = ['lib']
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.authors = ["Wes Morgan"]
  s.email = "cap10morgan@gmail.com"
  s.homepage = "http://github.com/cap10morgan/mailmanager"
  s.add_runtime_dependency('json', '~> 1.8')
  s.add_runtime_dependency('open4', '~> 1.0')
  s.add_development_dependency('rake', '~> 10.3')
  s.add_development_dependency('rspec', '~> 2.4')
end
