$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Blendris
  VERSION = '1.0'
end

require "redis"

require "blendris/errors"
require "blendris/utils"

require "blendris/accessor"
require "blendris/node"

require "blendris/model"

require "blendris/string"
require "blendris/integer"
require "blendris/list"
require "blendris/set"
require "blendris/zset"

require "blendris/reference_base"
require "blendris/reference"
require "blendris/reference_set"

require "blendris/types"
