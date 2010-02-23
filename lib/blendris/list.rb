module Blendris

  # RedisList is a wrapper for the Redis LIST data type.

  class RedisList < RedisNode

    include Enumerable

    def initialize(key, options = {})
      @key = key.to_s
      @options = options
      @on_change = options[:on_change]
    end

    def each
      redis.lrange(key, 0, -1).each do |value|
        yield value
      end
    end

    def <<(value)
      values = [ value ].flatten.compact

      values.flatten.compact.each do |v|
        redis.rpush key, v
      end

      notify_changed if values.count > 0

      self
    end

    def get
      self
    end

    def delete(value)
      redis.lrem key, 0, value
    ensure
      notify_changed
    end

  end

end
