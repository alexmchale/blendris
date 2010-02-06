module Blendris

  class RedisReference < RedisReferenceBase

    include RedisNode

    def ref
      @ref ||= RedisString.new(@key)
    end

    def set(value)
      verify_object_type value

      old_value = self.get if @reverse
      modified = false

      if value.nil?
        ref.set nil
        modified = true
      elsif value.key != ref.to_s
        ref.set value.key
        apply_reverse_add value
        modified = true
      end

      apply_reverse_delete(old_value) if modified

      value
    end

    def get
      refkey = ref.to_s
      klass = constantize(redis.get(prefix + refkey)) if refkey
      klass.new(refkey) if klass
    end

    def assign_ref(value)
      self.set value
    end

    def remove_ref(value)
      self.set nil
    end

    def references(value)
      return true if ref.to_s.nil? && value.nil?
      return ref.to_s == value.key
    end

  end

end
