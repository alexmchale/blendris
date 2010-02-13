module Blendris

  class Model

    include RedisAccessor

    attr_reader :key

    # Instantiate a new instance of this model.  We do some basic
    # checking to make sure that this object already exists in Redis
    # as the requested type.  This is to prevent keys being used in
    # the wrong way.

    # If the :verify option isn't set to false, then each field of
    # this model is also verified.

    def initialize(new_key, options = {})
      @key = sanitize_key(new_key)
      actual_type = constantize(redis.get(key))

      raise ArgumentError.new("#{self.class.name} second argument must be a hash") unless options.kind_of? Hash
      raise TypeError.new("#{key} does not exist, not a #{self.class.name} - you may want create instead of new") if !actual_type
      raise TypeError.new("#{key} is a #{actual_type}, not a #{self.class.name}") if actual_type != self.class

      if options[:verify] != false
        parameters = self.class.local_parameters.find_all {|s| s.kind_of? Symbol}
        dne = parameters.find {|p| not self.send(p.to_s)}

        raise ArgumentError.new("#{self.class.name} #{key} is missing its #{dne}") if dne
        raise ArgumentError.new("blank keys are not allowed") if @key.length == 0
      end
    end

    # An object's id is considered to be the SHA1 digest of its key.  This is
    # to ensure that all objects that represent the same key return the same id.
    def id
      Digest::SHA1.hexdigest key
    end

    # TODO: Create the methods in the initialize method instead of depending
    # on method_missing to dispatch to the correct methods.  This will make
    # these objects better for mocking and stubbing.
    def method_missing(method_sym, *arguments)
      (name, setter) = method_sym.to_s.scan(/(.*[^=])(=)?/).first

      if node = redis_symbol(name)
        if setter
          return node.set *arguments
        else
          return node.get
        end
      end

      super
    end

    # Look up the given symbol by its name.  The list of symbols are defined
    # when the model is declared.
    # TODO: This can also probably go away when I remove the need for method_missing.
    def redis_symbol(name)
      subkey = self.subkey(name)

      options = self.class.redis_symbols[name.to_s]

      return unless options

      options = options.merge(:model => self)

      options[:type].new subkey, options
    end

    # Calculate the key to address the given child node.
    def subkey(child)
      sanitize_key "#{self.key}:#{child}"
    end

    # Compare two instances.  If two instances have the same class and key, they are equal.
    def ==(other)
      return false unless self.class == other.class
      return self.key == other.key
    end

    class << self

      include RedisAccessor
      include Enumerable

      # This method will instantiate a new object with the correct key
      # and assign the values passed to it.
      def create(*args)
        parameters = local_parameters.find_all {|s| s.kind_of? Symbol}
        got = args.count
        wanted = parameters.count

        if got != wanted
          msg = "wrong number of arguments for a new #{self.class.name} (%d for %d)" % [ got, wanted ]
          raise ArgumentError.new(msg)
        end

        key = generate_key(self, args)
        current_model = redis.get(key)

        if current_model && current_model != self.name
          raise ArgumentError.new("#{key} is a #{current_model}, not a #{self.name}")
        end

        redis.set key, self.name
        redis.sadd index_key, key

        obj = new(key, :verify => false)

        parameters.each_with_index do |parm, i|
          obj.redis_symbol(parm).set args[i]
        end

        obj
      end

      def key(*fields)
        @local_parameters = fields

        @local_parameters.flatten!
        @local_parameters.compact!

        nil
      end

      def each
        RedisSet.new(index_key).each {|k| yield new(k)}
      end

      def index_key
        "index:model:#{self.name}"
      end

      # Defines a new data type for Blendris:Model construction.
      def type(name, klass)
        (class << self; self; end).instance_eval do
          define_method(name) do |*args|
            varname = args.shift.to_s
            options = args.shift || {}

            options[:type] = klass
            redis_symbols[varname] = options
          end
        end
      end

      # Variables stored in the Redis database.
      def redis_symbols
        @redis_symbols ||= {}
      end

      # Parameters used when creating a new copy of this model.
      def local_parameters
        @local_parameters ||= []
      end

      # Take a value and attempt to make it fit the given field.
      def cast_value(symbol, value)
        options = redis_symbols[symbol.to_s]
        raise ArgumentError.new("#{self.name} is missing its #{symbol}") unless options

        options[:type].cast_to_redis value, options
      end

    end

  end

end
