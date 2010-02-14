module Blendris

  # RedisString is a wrapper to the Redis string data type.

  class RedisString

    include RedisNode

    def self.cast_to_redis(value, options = {})
      raise TypeError.new("#{value.class.name} is not a string") unless value.kind_of? String

      value
    end

    def self.cast_from_redis(value, options = {})
      value
    end

  end

end
