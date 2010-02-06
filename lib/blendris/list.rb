module Blendris

  class RedisList

    include RedisNode
    include Enumerable

    def initialize(key, options = {})
      @key = key.to_s
      @options = options
    end

    def each
      redis.lrange(key, 0, -1).each do |value|
        yield value
      end
    end

    def <<(value)
      [ value ].flatten.compact.each do |v|
        redis.rpush key, v
      end

      self
    end

    def get
      self
    end

    def delete(value)
      redis.lrem key, 0, value
    end

  end

end
