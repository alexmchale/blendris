module Blendris

  # RedisNode is used to compose all Redis value wrapper classes.

  module RedisNode

    include RedisAccessor

    attr_reader :key

    # Initialize a new node, which represents a basic Redis data object.
    #
    # === Parameters ===
    #
    # * :on_change - Pass a block to be run within the context of this object
    #   when its value is changed.
    # * :default - Use the given value as a default value.
    def initialize(key, options = {})
      @key = sanitize_key(key)
      @default = options[:default]
      @options = options
      @on_change = options[:on_change]

      if @default && !redis.exists(self.key)
        redis.set key, self.class.cast_to_redis(@default, @options)
      end
    end

    # Set this object's value to be the given value.
    #
    # * The method cast_to_redis should be overridden by classes that
    #   include this module, as it is used to determine how to convert
    #   the given value to a redis string.
    # * The on_change block is always called after this method.
    def set(value)
      if value
        redis.set key, self.class.cast_to_redis(value, @options)
      else
        redis.del key
      end
    ensure
      notify_changed
    end

    # Retrieve the value of this object and cast it.
    #
    # * The method cast_from_redis should be overridden by classes that
    #   include this module.  It is used to convert the redis string
    #   to this specific object type.
    def get
      self.class.cast_from_redis redis.get(self.key), @options
    end

    # Rename this key to the given new key name.
    def rename(newkey)
      redis.rename @key, sanitize_key(newkey)

      @key = newkey
    end

    def clear
      redis.del key
    ensure
      notify_changed
    end

    def type
      redis.type key
    end

    def exists?
      redis.exists key
    end

    def notify_changed
      @on_change.call if @on_change
    end

  end

end
