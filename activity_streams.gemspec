# -*- encoding: utf-8 -*-
require File.expand_path("../lib/activity_streams/version", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{activity_streams}
  s.rubyforge_project = %q{activity_streams}
  s.version = ActivityStreams::VERSION
  s.platform = Gem::Platform::RUBY

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ruben Fonseca"]
  s.date = %q{2010-09-10}
  s.description = %q{Ruby module to eat and parse ActivityStreams in various formats}
  s.summary = %q{Ruby module to eat and parse ActivityStreams in various formats}
  s.email = %q{root@cpan.org}

  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.test_files   = `git ls-files`.split("\n").map{|f| f =~ /(^spec\/.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.homepage = %q{http://github.com/webcracy/activity_streams}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.add_development_dependency "bundler", ">= 1.0.0"
end

