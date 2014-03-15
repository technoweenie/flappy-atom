{View} = require 'atom'
Phaser = require "./phaser.min"

module.exports =
class FlappyAtomView extends View
  @content: ->
    @div id:"flappy-container", class: 'flappy-atom overlay from-top'

  initialize: (serializeState) ->
    atom.workspaceView.command "flappy-atom:toggle", => @toggle()
    @game = new Phaser.Game 400, 490, Phaser.AUTO, "flappy-container"
    @game.state.add "main", @mainState()

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
      @startGame()

  startGame: ->
    @game.state.start "main"

  mainState: ->
    preload: ->
      @game.stage.backgroundColor = "#efeae1"
      @game.load.image "bird", "atom://flappy-atom/assets/atom.png"
      @game.load.image "pipe", "atom://flappy-atom/assets/laser.png"

    create: ->
      @bird = @game.add.sprite 100, 245, "bird"
      @bird.body.gravity.y = 1000

      @pipes = @game.add.group()
      @pipes.createMultiple 20, "pipe"

      spaceKey = @game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
      spaceKey.onDown.add @jump, @

      @timer = @game.time.events.loop 1500, @addRowOfPipes, @

      @score = 0
      @labelScore = @game.add.text 20, 20, "0",
        font: "30px Arial"
        fill: "#66595c"

    update: ->
      if not @bird.inWorld
        @restartGame()

      @game.physics.overlap @bird, @pipes, @restartGame, null, @

    jump: ->
      @bird.body.velocity.y = -300

    restartGame: ->
      @game.time.events.remove @timer
      @game.state.start "main"

    addOnePipe: (x, y) ->
      pipe = @pipes.getFirstDead()

      if pipe
        pipe.reset x, y
        pipe.body.velocity.x = -200
        pipe.outOfBoundsKill = true

    addRowOfPipes: ->
      hole = Math.floor(Math.random() * 5) + 1

      for num in [0..9]
        if num != hole && num != hole + 1
          @addOnePipe 400, num * 60

      @score += 1
      @labelScore.content = @score
