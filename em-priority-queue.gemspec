# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "em-priority-queue/version"

Gem::Specification.new do |s|
  s.name        = "em-priority-queue"
  s.version     = EventMachine::PriorityQueue::VERSION 
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Lewis"]
  s.email       = ["ft.mikelewis@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Async Priority Queue}
  s.description = %q{Aync Priority Queue}

  s.rubyforge_project = "em-priority-queue"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "eventmachine", ">= 1.0.0.beta.3"
  s.add_dependency "algorithms", "~> 0.3.0"


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
