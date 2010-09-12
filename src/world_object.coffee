###
Orona, © 2010 Stéphan Kochen

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
###


# The types indexed by their charId.
types = {}


# The base class of world objects.
class WorldObject
  # This is a single character identifier for this class. It's handy for type checks without
  # having to require the module, but is also used as the network identifier.
  charId: null

  # Whether objects of this class are drawn using the regular 'base' tilemap, or the styled
  # tilemap. May also be `null`, in which case the object is not drawn at all.
  styled: null

  # The world coordinates of this object. A special value of -1 for either means that the object
  # is 'not in the world'. For now, only used by dead tanks.
  x: null
  y: null

  # Abstract methods.

  # The constructor takes a Simulation object.
  constructor: (sim) ->

  # Called just before the object is removed from the simulation.
  destroy: ->

  # When an object is created by the networking code, it is instantiated using a blank constructor.
  # This function is then the first to be called, and responsible for loading state from the data
  # parameter, usually with a call to deserialize. The return value is the number of bytes used.
  initFromNetwork: (sim, data, offset) ->

  # The alternate destructor called when the object is destroyed by the networking code.
  destroyFromNetwork: ->

  # This method should return an array of bytes that represent the object's state somehow.
  # It usually calls struct.pack() to pack all of it's state variables.
  serialize: ->

  # This methods takes an array of bytes and an optional offset, at which to find data originally
  # generated by serialize. This method is then responsible for translating that data back into
  # object state, usually calling struct.unpack() to do so. Finally, it returns the number of
  # bytes it used.
  deserialize: (data, offset) ->

  # Simulate a tick.
  update: ->

  # Return the (x,y) index in the tilemap (base or styled, selected above) that the object should
  # be drawn with.
  getTile: ->

  # Class methods.

  # Called by CoffeeScript when subclassed.
  @extended: (child) ->
    # Make the register class method available on the subclass.
    child.register = @register

  # Find a type by character or character code.
  @getType: (char) ->
    char = String.fromCharCode(char) if typeof(char) != 'string'
    types[char]

  # This should be called after a class is defined.
  # FIXME: Would be neat if this were automagic somehow.
  @register: ->
    # Add to the index.
    types[@::charId] = this
    # Set the character code, which is the network identifier.
    @::charCodeId = @::charId.charCodeAt(0)


# Exports.
module.exports = WorldObject