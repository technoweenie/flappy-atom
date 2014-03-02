FlappyAtomView = require './flappy-atom-view'

module.exports =
  flappyAtomView: null

  activate: (state) ->
    @flappyAtomView = new FlappyAtomView(state.flappyAtomViewState)

  deactivate: ->
    @flappyAtomView.destroy()

  serialize: ->
    flappyAtomViewState: @flappyAtomView.serialize()
