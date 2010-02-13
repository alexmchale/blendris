module Blendris

  module RedisAccessor

    include Utils

    def redis
      RedisAccessor.redis
    end

    def self.redis
      $_redis_connection ||= Redis.new
    end

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

    def self.database=(index)
      $_redis_connection = Redis.new(:db => index.to_i)
    end

    def self.flushdb
      redis.flushdb
    end

  end

end
