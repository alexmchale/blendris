module Blendris

  # RedisSet is a wrapper to the Redis SET data type.

  class RedisSet < RedisNode

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

    def set(*values)
      self.clear

      values.flatten.compact.each do |v|
        redis.sadd key, v
      end

      self
    ensure
      notify_changed
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

    def count
      redis.scard key
    end

    # Set this set's members to the intersection of this set and the given set.
    def intersect!(other)
      redis.sinterstore key, key, other.key
    ensure
      notify_changed
    end

    # Set this set's members to the union of this set and the given set.
    def union!(other)
      redis.sunionstore key, key, other.key
    ensure
      notify_changed
    end

  end

end
