$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Blendris
  VERSION = '0.0.1'
end

require "blendris/errors"
require "blendris/utils"

require "blendris/accessor"
require "blendris/node"

require "blendris/string"
require "blendris/list"
require "blendris/set"

require "blendris/reference_base"
require "blendris/reference"
require "blendris/reference_set"

require "blendris/model"
