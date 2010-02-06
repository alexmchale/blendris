module Blendris

  module RedisNode

    include RedisAccessor

    def key
      prefix + @key
    end

    def clear
      redis.del key
    end

    def type
      redis.type key
    end

    def exists?
      redis.exists key
    end

  end

end
