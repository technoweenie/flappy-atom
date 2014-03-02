{View} = require 'atom'

module.exports =
class FlappyAtomView extends View
  @content: ->
    @div class: 'flappy-atom overlay from-top', =>
      @div "The FlappyAtom package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "flappy-atom:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "FlappyAtomView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
