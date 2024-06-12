var config = {
  type: Phaser.AUTO,
  width: 1000,
  height: 550,
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
  wall = this.add.sprite(0,0,'wall').setOrigin(0,0);
  wall2 = this.add.sprite(-1000,0,'wall').setOrigin(0,0);
  //floor = this.add.sprite(200,game.config.height*.285,'floor').setOrigin(0).setScale(2);
  floor = this.add.plane(game.config.width/2, 290);

  floor.createCheckerboard();
  floor.setGridSize(16, 16);
  floor.uvScale(16, 16);
  floor.setViewHeight(512);
  floor.viewPosition.z = 1.6;
  floor.rotateX = 285;
  floor.setScale(1.6);


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
  startGame = true;
};

function DoWallAndFloorStuff(){
  if(wall.x<1000)
    wall.x++;
  else
  wall.x=-999;
  if(wall2.x<1000)
    wall2.x++;
  else
  wall2.x=-999;

  floor.uvScroll(-0.015,0);

}

function update() {
  if (!startGame)
    return;
  DoWallAndFloorStuff();
}


