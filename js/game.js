var config = {
  type: Phaser.AUTO,
  width: 1000,
  height: 600,
  parent: 'canvas',
  backgroundColor: '#4488aa',
  scene: {
    preload: preload,
    create: create,
    update: update,
  }
};

var game = new Phaser.Game(config);
function create() {
  wall = this.add.sprite(0,0,'wall').setScale(2);
  puker = this.add.sprite(game.config.width*.75, game.config.height*.5, 'puker');
  this.anims.create({
    key: 'pukerWalking',
    frames: this.anims.generateFrameNumbers('puker',
      {
        start: 0,
        end: 9
      }),
    frameRate: 16,
    repeat: -1
  });
  puker.anims.play('pukerWalking')
  startGame = false;
};


function update() {
  if (!startGame)
    return;
}


