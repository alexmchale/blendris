module Blendris

  # Define what types are built into blendris models.

  class Model

    type :string, RedisString
    type :integer, RedisInteger
    type :set, RedisSet
    type :list, RedisList
    type :ref, RedisReference
    type :refs, RedisReferenceSet

  end

end
