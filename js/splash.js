function mainMenuCreate(scene) {
  splash = scene.add.sprite(0, 0, 'splash1').setOrigin(0).setScale(.35, .4).setInteractive();
  maxxdaddy = scene.add.image(game.config.width * .93, game.config.height * 0.93, 'maxxdaddy');
  splash.on('pointerdown', function (pointer) {
    StartGame(pointer);
  });
}

function StartGame(pointer) {
  console.log(Math.floor(pointer.x), Math.floor(pointer.y));
  return;
  maxxdaddy.visible = false;
  game.fireButton = null;
  splash.visible = false;
  gameCreate(scene, game);
  startGame = true;
}