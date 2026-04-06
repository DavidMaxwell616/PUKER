import {
  PUKER_STATES, PEOPLE_SPRITES, WALKER_SPRITES, OBJECT_START_X_OFFSET,
  FLOOR_TEXTURE_HEIGHT, MIDLINE, OBSTACLE_MIN_Y, OBSTACLE_MAX_Y,
  OBSTACLE_TYPE, PUKER_STATE, PUKER_ANIM, PUKER_MAX_Y, PUKER_MIN_Y,
  BACKGROUND_WALKERS_Y
} from "./config.js";

export class GameScene extends Phaser.Scene {
  constructor() {
    super("GameScene");
    this.sceneRef = null;
    // var puker;
    // var startGame;
    // var wall;
    // var wall2;
    // var floorMesh;

    // var tileGap = 0;
    // var startDepth = 10;
    // var floorShadow;
    // var backgroundItems;
    // var backgroundItemsTimer = 0;
    // var backgroundItemsTimerMax = 0;
    this.backgroundImages;
    this.backgroundItemsY = 186;
    // var cursors;
    // var isUpDown;
    // var isDownDown;
    // var pukerScale = 1;
    // var pukerSpeed = 1;
    // var walkerShowing = false;
    // var walkerSpeed = 1;
    // var backgroundWalkers = [];
    // var backgroundWalkersTimer = 0;
    // var backgroundWalkers;
    // var people;
    // var peopleTimer = 0;
    // var peopleTimerMax = 0;
    // var pukerPause = false;
    // var pukerPauseTimer = 0;
    // var pukerPauseTimeMax = 100;
    // var puke_sign;
    // var obstacles;
    // var waters;
    // var waterTimer = 0;
    // var waterTimerMax;
    // var obstacle_sprites;
    // var obstaclesTimer = 0;
    // var obstaclesTimerMax;
    // var walkersTimer = 0;
    // var walkersTimerMax;
    // var pukerStates;
    // var puker;
    this.timeMin = 400;
    this.timeMax = 1000;
    // var cursors;
    // var isUpDown;
    // var isDownDown;
    // var pukeMeter;
    // var splash;
    // var instructions;
    // var powerBar;
    // var avatar;
    // var pukeLevel;
    // var pukeTint;
    // var currentPukerState;
    // var game_state;
    // var scoreboard;

    this.backgroundItems = null;
    this.obstacles = null;
    this.people = null;
    this.pukerStates = null;
    this.walkers = null;
    this.waters = null;

    this.floor = null;
    this.wall = null;
    this.wall2 = null;
    this.floorShadow = null;

    this.puker = null;
    this.pukeMeter = null;
    this.pukeLevel = null;
    this.pukeSign = null;
    this.powerBar = null;
    this.avatar = null;
    this.cursors = null;

    this.backgroundItemsTimer = 0;
    this.backgroundItemsTimerMax = 0;
    this.obstaclesTimer = 0;
    this.obstaclesTimerMax = 0;
    this.peopleTimer = 0;
    this.peopleTimerMax = 0;
    this.walkersTimer = 0;
    this.walkersTimerMax = 0;
    this.waterTimer = 0;
    this.waterTimerMax = 0;

    this.startGame = false;
    this.pukerPause = false;
    this.pukerSpeed = 1;
  }

  preload() {
    this.load.path = '../assets/spritesheets/';
    PUKER_STATES.forEach(state => {
      this.load.spritesheet(state.name, state.name + '.png', { frameWidth: state.width, frameHeight: state.height });
    });
    PEOPLE_SPRITES.forEach(person => {
      this.load.spritesheet(person.name, person.name + '.png', { frameWidth: person.width, frameHeight: person.height });
    });
    WALKER_SPRITES.forEach(walker => {
      this.load.spritesheet(walker.name, walker.name + '.png', { frameWidth: walker.width, frameHeight: walker.height });
    });

    this.load.spritesheet('background items', 'background items.png', { frameWidth: 381, frameHeight: 196 });
    this.load.spritesheet('obstacle_sprites', 'obstacles.png', { frameWidth: 150, frameHeight: 240 });
    this.load.spritesheet('puke_sign', 'puke_sign.png', { frameWidth: 47, frameHeight: 20 });
    this.load.path = '../assets/images/';
    this.load.image('wall', 'brick wall.png');
    this.load.image('instructions', 'instructions.png');
    this.load.image('scoreboard', 'scoreboard.png');
    this.load.image('water', 'water.png');
    this.load.image('floor 1', 'floor 1.png');
    this.load.image('floor 2', 'floor 2.png');
    this.load.image('floor 3', 'floor 3.png');
    this.load.image('floor 4', 'floor 4.jpg');
    this.load.image('maxxdaddy', 'maxxdaddy.gif');
    this.load.image('pukeMeter', 'pukeMeter.png');
    this.load.image('pukeLevel', 'puke.png');
    this.load.image('splash1', 'splash_1.png');
    this.load.image('splash2', 'splash_2.jpg');
    this.load.image('splash3', 'splash_3.jpg');
    this.load.image('splash4', 'splash_4.jpg');
    this.load.image('avatar', 'avatar.png')
    this.load.image('power bar', 'power bar.png')
    //this.load.image('floor', 'images/p2.jpg');
    //this.load.image('floor 2', 'images/floor 2.png');
  }
  create() {
    this.backgroundItems = this.physics.add.group();
    this.obstacles = this.physics.add.group();
    this.people = this.physics.add.group();
    this.pukerStates = this.physics.add.group();
    this.walkers = this.physics.add.group();
    this.waters = this.physics.add.group();

    this.floor = this.add.plane(this.game.config.width / 2, 336, "floor 1");
    this.floor.setGridSize(16, 16);
    this.floor.uvScale(16, 16);
    this.floor.viewPosition.z = 1.6;
    this.floor.rotateX = 285;
    this.floor.setScale(1.6);

    this.wall = this.add.sprite(0, 0, "wall").setOrigin(0, 0).setScale(1.5);
    this.wall2 = this.add.sprite(1000, 0, "wall").setOrigin(0, 0).setScale(1.5);

    const texture = this.textures.createCanvas(
      "gradient",
      this.game.config.width + OBJECT_START_X_OFFSET,
      FLOOR_TEXTURE_HEIGHT
    );

    const grd = texture.context.createLinearGradient(0, 0, 0, FLOOR_TEXTURE_HEIGHT);
    grd.addColorStop(0, "rgba(0, 0, 0, .7)");
    grd.addColorStop(1, "rgba(0, 0, 0, .01)");

    texture.context.fillStyle = grd;
    texture.context.fillRect(0, 0, this.game.config.width + 20, FLOOR_TEXTURE_HEIGHT);
    texture.refresh();

    this.floorShadow = this.add.image(500, MIDLINE, "gradient");

    this.backgroundImage = this.add
      .sprite(this.game.config.width + OBJECT_START_X_OFFSET, this.backgroundItemsY, "background items")
      .setFrame(Phaser.Math.Between(0, this.backgroundImages?.frames ?? 9));

    this.backgroundItems.add(this.backgroundImage);

    this.createNewObstacle();

    WALKER_SPRITES.forEach((sprite) => {
      if (!this.anims.exists(sprite.name)) {
        this.anims.create({
          key: sprite.name,
          frames: this.anims.generateFrameNumbers(sprite.name, {
            start: 0,
            end: sprite.frames
          }),
          frameRate: 16,
          repeat: sprite.repeat ? -1 : 0
        });
      }
    });

    PEOPLE_SPRITES.forEach((person) => {
      if (!this.anims.exists(person.name)) {
        this.anims.create({
          key: person.name,
          frames: this.anims.generateFrameNumbers(person.name, {
            start: 0,
            end: person.frames
          }),
          frameRate: 16,
          repeat: person.repeat ? -1 : 0
        });
      }
    });

    PUKER_STATES.forEach((state) => {
      const newPuker = this.add.sprite(
        this.game.config.width * 0.3,
        this.game.config.height * 0.7,
        state.name
      );

      if (!this.anims.exists(state.name)) {
        this.anims.create({
          key: state.name,
          frames: this.anims.generateFrameNumbers(state.name, {
            start: 0,
            end: state.frames
          }),
          frameRate: 16,
          repeat: state.repeat ? -1 : 0
        });
      }

      newPuker.visible = false;
      newPuker.flipX = true;
      newPuker.setOrigin(0.5, 1);
      newPuker.id = state.id;
      newPuker.name = state.name;

      this.pukerStates.add(newPuker);
    });

    this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);

    this.backgroundItemsTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax / 2);
    this.obstaclesTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
    this.peopleTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
    this.walkersTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
    this.waterTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);

    this.pukeMeter = this.add.sprite(25, 260, "pukeMeter").setScale(1.4);
    this.pukeLevel = this.add.sprite(27, 500, "pukeLevel").setScale(1.3).setOrigin(0.5, 0);
    this.pukeSign = this.add.sprite(25, 15, "puke_sign");

    if (!this.anims.exists("puke_sign")) {
      this.anims.create({
        key: "puke_sign",
        frames: this.anims.generateFrameNumbers("puke_sign", {
          start: 0,
          end: 2
        }),
        frameRate: 16,
        repeat: -1
      });
    }

    this.pukeSign.play("puke_sign");
    this.pukeSign.visible = false;

    this.powerBar = this.add
      .sprite(this.game.config.width / 2, this.game.config.height - 20, "power bar")
      .setScale(1.3);

    this.avatar = this.add.sprite(150, this.game.config.height - 20, "avatar");

    this.cursors = this.input.keyboard.createCursorKeys();

    this.startGame = true;

    this.physics.add.collider(this.puker, this.people, this.pukerHitPerson, null, this);
    this.physics.add.collider(this.puker, this.obstacles, this.pukerHitObstacle, null, this);
    this.physics.add.collider(this.puker, this.waters, this.pukerHitWater, null, this);
  }

  pukerHitPerson(puker, person) {
    if (!person.hit && Math.abs(puker.y - person.y) < 20 && Math.abs(puker.x + 20 - person.x) < 20) {
      person.hit = true;
      person.anims.play(person.name, true);

      const anims = [0, 2, 5];
      const randomIndex = Math.floor(Math.random() * anims.length);
      const stateValue = anims[randomIndex];

      const animKey = Object.keys(PUKER_STATE).find((key) => PUKER_STATE[key] === stateValue);

      this.changePukerState(stateValue, PUKER_ANIM[animKey]);
      this.pukerPause = true;
      this.pukerSpeed = 0;

      person.once("animationcomplete", () => {
        person.setFrame(0);
        this.pukerPause = false;
        this.pukerSpeed = 1;
        person.x += 60;
        this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
      });
    }
  }

  pukerHitWater(puker, water) {
    if (Math.abs(puker.depth - water.depth) < 50) {
      water.destroy();
      this.pukerPause = true;
      this.pukerSpeed = 0;
      this.changePukerState(PUKER_STATE.DRINKING, PUKER_ANIM.DRINKING);
    }
  }

  pukerHitObstacle(puker, obstacle) {
    // Keep your obstacle logic here if you want to restore it later.
  }

  changePukerState(state, anim) {
    if (this.puker) {
      this.puker.anims.stop();
      this.puker.visible = false;
    }

    this.puker = this.pukerStates.getChildren()[state];

    if (!this.puker) return;

    this.puker.play(anim, true);
    this.puker.visible = true;

    this.setShading(this.puker);
    this.setPerspective(this.puker);

    if (this.puker.anims.currentAnim && this.puker.anims.currentAnim.key === PUKER_ANIM.DRINKING) {
      this.puker.once("animationcomplete", () => {
        this.pukerPause = false;
        this.pukerSpeed = 1;
        this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
        this.pukeLevel.y += 10;
      });
    }
  }

  createNewPerson() {
    const personIndex = Phaser.Math.Between(0, PEOPLE_SPRITES.length - 1);
    const personY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
    const personName = PEOPLE_SPRITES[personIndex].name;

    const newPerson = this.add.sprite(
      this.game.config.width + OBJECT_START_X_OFFSET,
      personY,
      personName
    );

    newPerson.setOrigin(0.5, 1);
    newPerson.name = personName;

    this.setShading(newPerson);
    this.setPerspective(newPerson);

    this.people.add(newPerson);

    this.peopleTimer = 0;
    this.peopleTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  doWallAndFloorStuff() {
    if (this.wall.x > -1000) this.wall.x -= this.pukerSpeed;
    else this.wall.x = 0;

    if (this.wall2.x > 0) this.wall2.x -= this.pukerSpeed;
    else this.wall2.x = 1000;

    if (!this.pukerPause) {
      this.floor.uvScroll(0.012, 0);
    }
  }

  doBackgroundObjectsStuff() {
    this.backgroundItems.getChildren().forEach((element) => {
      element.x -= this.pukerSpeed;
      if (element.x < 0) element.destroy();
    });

    this.obstacles.getChildren().forEach((element) => {
      element.setDepth(element.y);
      element.x -= this.pukerSpeed;
      if (element.x < 0) element.destroy();
    });

    this.waters.getChildren().forEach((element) => {
      element.setDepth(element.y);
      element.x -= this.pukerSpeed;
      if (element.x < 0) element.destroy();
    });

    this.people.getChildren().forEach((element) => {
      element.setDepth(element.y);
      element.x -= this.pukerSpeed;
      if (element.x < 0) element.destroy();
    });

    this.walkers.getChildren().forEach((walker) => {
      walker.setDepth(walker.y);
      walker.x -= walker.walkerSpeed;
      if (walker.x < 0) walker.destroy();
    });

    if (++this.backgroundItemsTimer > this.backgroundItemsTimerMax) {
      const image = this.add
        .sprite(this.game.config.width + OBJECT_START_X_OFFSET, this.backgroundItemsY, "background items")
        .setFrame(Phaser.Math.Between(0, 9));

      this.backgroundItems.add(image);
      this.backgroundItemsTimer = 0;
      this.backgroundItemsTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax / 2);
    }

    if (++this.obstaclesTimer > this.obstaclesTimerMax) {
      this.createNewObstacle();
    }

    if (++this.waterTimer > this.waterTimerMax) {
      this.createNewWater();
    }

    if (++this.peopleTimer > this.peopleTimerMax) {
      this.createNewPerson();
    }

    if (++this.walkersTimer > this.walkersTimerMax) {
      this.createNewWalker();
    }
  }

  checkPukerMove() {
    if (this.pukerPause || !this.puker) return;

    if (this.cursors.up.isDown && this.puker.y > PUKER_MIN_Y) {
      this.puker.y--;
      this.pukerStates.getChildren().forEach((element) => {
        element.y = this.puker.y;
      });
      this.setShading(this.puker);
      this.setPerspective(this.puker);
    } else if (this.cursors.down.isDown && this.puker.y < PUKER_MAX_Y) {
      this.puker.y++;
      this.pukerStates.getChildren().forEach((element) => {
        element.y = this.puker.y;
      });
      this.setShading(this.puker);
      this.setPerspective(this.puker);
    } else if (this.cursors.right.isDown) {
      this.pukerSpeed = 2;
      if (this.puker.id !== PUKER_STATE.RUNNING && !this.pukerPause) {
        this.changePukerState(PUKER_STATE.RUNNING, PUKER_ANIM.RUNNING);
      }
    } else if (this.cursors.right.isUp) {
      this.pukerSpeed = 1;
      if (this.puker.id !== PUKER_STATE.WALKING && !this.pukerPause) {
        this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
      }
    }
  }

  setShading(sprite) {
    const gameHeight = this.game.config.height;
    const normalizedY = sprite.y / gameHeight;

    const startColor = new Phaser.Display.Color(0, 0, 0);
    const endColor = new Phaser.Display.Color(255, 255, 255);

    const interpolatedColor = Phaser.Display.Color.Interpolate.ColorWithColor(
      startColor,
      endColor,
      100,
      normalizedY * 100
    );

    const tintValue = Phaser.Display.Color.GetColor(
      interpolatedColor.r,
      interpolatedColor.g,
      interpolatedColor.b
    );

    sprite.setTint(tintValue);
  }

  setPerspective(sprite) {
    const minY = 100;
    const maxY = 500;
    const minScale = 0.5;
    const maxScale = 1;

    const normalizedY = Phaser.Math.Clamp((sprite.y - minY) / (maxY - minY), 0, 1);
    const newScale = minScale + (maxScale - minScale) * normalizedY;
    const xScaleSign = sprite.scaleX < 0 ? -1 : 1;

    sprite.setScale(xScaleSign * newScale, newScale);
  }

  createNewWalker() {
    const walkerIndex = Phaser.Math.Between(0, 2);

    const newWalker = this.add.sprite(
      this.game.config.width + OBJECT_START_X_OFFSET,
      BACKGROUND_WALKERS_Y,
      WALKER_SPRITES[walkerIndex].name
    );

    newWalker.walkerSpeed = 1;
    newWalker.setScale(-1, 0.8);
    newWalker.anims.play(WALKER_SPRITES[walkerIndex].name);

    this.walkers.add(newWalker);

    this.walkersTimer = 0;
    this.walkersTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax + 500);
  }

  createNewObstacle() {
    const obstacleY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);
    const frame = Phaser.Math.Between(0, 8);

    const image = this.add
      .sprite(this.game.config.width + OBJECT_START_X_OFFSET, obstacleY, "obstacle_sprites")
      .setFrame(frame)
      .setDepth(obstacleY);

    this.setShading(image);
    this.setPerspective(image);

    const keysArray = Object.keys(OBSTACLE_TYPE);
    image.id = frame;
    image.name = keysArray[frame];
    image.hit = false;

    this.obstacles.add(image);

    this.obstaclesTimer = 0;
    this.obstaclesTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  createNewWater() {
    const obstacleY = Phaser.Math.Between(OBSTACLE_MIN_Y, OBSTACLE_MAX_Y);

    const image = this.add
      .sprite(this.game.config.width + OBJECT_START_X_OFFSET, obstacleY, "water")
      .setDepth(obstacleY);

    this.setShading(image);
    this.setPerspective(image);
    image.hit = false;

    this.waters.add(image);

    this.waterTimer = 0;
    this.waterTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  update() {
    if (!this.startGame || !this.puker) return;

    if (this.pukeLevel.y > 40) {
      this.pukeLevel.y -= 0.1;
    }

    this.pukeSign.visible = this.pukeLevel.y < 80;

    if (this.avatar.x < 900) {
      this.avatar.x += this.pukerSpeed / 10;
    }

    this.pukeLevel.setDepth(1000);
    this.puker.setDepth(this.puker.y);

    this.doWallAndFloorStuff();
    this.doBackgroundObjectsStuff();
    this.checkPukerMove();
  }
}