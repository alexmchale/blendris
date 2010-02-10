module Blendris

  class RedisReferenceBase

    include RedisNode
    extend RedisAccessor

    def initialize(key, options = {})
      @model = options[:model]
      @key = sanitize_key(key)
      @reverse = options[:reverse]
      @options = options

      @klass = options[:class] || Model
      @klass = constantize(camelize @klass) if @klass.kind_of? String

      unless @klass.ancestors.include? Model
        raise ArgumentError.new("#{klass.name} is not a model")
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

    def self.cast_to_redis(obj, options = {})
      expect = options[:class] || Model
      expect = constantize(expect) if expect.kind_of? String
      expect = Model unless expect.ancestors.include? Model

      if obj == nil
        nil
      elsif obj.kind_of? expect
        obj.key
      else
        raise TypeError.new("#{obj.class.name} is not a #{expect.name}")
      end
    end

    def self.cast_from_redis(refkey, options = {})
      expect = options[:class] || Model
      expect = constantize(expect) if expect.kind_of? String
      expect = Model unless expect.ancestors.include? Model

      klass = constantize(redis.get(prefix + refkey)) if refkey

      if klass == nil
        nil
      elsif klass.ancestors.include? expect
        klass.new refkey
      else
        raise TypeError.new("#{klass.name} is not a #{expect.name}")
      end
    end

  end

end
