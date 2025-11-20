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
  physics: {
    default: 'arcade',
    arcade: {
      debug: false
    }
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
  backgroundItems = scene.physics.add.group();
  obstacles = scene.physics.add.group();
  people = scene.physics.add.group();
  pukerStates = scene.physics.add.group();
  walkers = scene.physics.add.group();

  floor = scene.add.plane(game.config.width / 2, 336, 'floor 1');
  //floor.createCheckerboard();
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
  floorShadow = scene.add.image(500, MIDLINE, 'gradient');
  backgroundImages = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, backgroundItemsY, 'background items');
  var image = backgroundImages.setFrame(Phaser.Math.Between(0, backgroundImages.frames));
  backgroundItems.add(image);

  const obstacleY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
  obstacle_sprites = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, obstacleY, 'obstacle_sprites');
  const frame = Phaser.Math.Between(0, obstacle_sprites.frames);
  image = obstacle_sprites.setFrame(frame).setOrigin(.5, 1);
  image.setDepth(obstacleY);
  image.setScale(1.2);
  image.hit = false;
  obstacles.add(image);

  walker_sprites.forEach(sprite => {
    scene.anims.create({
      key: sprite.name,
      frames: scene.anims.generateFrameNumbers(sprite.name,
        {
          start: 0,
          end: sprite.frames
        }),
      frameRate: 16,
      repeat: sprite.repeat ? -1 : 0,
    });
  });
  people_sprites.forEach(person => {
    scene.anims.create({
      key: person.name,
      frames: scene.anims.generateFrameNumbers(person.name,
        {
          start: 0,
          end: person.frames
        }),
      frameRate: 16,
      repeat: person.repeat ? -1 : 0,
    });
  });

  puker_states.forEach(state => {
    var newPuker = scene.add.sprite(game.config.width * .3, game.config.height * .7, state.name);
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
    newPuker.setScale(-1 * PUKER_SIZE_FACTOR, 1 * PUKER_SIZE_FACTOR);
    newPuker.setOrigin(.5, 1);
    newPuker.id = state.id;
    newPuker.name = state.name;
    pukerStates.add(newPuker);
  });


  changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
  backgroundItemsTimerMax = Phaser.Math.Between(timeMin, timeMax);
  obstaclesTimerMax = Phaser.Math.Between(timeMin, timeMax);
  peopleTimerMax = Phaser.Math.Between(timeMin, timeMax);
  walkersTimerMax = Phaser.Math.Between(timeMin, timeMax);
  pukeMeter = scene.add.sprite(25, 260, 'pukeMeter').setScale(1.4);
  pukeLevel = scene.add.sprite(27, 500, 'pukeLevel').setScale(1.3).setOrigin(.5, 0);
  puke_sign = scene.add.sprite(25, 15, 'puke_sign');
  const anim = scene.anims.create({
    key: 'puke_sign',
    frames: scene.anims.generateFrameNumbers('puke_sign',
      {
        start: 0,
        end: 2
      }),
    frameRate: 16,
    repeat: -1,
  });
  puke_sign.anims.play(anim);
  puke_sign.visible = false;
  powerBar = scene.add.sprite(game.config.width / 2, game.config.height - 20, 'power bar').setScale(1.3);
  avatar = scene.add.sprite(150, game.config.height - 20, 'avatar');
  cursors = scene.input.keyboard.createCursorKeys();
  startGame = true;
  scene.physics.add.collider(puker, people, pukerHitPerson);
  scene.physics.add.collider(puker, obstacles, pukerHitObstacle);
};

function pukerHitPerson(puker, person) {
  if (!person.hit && Math.abs(puker.y - person.y) < 20 && Math.abs(puker.x + 20 - person.x) < 20) {
    person.hit = true;
    person.anims.play(person.name, true);
    changePukerState(PUKER_STATE.BUMPING, PUKER_ANIM.BUMPING);
    pukerPause = true;
    pukerSpeed = 0;
    person.on('animationcomplete', () => {
      person.setFrame(0);
      pukerPause = false;
      pukerSpeed = 1;
      person.x += 60;
      changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
    });
  }
}

function pukerHitObstacle(puker, obstacle) {
  if (!obstacle.hit && Math.abs(puker.y - obstacle.y) < 20 && Math.abs(puker.x + 20 - obstacle.x) < 20) {
    obstacle.hit = true;
  }
}

function changePukerState(state, anim) {
  if (puker != null) {
    puker.visible = false;
  }
  puker = pukerStates.getChildren()[state];
  puker.anims.play(puker.name, true);
  puker.visible = true;
}

function createNewPerson() {
  const person_index = Phaser.Math.Between(0, people_sprites.length - 1);
  const person_direction = Phaser.Math.Between(1, 2);
  const personY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
  const personName = people_sprites[person_index].name;
  const newPerson = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, personY, personName);
  newPerson.setOrigin(.5, 1);
  newPerson.setScale(person_direction == 1 ? 1 : -1, 1);
  newPerson.name = personName;
  setShading(newPerson);
  setPerspective(newPerson);
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
  if (!pukerPause)
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
  walkers.getChildren().forEach((walker) => {
    walker.setDepth(walker.y);
    walker.x -= walker.walkerSpeed;
    if (walker.x < 0) {
      walker.destroy();
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
    const frame = Phaser.Math.Between(0, 9);
    const image = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, obstacleY, 'obstacle_sprites')
      .setFrame(frame);
    setShading(image);
    setPerspective(image);
    obstacles.add(image);
    obstaclesTimer = 0;
    obstaclesTimerMax = Phaser.Math.Between(timeMin, timeMax);
  }
  if (++peopleTimer > peopleTimerMax) {
    createNewPerson();
    peopleTimer = 0;
    peopleTimerMax = Phaser.Math.Between(timeMin, timeMax);
  }
  if (++walkersTimer > walkersTimerMax) {
    createNewWalker();
    walkersTimer = 0;
    walkersTimerMaxMax = Phaser.Math.Between(timeMin, timeMax + 1000);
  }
}

function CheckPukerMove() {
  if (!pukerPause) {
    if (this.cursors.up.isDown && puker.y > PUKER_MIN_Y) {
      puker.y--;
      pukerStates.getChildren().forEach(element => {
        element.y = puker.y;
      });
      setShading(puker);
      setPerspective(puker);
    }
    else if (this.cursors.down.isDown && puker.y < PUKER_MAX_Y) {
      puker.y++;
      pukerStates.getChildren().forEach(element => {
        element.y = puker.y;
      });
      setShading(puker);
      setPerspective(puker);
    }
    else if (cursors.right.isDown) {
      pukerSpeed = 2;
      if (puker.id != PUKER_STATE.RUNNING && !pukerPause) {
        changePukerState(PUKER_STATE.RUNNING, PUKER_ANIM.RUNNING);
      }

    }
    else if (cursors.right.isUp) {
      pukerSpeed = 1;
      if (puker.id != PUKER_STATE.WALKING && !pukerPause) {
        changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
      }
    }
  }
}
function setShading(sprite) {
  const gameHeight = game.config.height;
  const playerY = sprite.y;
  const normalizedY = playerY / gameHeight;
  const startColor = new Phaser.Display.Color(0, 0, 0);
  const endColor = new Phaser.Display.Color(255, 255, 255);
  const interpolatedColor = Phaser.Display.Color.Interpolate.ColorWithColor(
    startColor,
    endColor,
    100, // Length
    normalizedY * 100 // Index
  );
  const tintValue = Phaser.Display.Color.GetColor(
    interpolatedColor.r,
    interpolatedColor.g,
    interpolatedColor.b
  );

  sprite.setTint(tintValue);
}

function setPerspective(sprite) {
  const minY = 100;
  const maxY = 500;
  const minScale = 0.5;
  const maxScale = 1;
  const normalizedY = Phaser.Math.Clamp((sprite.y - minY) / (maxY - minY), 0, 1);
  const newScale = minScale + (maxScale - minScale) * normalizedY;
  const xScale = sprite.scaleX < 0 ? -1 : 1;
  sprite.setScale(xScale * newScale, newScale);
}

function createNewWalker() {
  const walker_index = Phaser.Math.Between(0, 2)
  const newWalker = scene.add.sprite(game.config.width + OBJECT_START_X_OFFSET, backgroundWalkersY, walker_sprites[walker_index].name);
  const anim = game.anims.anims.entries[walker_sprites[walker_index].name];
  newWalker.walkerSpeed = Phaser.Math.FloatBetween(1, 2);;
  anim.frameRate = newWalker.walkerSpeed * 8;
  newWalker.setScale(-1, .8);
  newWalker.anims.play(anim);
  walkers.add(newWalker);
}

function update() {
  if (!startGame)
    return;
  if (pukeLevel.y > 40) {
    pukeLevel.y -= .1;
  }
  if (pukeLevel.y < 80) {
    puke_sign.visible = true;
  }
  if (avatar.x < 900) {
    avatar.x += pukerSpeed / 10;
  }
  pukeLevel.setDepth(1000);
  puker.setDepth(puker.y);
  DoWallAndFloorStuff();
  DoBackgroundObjectsStuff(this);
  CheckPukerMove();
}
