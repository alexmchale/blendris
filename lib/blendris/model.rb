module Blendris

  class Model

    include RedisAccessor

    attr_reader :key

    def initialize(new_key, options = {})
      @key = sanitize_key(new_key)
      actual_type = constantize(redis.get(prefix + key))

      raise ArgumentError.new("#{self.class.name} second argument must be a hash") unless options.kind_of? Hash
      raise TypeError.new("#{prefix + key} does not exist, not a #{self.class.name} - you may want create instead of new") if !actual_type
      raise TypeError.new("#{prefix + key} is a #{actual_type}, not a #{self.class.name}") if actual_type != self.class

      if options[:verify] != false
        parameters = self.class.local_parameters.find_all {|s| s.kind_of? Symbol}
        dne = parameters.find {|p| not self.send(p.to_s)}

        raise ArgumentError.new("#{self.class.name} #{key} is missing its #{dne}") if dne
        raise ArgumentError.new("blank keys are not allowed") if @key.length == 0
      end
    end

    def id
      Digest::SHA1.hexdigest key
    end

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

    def redis_symbol(name)
      subkey = self.subkey(name)

      options = self.class.redis_symbols[name.to_s]

      return unless options

      options = options.merge(:model => self)

      options[:type].new subkey, options
    end

    def subkey(key)
      sanitize_key "#{self.key}:#{key}"
    end

    def ==(other)
      return false unless self.class == other.class
      return self.key == other.key
    end

    class << self

      include RedisAccessor

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
        current_model = redis.get(prefix + key)

        if current_model && current_model != self.name
          raise ArgumentError.new("#{key} is a #{current_model}, not a #{self.name}")
        end

        redis.set(prefix + key, self.name)

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
