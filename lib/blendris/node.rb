module Blendris

  # RedisNode is used to compose all Redis value wrapper classes.
  module RedisNode

    include RedisAccessor

    attr_reader :key

    def initialize(key, options = {})
      @key = sanitize_key(key)
      @default = options[:default]
      @options = options

      set(@default) if @default && !redis.exists(self.key)
    end

    def set(value)
      if value
        redis.set key, self.class.cast_to_redis(value, @options)
      else
        redis.del key
      end
    end

    def get
      self.class.cast_from_redis redis.get(self.key), @options
    end

    def clear
      redis.del key
    end

    def type
      redis.type key
    end

    def exists?
      redis.exists key
    end

  end

end
