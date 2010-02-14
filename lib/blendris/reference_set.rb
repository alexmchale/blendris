module Blendris

  # RedisReferenceSet is a wrapper to a Redis set value and serves
  # as a pointer to multiple other blendris objects.

  class RedisReferenceSet < RedisReferenceBase

    include RedisNode
    include Enumerable

    def refs
      @refs ||= RedisSet.new(@key)
    end

    def set(*objs)
      objs.flatten!
      objs.compact!

      objs.each do |obj|
        if refkey = self.class.cast_to_redis(obj, @options)
          refs << refkey
          apply_reverse_add obj
        end
      end

      self
    end
    alias :<< :set

    def delete(obj)
      if refkey = self.class.cast_to_redis(obj, @options)
        deleted = refs.delete(refkey)
        apply_reverse_delete(obj) if deleted
        deleted
      end
    end

    def get
      self
    end

    def each
      redis.smembers(key).each do |refkey|
        yield self.class.cast_from_redis(refkey, @options)
      end
    end

    def include?(obj)
      refkey = self.class.cast_to_redis(obj, @options)

      refs.include? refkey
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
