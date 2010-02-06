module Blendris

  class RedisSet

    include RedisNode
    include Enumerable

    def initialize(key, options = {})
      @key = key.to_s
      @options = options
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
    end

    def get
      self
    end

    def delete(value)
      redis.srem key, value
    end

  end

end
