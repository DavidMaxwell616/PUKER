function mainMenuCreate(scene,game) {
    splash = scene.add.sprite(0,0, 'splash').setOrigin(0).setScale(.35,.4).setInteractive();
    maxxdaddy = scene.add.image(game.config.width *.93, game.config.height * 0.93, 'maxxdaddy');
  
    splash.on('pointerdown', function (pointer)
    {

        StartGame();

    });

  }
  
  function mainMenuShowSplash() {
    splash.visible = true;
  }
  
  function mainMenuUpdate() {
    if (game.fireButton.isDown) {StartGame();}
  }
  
  function StartGame(){
    maxxdaddy.visible = false;
  game.fireButton = null;
  splash.visible = false;
  gameCreate(scene,game);
  startGame = true;
  }