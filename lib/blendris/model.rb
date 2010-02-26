module Blendris

  # Model is the main driver for Blendris.  All Blendris objects
  # will inherit from it to function as a database model.

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

    # Look up the given symbol by its name.  The list of symbols are defined
    # when the model is declared.
    def [](name)
      name = name.to_s

      subkey = self.subkey(name)

      options = self.class.redis_symbols[name]

      return unless options

      on_change = lambda { self.fire_on_change_for name }
      options = options.merge(:model => self, :on_change => on_change)

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

    # Return a list of field names for this model.
    def fields
      self.class.redis_symbols.map {|name, field| name.to_s}
    end

    # Fire the list of blocks called when the given symbol changes.
    def fire_on_change_for(symbol)
      blocks = [ self.class.on_change_table[nil], self.class.on_change_table[symbol.to_s] ]

      blocks.flatten!
      blocks.compact!

      blocks.each do |block|
        self.instance_exec symbol.to_s, &block
      end
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
          obj[parm].set args[i]
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
        "blendris:index:model:#{self.name}"
      end

      # Defines a new data type for Blendris:Model construction.
      def type(name, klass)
        (class << self; self; end).instance_eval do
          define_method(name) do |*args|
            varname = args.shift.to_s
            options = args.shift || {}

            options[:type] = klass
            redis_symbols[varname] = options

            # Declare the getter for this field.
            define_method(varname) do
              self[varname].get
            end

            # Declare the setter for this field, if it is not a key field.
            unless local_parameters.find {|p| p.to_s == varname}
              define_method("#{varname}=") do |value|
                self[varname].set value
              end
            end
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

      # Define a block to call when one of the given symbol values changes.
      def on_change(*symbols, &block)
        symbols.flatten!
        symbols.compact!

        if symbols.count == 0
          on_change_table[nil] ||= []
          on_change_table[nil] << block
        else
          symbols.each do |symbol|
            on_change_table[symbol.to_s] ||= []
            on_change_table[symbol.to_s] << block
          end
        end
      end

      # The hash of blocks called when fields on this object change.
      def on_change_table
        @on_change_table ||= {}
      end

    end

  end

end
