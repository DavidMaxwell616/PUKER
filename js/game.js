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
var scene;
function create() {
  scene = this;  
  if (!startGame) mainMenuCreate(scene,game);
  else gameCreate(scene);
  }

  function gameCreate(scene){
  floor = scene.add.plane(game.config.width/2,336,'floor');
  // floor.createCheckerboard();
   floor.setGridSize(16, 16);
   floor.uvScale(16,16);
   floor.viewPosition.z = 1.6;
   floor.rotateX = 285;
   floor.setScale(1.6);
//floor.visible = false;   
//FLOOR SHADOW
wall = scene.add.sprite(0,0,'wall').setOrigin(0,0).setScale(1.5);
wall2 = scene.add.sprite(-1000,0,'wall').setOrigin(0,0).setScale(1.5);
 var texture = scene.textures.createCanvas('gradient', game.config.width, floorTextureHeight);
   const grd = texture.context.createLinearGradient(0, 0, 0, floorTextureHeight);
   grd.addColorStop(0, "rgba(0, 0, 0, .8)");
   grd.addColorStop(1, "rgba(0, 0, 0, 0)");
 
   texture.context.fillStyle = grd;
   texture.context.fillRect(0, 0, game.config.width, floorTextureHeight);
   //  Call scene if running under WebGL, or you'll see nothing change
   texture.refresh();
   floorShadow = scene.add.image(500 , 386, 'gradient');
   backgroundImages = scene.add.sprite(0,backgroundItemsY,'background items');
   var image = backgroundImages.setFrame(2);
   backgroundItems.push(image);
   puker = scene.add.sprite(game.config.width*.8, game.config.height*.5, 'puker');
   scene.anims.create({
    key: 'pukerWalking',
    frames: scene.anims.generateFrameNumbers('puker',
      {
        start: 0,
        end: 9
      }),
    frameRate: 16,
    repeat: -1
  });
  puker.anims.play('pukerWalking');
  backgroundItemsTimerMax = Phaser.Math.Between(600, 1000);
  pukeMeter = scene.add.sprite(50,260,'pukeMeter').setScale(1.3);
  powerBar = scene.add.sprite(game.config.width/2,game.config.height-50,'power bar').setScale(1.3);
  avatar = scene.add.sprite(game.config.width-150,game.config.height-50,'avatar').setScale(-1.3,1);
 
  cursors = scene.input.keyboard.createCursorKeys();

  startGame = true;
};


function DoWallAndFloorStuff(){
  if(wall.x<1000)
    wall.x+=pukerSpeed;
  else
  wall.x=-999;
  if(wall2.x<900)
    wall2.x+=pukerSpeed;
  else
  wall2.x=-1099;

  floor.uvScroll(-0.012,0);

}

function DoBackgroundObjectsStuff(_scene)
{
  backgroundItems.forEach((element) => 
    {element.x++;
     if(element.x>game.config.width+500)
      {
        element.destroy();
      } 
    }
);
  if(++backgroundItemsTimer>backgroundItemsTimerMax)
    {
      const image = _scene.add.sprite(0 , 186, 'background items');
       image.setFrame(Phaser.Math.Between(0, 8));
      backgroundItems.push(image);
      backgroundItemsTimer = 0;
      backgroundItemsTimerMax = Phaser.Math.Between(600, 1000);
        
    }
}

function CheckPukerMove(scene)
{
  if (this.cursors.up.isDown && puker.y>205)
    {
        puker.y--;
        puker.x-=1;
        puker.setScale(pukerScale-=.005);
    }
    else if (this.cursors.down.isDown)
    {
      puker.y++;
      puker.x+=1;
      puker.setScale(pukerScale+=.005);
    }
}

function ShowWalker(scene){
 if(!walkerShowing)
{
  walkerSpeed = 1.5;
  const walkerStyle = Phaser.Math.Between(0,2);
  walker = scene.add.sprite(10,backgroundWalkersY,'girl walker'); 
  // walker.setScale(.8);
  // scene.anims.create({
  //   key: 'walking',
  //   frames: scene.anims.generateFrameNumbers(WalkerType[walkerStyle],
  //     {
  //       start: 0,
  //       end: 19
  //     }),
  //   frameRate: 16,
  //   repeat: -1
  // });
  // walker.anims.play('walking');
   walkerShowing = true;
}
else{

if(walker.x< screenWidth && walker.x>0)
  {  
      walker.x+=walkerSpeed;
  }
else
{
  walker.destroy();
  walkerShowing = false;
}
}
}

function update() {
  if (!startGame)
    return;
  puker.setDepth(1);
  DoWallAndFloorStuff();
  DoBackgroundObjectsStuff(this);
  CheckPukerMove(this);
  ShowWalker(this)
}


