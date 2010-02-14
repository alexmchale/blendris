module Blendris

  # RedisReference is a wrapper to a Redis string value and serves
  # as a pointer to another blendris object.

  class RedisReference < RedisReferenceBase

    include RedisNode

    def ref
      @ref ||= RedisString.new(@key)
    end

    def set(obj)
      old_obj = self.get if @reverse
      modified = false
      refkey = self.class.cast_to_redis(obj, @options)

      if refkey == nil
        ref.set nil
        modified = true
      elsif refkey != ref.get
        ref.set refkey
        apply_reverse_add obj
        modified = true
      end

      apply_reverse_delete(old_obj) if modified

      obj
    end

    def get
      self.class.cast_from_redis ref.get
    end

    def assign_ref(value)
      self.set value
    end

    def remove_ref(value)
      self.set nil
    end

    def references(value)
      refval = ref.get

      return true if refval.nil? && value.nil?
      return refval == value.key
    end

  end

end
