module Blendris

  class RedisReferenceSet < RedisReferenceBase

    include RedisNode
    include Enumerable

    def refs
      @refs ||= RedisSet.new(@key)
    end

    def set(*values)
      values.flatten!
      values.compact!

      values.each do |value|
        verify_object_type value
        next unless value

        refs << value.key
        apply_reverse_add value
      end

      self
    end
    alias :<< :set

    def delete(value)
      verify_object_type(value)
      return unless value

      deleted = refs.delete(value.key)
      apply_reverse_delete(value) if deleted
      deleted
    end

    def get
      self
    end

    def each
      redis.smembers(key).each do |refkey|
        klass = constantize(redis.get(prefix + refkey))
        yield klass.new(refkey)
      end
    end

    def include?(value)
      subkey = value.key if value.kind_of? @klass
      subkey ||= value.to_s

      refs.include? subkey
    end

    def assign_ref(*values)
      self.set *values
    end

    def remove_ref(value)
      self.delete value
    end

    def references(value)
      self.include? value
    end

  end

end
