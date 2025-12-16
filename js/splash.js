function mainMenuCreate(scene) {
  game_state = GAME_STATE.INTRO;
  splash = scene.add.sprite(0, 0, 'splash1').setOrigin(0).setInteractive().setDisplaySize(game.config.width, game.config.height);
  instructions = scene.add.sprite(0, 0, 'instructions').setOrigin(0).setVisible(false).setInteractive().setDisplaySize(game.config.width, game.config.height);
  scoreboard = scene.add.sprite(0, 0, 'scoreboard').setOrigin(0).setVisible(false).setInteractive().setDisplaySize(game.config.width, game.config.height);
  maxxdaddy = scene.add.image(game.config.width * .92, game.config.height * 0.94, 'maxxdaddy');

  splash.on('pointerdown', function (pointer) {
    SetSplashState(pointer);
  });
  instructions.on('pointerdown', function (pointer) {
    SetSplashState(pointer);
  });
  scoreboard.on('pointerdown', function (pointer) {
    SetSplashState(pointer);
  });
}

function SetSplashState(pointer) {
  if (game_state == GAME_STATE.INTRO && Phaser.Geom.Polygon.Contains(startButtonShape, pointer.x, pointer.y)) {
    maxxdaddy.visible = false;
    game.fireButton = null;
    splash.visible = false;
    game_state = GAME_STATE.LEVEL_1;
    gameCreate(scene, game);
    startGame = true;
  }
  else if (game_state == GAME_STATE.INTRO && Phaser.Geom.Polygon.Contains(instructionsButtonShape, pointer.x, pointer.y)) {
    maxxdaddy.visible = false;
    game_state = GAME_STATE.INSTRUCTIONS;
    splash.visible = false;
    instructions.visible = true;
  }
  else if (game_state == GAME_STATE.INSTRUCTIONS && Phaser.Geom.Polygon.Contains(exitInstructionsShape, pointer.x, pointer.y)) {
    game_state = GAME_STATE.INTRO;
    splash.visible = true;
    instructions.visible = false;
  }
  else if (game_state == GAME_STATE.INTRO && Phaser.Geom.Polygon.Contains(scoreboardButtonShape, pointer.x, pointer.y)) {
    maxxdaddy.visible = false;
    game_state = GAME_STATE.SCOREBOARD;
    splash.visible = false;
    instructions.visible = false;
    scoreboard.visible = true;
  }
  else if (game_state == GAME_STATE.SCOREBOARD && Phaser.Geom.Polygon.Contains(exitScoreboardShape, pointer.x, pointer.y)) {
    game_state = GAME_STATE.INTRO;
    splash.visible = true;
    scoreboard.visible = false;
  }
}
