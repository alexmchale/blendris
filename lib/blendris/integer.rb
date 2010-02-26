module Blendris

  # RedisInteger is a string-value in Redis wrapped up to make
  # sure that it is used as an integer.

  class RedisInteger < RedisNode

    def self.cast_to_redis(value, options = {})
      raise TypeError.new("#{value.class.name} is not an integer") unless value.kind_of? Fixnum

      value.to_s
    end

    def self.cast_from_redis(value, options = {})
      value.to_i if value
    end

    def increment
      redis.incr key
    ensure
      notify_changed
    end

    def decrement
      redis.decr key
    ensure
      notify_changed
    end

  end

end
