module Blendris

  class RedisInteger

    include RedisNode

    def initialize(key, options = {})
      @key = sanitize_key(key)
      @default = options[:default]

      set(@default) if @default && get.nil?
    end

    def set(value)
      if value
        redis.set key, value.to_i
      else
        redis.del key
      end
    end

    def get
      value = redis.get(key)

      value.to_i if value
    end

    def to_i
      get
    end

    def self.cast(value)
      raise TypeError.new("#{value.class.name} is not a string") unless value.kind_of? Fixnum

      value
    end

  end

end
