module Blendris

  class RedisReferenceBase

    include RedisNode

    def initialize(key, options = {})
      @model = options[:model]
      @key = sanitize_key(key)
      @reverse = options[:reverse]

      if options[:class]
        @klass = constantize(camelize options[:class])

        unless @klass.ancestors.include? Model
          raise ArgumentError.new("#{klass.name} is not a model")
        end
      else
        @klass = Model
      end
    end

    def verify_object_type(value)
      unless value.nil? || value.kind_of?(@klass)
        raise TypeError.new("#{value.class.name} is not a #{@klass.name}")
      end
    end

    def apply_reverse_add(value)
      if @reverse && value
        reverse = value.redis_symbol(@reverse)
        reverse.assign_ref(@model) if !reverse.references @model
      end
    end

    def apply_reverse_delete(value)
      if @reverse && value
        reverse = value.redis_symbol(@reverse)
        reverse.remove_ref(@model) if reverse.references @model
      end
    end

    def references(value)
      return true if @ref.to_s.nil? && value.nil?
      return @ref.to_s == value.key
    end

    def self.cast(value)
      raise TypeError.new("#{value.class.name} is not a model to reference") unless value.kind_of? Model

      value.key
    end

  end

end
