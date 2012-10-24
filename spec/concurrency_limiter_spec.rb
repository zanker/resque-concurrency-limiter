require "resque"
require "resque/plugins/concurrency_limiter"

describe Resque::Plugins::ConcurrencyLimiter do
  class LockTest
    extend Resque::Plugins::ConcurrencyLimiter
    @queue = :conc_test

    def self.perform(args)
      raise "Perform ran"
    end
  end

  it "passes lint" do
    lambda {
      Resque::Plugin.lint(Resque::Plugins::ConcurrencyLimiter)
    }.should_not raise_exception
  end

  it "runs on resque version" do
    Resque::Plugin.respond_to?(:before_enqueue_hooks).should be_true
    Resque::Plugin.respond_to?(:around_hooks).should be_true
    Resque::Plugin.respond_to?(:failure_hooks).should be_true
  end

  it "enqueues a job up to the limit" do
    3.times { Resque.enqueue(LockTest, {"a" => 1, "b" => 2})}

    Resque.redis.llen("queue:conc_test").should have(1).job

    3.times do |i|
      Resque.enqueue(LockTest, {"a" => i})
    end

    Resque.redis.llne("queue:conc_test").should have(4).jobs
  end
end