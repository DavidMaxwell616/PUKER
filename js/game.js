const config = {
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
const game = new Phaser.Game(config);
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
  pukerStates = scene.add.group();

  floor = scene.add.plane(game.config.width / 2, 336, 'floor');
  floor.createCheckerboard();
  floor.setGridSize(16, 16);
  floor.uvScale(16, 16);
  floor.viewPosition.z = 1.6;
  floor.rotateX = 285;
  floor.setScale(1.6);
  //floor.visible = false;   
  //FLOOR SHADOW
  wall = scene.add.sprite(0, 0, 'wall').setOrigin(0, 0).setScale(1.5);
  wall2 = scene.add.sprite(1000, 0, 'wall').setOrigin(0, 0).setScale(1.5);
  var texture = scene.textures.createCanvas('gradient', game.config.width + OBJECT_START_X_OFFSET, FLOOR_TEXTURE_HEIGHT);
  const grd = texture.context.createLinearGradient(0, 0, 0, FLOOR_TEXTURE_HEIGHT);
  grd.addColorStop(0, "rgba(0, 0, 0, .7)");
  grd.addColorStop(1, "rgba(0, 0, 0, .01)");

  texture.context.fillStyle = grd;
  texture.context.fillRect(0, 0, game.config.width + 20, FLOOR_TEXTURE_HEIGHT);
  //  Call scene if running under WebGL, or you'll see nothing change
  texture.refresh();
  floorShadow = scene.add.image(500, 386, 'gradient');
  backgroundImages = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, backgroundItemsY, 'background items');
  var image = backgroundImages.setFrame(Phaser.Math.Between(0, backgroundImages.frames));
  backgroundItems.add(image);

  const obstacleY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
  game_consoles = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, obstacleY, 'game consoles');
  image = game_consoles.setFrame(Phaser.Math.Between(0, 5));
  image.setDepth(obstacleY);
  obstacles.add(image);

  puker_states.forEach(state => {
    var newPuker = scene.add.sprite(game.config.width * .3, game.config.height / 2, state.name);
    scene.anims.create({
      key: state.name,
      frames: scene.anims.generateFrameNumbers(state.name,
        {
          start: 0,
          end: state.frames
        }),
      frameRate: 16,
      repeat: state.repeat ? -1 : 0,
    });
    newPuker.visible = false;
    newPuker.setScale(-1, 1);
    newPuker.id = state.id;
    newPuker.name = state.name;
    pukerStates.add(newPuker);
  });

  puker = pukerStates.getChildren()[PUKER_STATE.WALKING];
  const anim = game.anims.anims.entries[PUKER_ANIM.WALKING];
  puker.anims.play(anim);
  puker.visible = true;
  backgroundItemsTimerMax = Phaser.Math.Between(timeMin, timeMax);
  obstaclesTimerMax = Phaser.Math.Between(timeMin, timeMax);
  peopleTimerMax = Phaser.Math.Between(timeMin, timeMax);
  pukeMeter = scene.add.sprite(25, 260, 'pukeMeter').setScale(1.4);
  pukeLevel = scene.add.sprite(27, 500, 'pukeLevel').setScale(1.3).setOrigin(.5, 0);
  powerBar = scene.add.sprite(game.config.width / 2, game.config.height - 20, 'power bar').setScale(1.3);
  avatar = scene.add.sprite(150, game.config.height - 20, 'avatar');
  cursors = scene.input.keyboard.createCursorKeys();
  startGame = true;
};

function createNewPerson() {
  const person_index = Phaser.Math.Between(0, people_sprites.length - 1)
  const personY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
  const newPerson = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, personY, people_sprites[person_index].name);
  people.add(newPerson);
}

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
    element.x -= pukerSpeed;
    if (element.x < 0) {
      element.destroy();
    }
  }
  );
  obstacles.getChildren().forEach((element) => {
    element.setDepth(element.y);
    element.x -= pukerSpeed;
    if (element.x < 0) {
      element.destroy();
    }
  }
  );
  people.getChildren().forEach((element) => {
    element.setDepth(element.y);
    element.x -= pukerSpeed;
    if (element.x < 0) {
      element.destroy();
    }
  }
  );

  if (++backgroundItemsTimer > backgroundItemsTimerMax) {
    const image = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, backgroundItemsY, 'background items')
      .setFrame(Phaser.Math.Between(0, 9));
    backgroundItems.add(image);
    backgroundItemsTimer = 0;
    backgroundItemsTimerMax = Phaser.Math.Between(timeMin, timeMax);

  }
  if (++obstaclesTimer > obstaclesTimerMax) {
    const obstacleY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
    const image = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, obstacleY, 'game consoles')
      .setFrame(Phaser.Math.Between(0, 5));
    obstacles.add(image);
    obstaclesTimer = 0;
    obstaclesTimerMax = Phaser.Math.Between(timeMin, timeMax);
  }
  if (++peopleTimer > peopleTimerMax) {
    createNewPerson();
    peopleTimer = 0;
    peopleTimerMax = Phaser.Math.Between(timeMin, timeMax);
  }
}

function CheckPukerMove() {
  if (this.cursors.up.isDown && puker.y > PUKER_MIN_Y) {
    puker.y--;
  }
  else if (this.cursors.down.isDown && puker.y < PUKER_MAX_Y) {
    puker.y++;
  }
  else if (cursors.right.isDown) {
    pukerSpeed = 2;
    if (puker.id != PUKER_STATE.RUNNING) {
      puker.visible = false;
      puker = pukerStates.getChildren()[PUKER_STATE.RUNNING];
      const anim = game.anims.anims.entries[PUKER_ANIM.RUNNING];
      puker.anims.play(anim);
      puker.visible = true;
    }

  }
  else if (cursors.right.isUp) {
    pukerSpeed = 1;
    if (puker.id != PUKER_STATE.WALKING) {
      puker.visible = false;
      puker = pukerStates.getChildren()[PUKER_STATE.WALKING];
      const anim = game.anims.anims.entries[PUKER_ANIM.WALKING];
      puker.anims.play(anim);
      puker.visible = true;
    }
  }
  // SetShading(puker);
  // SetPerspective(puker);
}
function SetShading(sprite) {
  const originalColor = sprite.tintTopLeft;
  let color = Phaser.Display.Color.IntegerToColor(originalColor);
  const yPosition = sprite.y - MIDLINE;
  color.brighten(yPosition / 50);
  sprite.setTint(color.color);
}

function SetPerspective(sprite) {
  const yPosition = sprite.y - MIDLINE;
  sprite.setScale(-1, 1);
}

function ShowWalker(scene) {
  //   walkerSpeed = Phaser.Math.FloatBetween(0.5, 2);;
  //   const walkerStyle = Phaser.Math.Between(0, 0.5);
  //   walker = scene.add.sprite(10, backgroundWalkersY, WalkerType[walkerStyle]);
  //   const frames = WalkerType[walkerStyle].startsWith('girl') ? 19 : 15;
  //   walker.setScale(.8);
  //   scene.anims.create({
  //     key: 'walking',
  //     frames: scene.anims.generateFrameNumbers(WalkerType[walkerStyle],
  //       {
  //         start: 0,
  //         end: frames
  //       }),
  //     frameRate: 16,
  //     repeat: -1
  //   });
  //   walkerShowing = true;
  //   walker.anims.play('walking');
  // }
  // else
  //   if (walker.x < screenWidth) {
  //     walker.x += walkerSpeed;
  //   }
  //   else {
  //     walker.destroy();
  //     scene.anims.destroy('walking');
  //     walkerShowing = false;
  //   }
}


function update() {
  if (!startGame)
    return;
  if (pukeLevel.y > 40) {
    pukeLevel.y -= .1;
  }
  if (avatar.x < 900) {
    avatar.x += pukerSpeed / 10;
  }
  pukeLevel.setDepth(1000);
  puker.setDepth(puker.y);
  DoWallAndFloorStuff();
  DoBackgroundObjectsStuff(this);
  CheckPukerMove();
  // ShowWalkers(this)
}


