var config = {
  type: Phaser.WEBGL,
  width: 1000,
  height: 550,
  parent: 'canvas',
  backgroundColor: '#4488aa',
  scene: {
    preload: preload,
    create: create,
    update: update,
  },
  dom: {
    createContainer: true
  },
  callbacks: {
    postBoot: function (game) {
      window.addEventListener("resize", () => {
        game.scale.resize(window.innerWidth, window.innerHeight);
      });
    }
  }
};
let screenWidth = window.innerWidth * window.devicePixelRatio;
let screenHeight = window.innerHeight * window.devicePixelRatio;
var game = new Phaser.Game(config);
function create() {
  floor = this.add.plane(game.config.width/2,336,'floor');

  // floor.createCheckerboard();
   floor.setGridSize(16, 16);
   floor.uvScale(16,16);
   floor.setViewHeight(512);
   floor.viewPosition.z = 1.6;
   floor.rotateX = 285;
   floor.setScale(1.6);
//floor.visible = false;   
//FLOOR SHADOW
wall = this.add.sprite(0,0,'wall').setOrigin(0,0).setScale(1.5);
wall2 = this.add.sprite(-1000,0,'wall').setOrigin(0,0).setScale(1.5);
 var texture = this.textures.createCanvas('gradient', game.config.width, floorTextureHeight);
   const grd = texture.context.createLinearGradient(0, 0, 0, floorTextureHeight);
   grd.addColorStop(0, "rgba(0, 0, 0, .8)");
   grd.addColorStop(1, "rgba(0, 0, 0, 0)");
 
   texture.context.fillStyle = grd;
   texture.context.fillRect(0, 0, game.config.width, floorTextureHeight);

   //  Call this if running under WebGL, or you'll see nothing change
   texture.refresh();
   floorShadow = this.add.image(500 , 386, 'gradient');
  puker = this.add.sprite(game.config.width*.8, game.config.height*.5, 'puker');
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

  floor.uvScroll(-0.012,0);

}

function update() {
  if (!startGame)
    return;
  DoWallAndFloorStuff();
}


