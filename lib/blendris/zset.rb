module Blendris

  # RedisSortedSet is a wrapper to the Redis ZSET data type.

  class RedisSortedSet < RedisNode

    include Enumerable

    def initialize(key, options = {})
      @key = key.to_s
      @options = options
      @on_change = options[:on_change]
    end

    def each(min = "-inf", max = "+inf", mode = :score)
      case mode
      when :rank  then redis.zrange key, min, max
      when :score then redis.zrangebyscore key, min, max
      else             raise "unknown zset mode #{mode}"
      end.each do |value|
        yield value
      end

      self
    end

    def each_with_scores(min = "-inf", max = "+inf", mode = :score)
      flat_pairs =
        case mode
        when :rank  then redis.zrange key, min, max, :with_scores => true
        when :score then redis.zrangebyscore key, min, max, :with_scores => true
        else             raise "unknown zset mode #{mode}"
        end

      pairify(flat_pairs).each do |value, score|
        yield score.to_f, value
      end

      self
    end

    def set(*pairs)
      tempkey = "#{key}:::TEMP:::#{rand}"
      redis.del tempkey

      pairify(pairs).each do |score, value|
        redis.zadd tempkey, score, value
      end

      redis.rename tempkey, key

      self
    ensure
      notify_changed
    end

    def <<(pairs)
      tempkey = "#{key}:::TEMP:::#{rand}"
      redis.del tempkey

      pairify(pairs).each do |score, value|
        redis.zadd tempkey, score, value
      end

      redis.zunionstore key, [ key, tempkey ]
      redis.del tempkey

      self
    ensure
      notify_changed
    end

    def get
      self
    end

    def delete(value)
      redis.zrem key, value
    ensure
      notify_changed
    end

    def delete_by_score(min, max)
      redis.zremrangebyscore key, min, max
    ensure
      notify_changed
    end

    # Set this zset's members to the intersection of this set and the given set.
    def intersect!(other)
      redis.zinterstore key, [ key, other.key ]
    ensure
      notify_changed
    end

    # Set this zset's members to the union of this set and the given set.
    def union!(other)
      redis.zunionstore key, [ key, other.key ]
    ensure
      notify_changed
    end

    def count
      redis.zcard key
    end

  end

end
