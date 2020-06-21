# Serializing functionality to save and restore a game

require 'json'

module Serializable
  EXTENSION = 'json'
  def serialize
    to_serialize = instance_variables.reduce({}) do |object, variable|
      object[variable] = instance_variable_get variable
      object
    end

    JSON::dump to_serialize
  end

  def deserialize(string)
    object = JSON::parse string
    object.each do |variable, value|
      instance_variable_set variable, value
    end
  end
end