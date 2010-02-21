module Blendris

  # RedisNode is used to compose all Redis value wrapper classes.

  module RedisNode

    include RedisAccessor

    attr_reader :key

    def initialize(key, options = {})
      @key = sanitize_key(key)
      @default = options[:default]
      @options = options
      @on_change = options[:on_change]

      if @default && !redis.exists(self.key)
        redis.set key, self.class.cast_to_redis(@default, @options)
      end
    end

    def set(value)
      if value
        redis.set key, self.class.cast_to_redis(value, @options)
      else
        redis.del key
      end
    ensure
      notify_changed
    end

    def get
      self.class.cast_from_redis redis.get(self.key), @options
    end

    def rename(newkey)
      redis.rename @key, sanitize_key(newkey)

      @key = newkey
    end

    def clear
      redis.del key
    ensure
      notify_changed
    end

    def type
      redis.type key
    end

    def exists?
      redis.exists key
    end

    def notify_changed
      @on_change.call if @on_change
    end

  end

end
