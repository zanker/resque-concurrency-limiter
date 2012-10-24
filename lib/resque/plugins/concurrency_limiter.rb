module Resque
  module Plugins
    module ConcurrencyLimiter
      def queue_limit
        @queue_limit || 1
      end

      def concurrency_key(type, *args)
        "conc-#{type}:#{name}-#{args.to_s}"
      end

      # This can be overridden however you want.
      # Such as enqueuing it in a lower priority queue, or if you use resque-scheduler, to try again in 30 seconds.
      def requeue(*args)
        Resque.enqueue(self, *args)
      end

      def before_enqueue_concurrency(*args)
        normalized = Resque.decode(Resque.encode(args))
        key = concurrency_key("lock", normalized)

        if Resque.redis.incr(key) <= queue_limit
          true

        # Have too many queued already, revert our increment
        else
          Resque.redis.decr(key)
          false
        end
      end

      def around_perform_concurrency(*args)
        # Job has been removed from the queue, need to decrement here in case
        # we couldn't get the lock and it increments again.
        Resque.redis.decr(concurrency_key("lock", args))

        lock = Resque.redis.setnx(concurrency_key("active", args), true)
        # Couldn't get the lock, requeue and will run it again later
        unless lock
          self.resqueue(args)
          return
        end

        begin
          yield
        ensure
          Resque.redis.del(concurrency_key("active", args))
        end
      end

      # Clear our lock on running the job
      def on_failure_concurrency(error, *args)
        Resque.redis.del(concurrency_key("active", args))
      end
    end
  end
end

