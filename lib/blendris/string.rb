module Blendris

  class RedisString

    include RedisNode

    def initialize(key, options = {})
      @key = sanitize_key(key)
    end

    def set(value)
      if value
        redis.set key, value
      else
        redis.del key
      end
    end

    def get
      redis.get key
    end

    def to_s
      get
    end

    def self.cast(value)
      raise TypeError.new("#{value.class.name} is not a string") unless value.kind_of? String

      value
    end

  end

end
