module Blendris

  # RedisSet is a wrapper to the Redis SET data type.

  class RedisSet

    include RedisNode
    include Enumerable

    def initialize(key, options = {})
      @key = key.to_s
      @options = options
      @on_change = options[:on_change]
    end

    def each
      redis.smembers(key).each do |value|
        yield value
      end

      self
    end

    def <<(value)
      [ value ].flatten.compact.each do |v|
        redis.sadd key, v
      end

      self
    ensure
      notify_changed
    end

    def get
      self
    end

    def delete(value)
      redis.srem key, value
    ensure
      notify_changed
    end

  end

end
