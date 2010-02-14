module Blendris

  # This module serves as a gateway to the Redis library.  Any object
  # that needs to access Redis directly should include it.

  module RedisAccessor

    include Utils

    def redis
      RedisAccessor.redis
    end

    def self.redis
      $_redis_connection ||= Redis.new
    end

    # Generate a key for the given model class with the given values list.
    # This is used to determine a new object's key in the Model.create method.
    def generate_key(klass, values)
      value_index = 0

      klass.local_parameters.map do |symbol|
        case symbol

        when String then symbol

        when Symbol
          value = values[value_index]
          value_index += 1

          raise ArgumentError.new("#{self.name} created without #{symbol}") unless value

          klass.cast_value symbol, value

        else
          raise TypeError.new("only strings and symbols allowed in key definition for #{klass.name} (#{symbol.class.name})")

        end
      end.map do |segment|
        sanitize_key segment
      end.compact.join(":")
    end

    # Change which database we're accessing in Redis.
    def self.database=(index)
      $_redis_connection = Redis.new(:db => index.to_i)
    end

    # This will delete all keys in the current database.  Dangerous!
    def self.flushdb
      redis.flushdb
    end

  end

end
