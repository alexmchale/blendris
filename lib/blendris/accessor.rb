module Blendris

  class << self

    attr_accessor :host, :port, :database

    # Specify the host to connect to for the Redis connection.
    def host=(host)
      @host = host || "localhost"
      $_redis_connection = nil
    end

    # Specify the port to connect to for the Redis connection.
    def port=(port)
      @port = port.to_i
      @port = 6379 unless (1 .. 65535).include? @port
      $_redis_connection = nil
    end

    # Specify the database number to use in the Redis database.
    def database=(index)
      @database = index.to_i
      $_redis_connection = nil
    end

    # Retrieve the connection to the current Redis database.
    def redis
      parms =
        {
          :host => @host,
          :port => @port,
          :db   => @database
        }

      $_redis_connection ||= Redis.new(parms)
    end

    # This will delete all keys in the current database.  Dangerous!
    def flushdb
      redis.flushdb
    end

  end

  # This module serves as a gateway to the Redis library.  Any object
  # that needs to access Redis directly should include it.

  module RedisAccessor

    include Utils

    def redis
      Blendris.redis
    end

    def self.redis
      Blendris.redis
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

          options = klass.redis_symbols[symbol.to_s]
          raise ArgumentError.new("#{self.name} is missing its #{symbol}") unless options

          subklass = options[:type]
          raise ArgumentError.new("#{symbol} (#{subklass.name}) cannot be used in the key") unless subklass.respond_to? :cast_to_redis

          subklass.cast_to_redis value, options

        else
          raise TypeError.new("only strings and symbols allowed in key definition for #{klass.name} (#{symbol.class.name})")

        end
      end.map do |segment|
        sanitize_key segment
      end.compact.join(":")
    end

    # Build a new temporary set with the given contents, yielding it to
    # the passed block.  After the block exits, destroy the temporary set.
    def in_temporary_set(*contents)
      index = RedisInteger.new("blendris:temporary:index").increment

      temporary_set = RedisSet.new("blendris:temporary:set:#{index}")
      temporary_set << contents

      begin
        yield temporary_set
      ensure
        temporary_set.clear
      end

      self
    end

  end

end
