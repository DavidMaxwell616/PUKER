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
  if (!startGame) mainMenuCreate(scene, game);
  else gameCreate(scene);
}

function gameCreate(scene) {
  backgroundItems = scene.add.group();
  obstacles = scene.add.group();
  people = scene.add.group();
  floor = scene.add.plane(game.config.width / 2, 336, 'floor');
  // floor.createCheckerboard();
  floor.setGridSize(16, 16);
  floor.uvScale(16, 16);
  floor.viewPosition.z = 1.6;
  floor.rotateX = 285;
  floor.setScale(1.6);
  //floor.visible = false;   
  //FLOOR SHADOW
  wall = scene.add.sprite(0, 0, 'wall').setOrigin(0, 0).setScale(1.5);
  wall2 = scene.add.sprite(1000, 0, 'wall').setOrigin(0, 0).setScale(1.5);
  var texture = scene.textures.createCanvas('gradient', game.config.width, floorTextureHeight);
  const grd = texture.context.createLinearGradient(0, 0, 0, floorTextureHeight);
  grd.addColorStop(0, "rgba(0, 0, 0, .8)");
  grd.addColorStop(1, "rgba(0, 0, 0, 0)");

  texture.context.fillStyle = grd;
  texture.context.fillRect(0, 0, game.config.width, floorTextureHeight);
  //  Call scene if running under WebGL, or you'll see nothing change
  texture.refresh();
  floorShadow = scene.add.image(500, 386, 'gradient');
  backgroundImages = scene.add.sprite(game.config.width, backgroundItemsY, 'background items');
  var image = backgroundImages.setFrame(Phaser.Math.Between(2, 15));
  backgroundItems.add(image);

  var obstacleY = Phaser.Math.Between(386, 600);
  game_consoles = scene.add.sprite(game.config.width, obstacleY, 'game consoles');
  var image = game_consoles.setFrame(Phaser.Math.Between(0, 5));
  obstacles.add(image);

  puker = scene.add.sprite(game.config.width * .3, game.config.height * .5, 'puker');
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
  obstaclesTimerMax = Phaser.Math.Between(600, 1000);
  pukeMeter = scene.add.sprite(50, 260, 'pukeMeter').setScale(-1.3);
  powerBar = scene.add.sprite(game.config.width / 2, game.config.height - 20, 'power bar').setScale(1.3);
  avatar = scene.add.sprite(150, game.config.height - 20, 'avatar');

  cursors = scene.input.keyboard.createCursorKeys();

  startGame = true;
};


function DoWallAndFloorStuff() {
  if (wall.x > -1000)
    wall.x -= pukerSpeed;
  else
    wall.x = 0;
  if (wall2.x > 0)
    wall2.x -= pukerSpeed;
  else
    wall2.x = 1000;
  floor.uvScroll(0.012, 0);
}

function DoBackgroundObjectsStuff(_scene) {
  backgroundItems.getChildren().forEach((element) => {
    element.x--;
    if (element.x < 0) {
      element.destroy();
    }
  }
  );
  obstacles.getChildren().forEach((element) => {
    element.x--;
    if (element.x < 0) {
      element.destroy();
    }
  }
  );
  if (avatar.x < 800) {
    avatar.x += .1;
  }
  if (++backgroundItemsTimer > backgroundItemsTimerMax) {
    var image = scene.add.sprite(game.config.width, backgroundItemsY, backgroundImages)
      .setFrame(Phaser.Math.Between(2, 15));
    backgroundItems.add(image);
    backgroundItemsTimer = 0;
    backgroundItemsTimerMax = Phaser.Math.Between(600, 1000);

  }
  if (++obstaclesTimer > obstaclesTimerMax) {
    const obstacleY = Phaser.Math.Between(386, 600);
    var image = scene.add.sprite(game.config.width, obstacleY, game_consoles)
      .setFrame(Phaser.Math.Between(0, 5));
    obstacles.add(image);
    obstaclesTimer = 0;
    obstaclesTimerMax = Phaser.Math.Between(600, 1000);
  }
}

function CheckPukerMove(scene) {
  if (this.cursors.up.isDown && puker.y > 205) {
    puker.y--;
    puker.setScale(pukerScale -= .005);
    puker.setBlendMode(Phaser.BlendModes.DARKEN);;
  }
  else if (this.cursors.down.isDown && puker.y < 348) {
    puker.y++;
    puker.setScale(pukerScale += .005);
    puker.setBlendMode(Phaser.BlendModes.BRIGHTEN);
  }
}

function ShowWalker(scene) {
  if (!walkerShowing) {
    walkerSpeed = Phaser.Math.FloatBetween(0.5, 2);;
    const walkerStyle = Phaser.Math.Between(0, 0.5);
    walker = scene.add.sprite(10, backgroundWalkersY, WalkerType[walkerStyle]);
    console.log(WalkerType[walkerStyle]);
    const frames = WalkerType[walkerStyle].startsWith('girl') ? 19 : 15;
    walker.setScale(.8);
    scene.anims.create({
      key: 'walking',
      frames: scene.anims.generateFrameNumbers(WalkerType[walkerStyle],
        {
          start: 0,
          end: frames
        }),
      frameRate: 16,
      repeat: -1
    });
    walkerShowing = true;
    walker.anims.play('walking');
  }
  else
    if (walker.x < screenWidth) {
      walker.x += walkerSpeed;
    }
    else {
      walker.destroy();
      scene.anims.destroy('walking');
      walkerShowing = false;
    }
}


function update() {
  if (!startGame)
    return;

  puker.setDepth(1);
  DoWallAndFloorStuff();
  DoBackgroundObjectsStuff(this);
  CheckPukerMove(this);
  // ShowWalker(this)
}


