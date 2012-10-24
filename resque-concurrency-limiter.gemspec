Gem::Specification.new do |s|
  s.name        = "resque-concurrency-limiter"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Zachary Anker"]
  s.email       = ["zach.anker@gmail.com"]
  s.homepage    = "http://github.com/zanker/resque-concurrency-limiter"
  s.summary     = "Resque concurrency limiter"
  s.description = "Limits how many jobs can be run at a time and limits how many can be queued."

  s.files        = Dir.glob("lib/**/*") + %w[LICENSE README.md Rakefile]
  s.require_path = "lib"

  s.add_runtime_dependency "resque", ">=1.20.0"

  s.add_development_dependency "rspec", "~>2.11.0"
end
