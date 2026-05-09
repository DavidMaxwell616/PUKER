import {
  PUKER_STATES, PEOPLE_SPRITES, WALKER_SPRITES, OBJECT_START_X_OFFSET,
  FLOOR_TEXTURE_HEIGHT, MIDLINE, OBSTACLE_TYPE, PUKER_STATE, PUKER_ANIM,
  BACKGROUND_WALKERS_Y, PUKER_MIN_Y, PUKER_MAX_Y, MAX_PUKE_LIMIT, FLOOR_TEXTURES,
  GAME_STATE
} from "./config.js";

export class GameScene extends Phaser.Scene {
  constructor() {
    super("GameScene");

    this.backgroundImages = null;
    this.backgroundItemsY = 186;

    this.timeMin = 400;
    this.timeMax = 1000;
    this.skipIntro = false;
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
    this.distanceCovered = 0;
    this.startGame = false;
    this.pukerPause = false;
    this.pukerSpeed = 1;
    this.failYThreshold = 540;
    this.level = 1;
    this.score = 0;
    this.lives = 3;
    this.maxLevels = 3;

    this.levelComplete = false;
    this.levelFailed = false;
    this.levelGoalX = 875;
    this.failPukeLevelThreshold = 540;
    this.noMoreStuffLine = 800;

    this.pukerInvincibleUntil = 0;
  }

  init(data) {
    this.level = data.level ?? 1;
    this.score = data.score ?? 0;
    this.lives = data.lives ?? 3;
    this.maxLevels = data.maxLevels ?? 3;
    this.skipIntro = data.skipIntro;
    this.levelComplete = false;
    this.levelFailed = false;
    this.pukerInvincibleUntil = 0;

    this.timeMin = Math.max(180, 400 - (this.level - 1) * 50);
    this.timeMax = Math.max(500, 1000 - (this.level - 1) * 80);
  }

  preload() {
    this.load.path = "../assets/spritesheets/";

    PUKER_STATES.forEach((state) => {
      this.load.spritesheet(state.name, `${state.name}.png`, {
        frameWidth: state.width,
        frameHeight: state.height
      });
    });

    PEOPLE_SPRITES.forEach((person) => {
      this.load.spritesheet(person.name, `${person.name}.png`, {
        frameWidth: person.width,
        frameHeight: person.height
      });
    });


    this.load.spritesheet("puke_sign", "puke_sign.png", {
      frameWidth: 47,
      frameHeight: 20
    });

    this.load.spritesheet("puker_puking", "puker_puking.png", {
      frameWidth: 218,
      frameHeight: 280
    });

    this.load.path = "../assets/images/";
    this.load.image("water", "water.png");
    this.load.image("pukeMeter", "pukeMeter.png");
    this.load.image("pukeLevel", "puke.png");
    this.load.image("avatar", "avatar.png");
    this.load.image("progress bar", "progress bar.png");
    this.load.image("puker standing", "puker_standing.png");
    this.load.image("level_complete_title", "level_complete.png");

    this.load.path = "../assets/images/Level_1/";
    this.load.image("level_1_wall", "brick wall.png");
    this.load.image("level_1_exit_wall", "brick exit wall.png");
    this.load.image("level_1_floor_1", "floor 1.png");
    this.load.image("level_1_floor_2", "floor 2 square.png");
    this.load.image("bouncer", "bouncer&girl.png");
    WALKER_SPRITES.forEach((walker) => {
      this.load.spritesheet(walker.name, `${walker.name}.png`, {
        frameWidth: walker.width,
        frameHeight: walker.height
      });
    });

    this.load.spritesheet("background items", "background items.png", {
      frameWidth: 381,
      frameHeight: 196
    });
    this.load.spritesheet("obstacle_sprites", "obstacles.png", {
      frameWidth: 150,
      frameHeight: 240
    });
  }

  create() {
    this.backgroundItems = this.physics.add.group();
    this.obstacles = this.physics.add.group();
    this.people = this.physics.add.group();
    this.pukerStates = this.physics.add.group();
    this.walkers = this.physics.add.group();
    this.waters = this.physics.add.group();
    this.w = this.game.config.width;
    this.h = this.game.config.height;
    this.setupLevel();

    const startY = Phaser.Math.Clamp(this.h * 0.7, PUKER_MIN_Y, PUKER_MAX_Y);

    PUKER_STATES.forEach((state) => {
      const newPuker = this.add.sprite(
        this.w * 0.3,
        startY,
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

    this.pukeMeter = this.add.sprite(25, 260, "pukeMeter").setScale(1.4).setDepth(2000);
    this.pukeLevel = this.add.sprite(27, 500, "pukeLevel").setScale(1.3).setOrigin(0.5, 0).setDepth(2000);
    this.pukeSign = this.add.sprite(25, 15, "puke_sign");
    this.puker_puking = this.add.sprite(0, 0, "puker_puking").setOrigin(0.5, 1).setScale(.8).setDepth(1200);
    this.puker_puking.flipX = true;

    this.level_complete_title = this.add.sprite(this.w / 2, this.h * .25, "level_complete_title")
      .setOrigin(.5).setScale(.25).setDepth(2000).setVisible(false);

    if (!this.anims.exists("puker_puking")) {
      this.anims.create({
        key: "puker_puking",
        frames: this.anims.generateFrameNumbers("puker_puking", {
          start: 0,
          end: 20
        }),
        frameRate: 16,
        repeat: 3
      });
    }

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

    this.progressBar = this.add
      .sprite(this.w / 2, this.h - 20, "progress bar")
      .setScale(1.3)
      .setDepth(1400);

    this.avatar = this.add
      .sprite(150, this.h - 20, "avatar")
      .setDepth(1500)
      .setScale(1.2);

    this.scoreText = this.add.text(120, 18, "", {
      fontFamily: "Arial",
      fontSize: "20px",
      color: "#ffffff"
    }).setDepth(2000);

    this.levelText = this.add.text(120, 44, "", {
      fontFamily: "Arial",
      fontSize: "20px",
      color: "#ffffff"
    }).setDepth(2000);

    this.livesText = this.add.text(120, 70, "", {
      fontFamily: "Arial",
      fontSize: "20px",
      color: "#ffffff"
    }).setDepth(2000);

    this.refreshHud();

    this.cursors = this.input.keyboard.createCursorKeys();

    this.startGame = true;

    this.physics.add.overlap(this.pukerStates, this.people, this.pukerHitPerson, null, this);
    this.physics.add.overlap(this.pukerStates, this.obstacles, this.pukerHitObstacle, null, this);
    this.physics.add.overlap(this.pukerStates, this.waters, this.pukerHitWater, null, this);
  }

  setupLevel() {
    if (this.level === 1) {
      this.level1Intro.setVisible(true);
    } else if (this.level === 2) {
      this.level2Intro.setVisible(true);
    } else {
      this.level3Intro.setVisible(true);
    }


    const floorKey = FLOOR_TEXTURES['Level' + this.level];
    this.floor = this.add.plane(this.w / 2, 336, floorKey);
    this.floor.setGridSize(16, 16);
    this.floor.uvScale(16, 16);
    this.floor.viewPosition.z = 1.6;
    this.floor.rotateX = 285;
    this.floor.setScale(1.6);

    this.wall = this.add.sprite(0, 0, "level_1_wall").setOrigin(0, 0).setScale(1.5);
    this.wall2 = this.add.sprite(1000, 0, "level_1_wall").setOrigin(0, 0).setScale(1.5);
    this.resetExitWall(this.w, this.h);

    this.exitWallTex = this.textures.createCanvas("wallCanvas", this.w, this.h);
    this.exitWallImage = this.add.image(0, 0, "wallCanvas").setOrigin(0, 0).setDepth(1200);
    this.exitWallImage = this.textures.get("level_1_exit_wall").getSourceImage();
    this.drawExitWall();

    const texture = this.textures.createCanvas(
      "gradient",
      this.w + OBJECT_START_X_OFFSET,
      FLOOR_TEXTURE_HEIGHT
    );

    this.cursors = this.input.keyboard.createCursorKeys();
    this.pukerStanding = this.add.image(0, 0, "puker standing").setOrigin(0.5, 1).setScale(.9).setDepth(1200).setVisible(false);

    this.bouncer = this.add.image(0, 0, "bouncer")
      .setOrigin(0.5, 0)
      .setDepth(1250)
      .setScale(0.7)
      .setVisible(false);
    const grd = texture.context.createLinearGradient(0, 0, 0, FLOOR_TEXTURE_HEIGHT);
    grd.addColorStop(0, "rgba(0, 0, 0, .7)");
    grd.addColorStop(1, "rgba(0, 0, 0, .01)");

    texture.context.fillStyle = grd;
    texture.context.fillRect(0, 0, this.w + 20, FLOOR_TEXTURE_HEIGHT);
    texture.refresh();

    this.floorShadow = this.add.image(500, MIDLINE, "gradient");

    this.backgroundImage = this.add
      .sprite(this.w + OBJECT_START_X_OFFSET, this.backgroundItemsY, "background items")
      .setFrame(Phaser.Math.Between(0, 9));

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

  }
  setupLevel2() {

  }
  setupLevel3() {

  }
  getExitWallMidpoint() {
    const topMidX = Phaser.Math.Linear(this.exitWall.leftX, this.exitWall.rightX, 0.5);
    const topMidY = Phaser.Math.Linear(this.exitWall.topLeftY, this.exitWall.topRightY, 0.5);

    const bottomMidX = Phaser.Math.Linear(this.exitWall.leftX, this.exitWall.rightX, 0.5);
    const bottomMidY = Phaser.Math.Linear(this.exitWall.bottomLeftY, this.exitWall.bottomRightY, 0.5);

    return {
      x: (topMidX + bottomMidX) * 0.5,
      y: (topMidY + bottomMidY) * 0.5
    };
  }

  resetExitWall(w, h) {
    this.exitWall = {
      leftX: w,
      topLeftY: 0,
      bottomLeftY: 230,

      rightX: w + 750,
      topRightY: 0,
      bottomRightY: h
    };
  }

  refreshHud() {
    if (!this.scoreText) return;
    this.scoreText.setText(`Score: ${this.score}`);
    this.levelText.setText(`Level: ${this.level}`);
    this.livesText.setText(`Lives: ${this.lives}`);
  }

  completeLevel() {
    if (this.levelComplete || this.levelFailed) return;

    this.levelComplete = true;
    this.startGame = false;
    this.score += 1000 * this.level;
    this.level_complete_title.setVisible(true);
    this.time.delayedCall(5000, () => {
      this.level_complete_title.setVisible(false);
      this.scene.start("HubScene", {
        level: this.level + 1,
        score: this.score,
        lives: this.lives,
        result: "complete",
        maxLevels: this.maxLevels,
        skipIntro: true,
      });
    });
  }


  failLevel() {
    if (this.levelComplete || this.levelFailed) return;

    this.levelFailed = true;
    this.startGame = false;
    this.lives -= 1;
    this.puker.setVisible(false);
    this.puker_puking.setPosition(this.puker.x, this.puker.y);
    this.puker_puking.setVisible(true);
    this.puker_puking.anims.play('puker_puking', true);
    this.puker_puking.once("animationcomplete", () => {
      if (this.lives == 1) {

      }
      else {
        this.lives--;
        this.scene.start("HubScene", {
          level: this.level,
          score: this.score,
          lives: this.lives,
          result: "complete",
          maxLevels: this.maxLevels
        });
      }
    });
  }

  getBottomCollisionBox(sprite, height = 50, halfWidth = 20) {
    if (!sprite) return null;

    return {
      left: sprite.x - halfWidth,
      right: sprite.x + halfWidth,
      top: sprite.y - height,
      bottom: sprite.y,
      width: halfWidth * 2,
      height
    };
  }

  bottomCollisionIntersects(a, b, height = 50, halfWidthA = 20, halfWidthB = 20) {
    const boxA = this.getBottomCollisionBox(a, height, halfWidthA);
    const boxB = this.getBottomCollisionBox(b, height, halfWidthB);

    if (!boxA || !boxB) return false;

    return !(
      boxA.right < boxB.left ||
      boxA.left > boxB.right ||
      boxA.bottom < boxB.top ||
      boxA.top > boxB.bottom
    );
  }

  updatePukerDepth() {
    if (!this.puker) return;

    const depth = this.puker.y + 10;
    this.puker.setDepth(depth);

    this.pukerStates.getChildren().forEach((child) => {
      child.setDepth(depth);
    });
  }

  drawExitWall() {
    const tl = { x: this.exitWall.leftX, y: this.exitWall.topLeftY };
    const tr = { x: this.exitWall.rightX, y: this.exitWall.topRightY };
    const br = { x: this.exitWall.rightX, y: this.exitWall.bottomRightY };
    const bl = { x: this.exitWall.leftX, y: this.exitWall.bottomLeftY };

    const tex = this.exitWallTex;
    const ctx = tex.getContext();
    const img = this.exitWallImage;

    const sw = img.width;
    const sh = img.height;

    ctx.clearRect(0, 0, tex.width, tex.height);

    const wallLeft = Math.min(tl.x, bl.x);
    const wallRight = Math.max(tr.x, br.x);
    const columns = Math.max(8, Math.floor(wallRight - wallLeft));

    for (let i = 0; i < columns; i++) {
      const t0 = i / columns;
      const t1 = (i + 1) / columns;

      const x0Top = Phaser.Math.Linear(tl.x, tr.x, t0);
      const y0Top = Phaser.Math.Linear(tl.y, tr.y, t0);
      const x0Bot = Phaser.Math.Linear(bl.x, br.x, t0);
      const y0Bot = Phaser.Math.Linear(bl.y, br.y, t0);

      const x1Top = Phaser.Math.Linear(tl.x, tr.x, t1);
      const y1Top = Phaser.Math.Linear(tl.y, tr.y, t1);
      const x1Bot = Phaser.Math.Linear(bl.x, br.x, t1);
      const y1Bot = Phaser.Math.Linear(bl.y, br.y, t1);

      const sx = Math.floor(t0 * sw);
      const sWidth = Math.max(1, Math.ceil((t1 - t0) * sw));

      const dx = Math.min(x0Top, x0Bot, x1Top, x1Bot);
      const dy = Math.min(y0Top, y0Bot);
      const dHeight = Math.max(1, Math.max(y0Bot, y1Bot) - Math.min(y0Top, y1Top));

      ctx.save();
      ctx.beginPath();
      ctx.moveTo(x0Top, y0Top);
      ctx.lineTo(x1Top, y1Top);
      ctx.lineTo(x1Bot, y1Bot);
      ctx.lineTo(x0Bot, y0Bot);
      ctx.closePath();
      ctx.clip();

      ctx.drawImage(
        img,
        sx, 0, sWidth, sh,
        dx, dy, Math.max(1, Math.abs(x1Top - x0Top) + Math.abs(x1Bot - x0Bot) * 0.5 + 1), dHeight
      );

      ctx.restore();
    }

    // Clip all lighting to the wall shape
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(tl.x, tl.y);
    ctx.lineTo(tr.x, tr.y);
    ctx.lineTo(br.x, br.y);
    ctx.lineTo(bl.x, bl.y);
    ctx.closePath();
    ctx.clip();

    // 1) Stronger left-side shadow
    const leftShade = ctx.createLinearGradient(tl.x, 0, tr.x, 0);
    leftShade.addColorStop(0.00, "rgba(0,0,0,0.72)");
    leftShade.addColorStop(0.18, "rgba(0,0,0,0.48)");
    leftShade.addColorStop(0.42, "rgba(0,0,0,0.20)");
    leftShade.addColorStop(1.00, "rgba(0,0,0,0.00)");
    ctx.fillStyle = leftShade;
    ctx.fillRect(0, 0, tex.width, tex.height);

    // 2) Soft top highlight
    const topHighlight = ctx.createLinearGradient(0, tl.y, 0, Math.max(tr.y, tl.y) + 140);
    topHighlight.addColorStop(0.00, "rgba(255,255,255,0.22)");
    topHighlight.addColorStop(0.18, "rgba(255,255,255,0.10)");
    topHighlight.addColorStop(1.00, "rgba(255,255,255,0.00)");
    ctx.fillStyle = topHighlight;
    ctx.fillRect(0, 0, tex.width, tex.height);

    // 3) Right-side rim light
    const rimStartX = tr.x - Math.max(30, (tr.x - tl.x) * 0.18);
    const rightRim = ctx.createLinearGradient(rimStartX, 0, tr.x, 0);
    rightRim.addColorStop(0.00, "rgba(255,220,160,0.00)");
    rightRim.addColorStop(0.55, "rgba(255,220,160,0.08)");
    rightRim.addColorStop(1.00, "rgba(255,220,160,0.24)");
    ctx.fillStyle = rightRim;
    ctx.fillRect(0, 0, tex.width, tex.height);

    // 4) Subtle bottom vignette / grime
    const bottomShade = ctx.createLinearGradient(0, Math.min(bl.y, br.y) - 140, 0, Math.max(bl.y, br.y));
    bottomShade.addColorStop(0.00, "rgba(0,0,0,0.00)");
    bottomShade.addColorStop(0.65, "rgba(0,0,0,0.10)");
    bottomShade.addColorStop(1.00, "rgba(0,0,0,0.28)");
    ctx.fillStyle = bottomShade;
    ctx.fillRect(0, 0, tex.width, tex.height);

    // 5) Extra darkening in the far-left corner for more depth
    const cornerShade = ctx.createRadialGradient(
      tl.x - 10, tl.y + 40, 10,
      tl.x + 40, tl.y + 80, 240
    );
    cornerShade.addColorStop(0.00, "rgba(0,0,0,0.30)");
    cornerShade.addColorStop(0.50, "rgba(0,0,0,0.14)");
    cornerShade.addColorStop(1.00, "rgba(0,0,0,0.00)");
    ctx.fillStyle = cornerShade;
    ctx.fillRect(0, 0, tex.width, tex.height);

    ctx.restore();
    tex.refresh();

  }
  pukerHitPerson(puker, person) {
    if (puker !== this.puker || !puker.visible) return;
    if (person.hit) return;
    if (!this.bottomCollisionIntersects(puker, person, 50, 20, 20)) return;

    person.hit = true;
    person.anims.play(person.name, true);

    const anims = [0, 2, 5];
    const stateValue = anims[Math.floor(Math.random() * anims.length)];
    const animKey = Object.keys(PUKER_STATE).find((key) => PUKER_STATE[key] === stateValue);

    this.changePukerState(stateValue, PUKER_ANIM[animKey]);
    this.pukerPause = true;
    this.pukerSpeed = 0;

    this.refreshHud();
    this.score = Math.max(0, this.score - 150);

    person.once("animationcomplete", () => {
      person.setFrame(0);
      this.pukerPause = false;
      this.pukerSpeed = 1;
      person.x += 60;
      this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
    });
  }

  pukerHitWater(puker, water) {
    if (puker !== this.puker || !puker.visible) return;
    if (!this.bottomCollisionIntersects(puker, water, 50, 20, 20)) return;

    water.destroy();
    this.pukerPause = true;
    this.pukerSpeed = 0;
    this.changePukerState(PUKER_STATE.DRINKING, PUKER_ANIM.DRINKING);

    this.score += 150;
    this.refreshHud();
  }

  pukerHitObstacle(puker, obstacle) {
    if (puker !== this.puker || !puker.visible) return;
    if (!puker || !obstacle || this.levelFailed || this.levelComplete) return;
    if (obstacle.hit) return;

    const now = this.time.now;
    if (obstacle.hitCooldownUntil && now < obstacle.hitCooldownUntil) return;
    if (this.pukerInvincibleUntil && now < this.pukerInvincibleUntil) return;

    if (!this.bottomCollisionIntersects(puker, obstacle, 50, 10, 10)) return;

    obstacle.hitCooldownUntil = now + 450;
    this.pukerInvincibleUntil = now + 450;

    this.score = Math.max(0, this.score - 150);
    this.refreshHud();

    this.pukerPause = true;
    this.pukerSpeed = 0;

    this.wobbleObject(obstacle, {
      angle: 12,
      xKick: 12,
      squash: 0.08,
      duration: 90,
      repeats: 3
    });
    obstacle.hit = true;

    if (this.isLowObstacle(obstacle)) {
      // 🔹 LOW obstacle → side knock (trip)
      this.knockPukerSide(obstacle);

      this.changePukerState(
        PUKER_STATE.HIT ?? PUKER_STATE.WALKING,
        PUKER_ANIM.HIT ?? PUKER_ANIM.WALKING
      );

      this.score = Math.max(0, this.score - 50); // lighter penalty

    } else {

      this.changePukerState(
        PUKER_STATE.HIT ?? PUKER_STATE.WALKING,
        PUKER_ANIM.HIT ?? PUKER_ANIM.WALKING
      );

      this.score = Math.max(0, this.score - 150);
    }

    this.cameras.main.shake(120, 0.003);

    this.time.delayedCall(260, () => {
      this.pukerPause = false;
      this.pukerSpeed = 1 + (this.level - 1) * 0.05;

      if (!this.levelFailed && !this.levelComplete) {
        this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
      }
    });
  }

  wobbleObject(sprite, config = {}) {
    if (!sprite || !sprite.scene) return;
    if (sprite.isWobbling) return;

    const {
      angle = 10,
      xKick = 8,
      squash = 0.06,
      duration = 80,
      repeats = 2
    } = config;

    sprite.isWobbling = true;

    const baseAngle = sprite.angle || 0;
    const baseX = sprite.x;
    const baseScaleX = sprite.scaleX;
    const baseScaleY = sprite.scaleY;

    this.tweens.killTweensOf(sprite);

    this.tweens.add({
      targets: sprite,
      angle: baseAngle - angle,
      x: baseX - xKick,
      scaleX: baseScaleX * (1 + squash),
      scaleY: baseScaleY * (1 - squash),
      duration,
      yoyo: true,
      repeat: repeats,
      ease: "Sine.easeInOut",
      onComplete: () => {
        if (!sprite || !sprite.scene) return;
        sprite.angle = baseAngle;
        sprite.x = Math.max(sprite.x, 0);
        sprite.scaleX = baseScaleX;
        sprite.scaleY = baseScaleY;
        sprite.isWobbling = false;
      }
    });
  }

  isLowObstacle(obstacle) {
    if (!this.puker || !obstacle) return false;

    const pukerHeight = this.puker.displayHeight;
    const obstacleHeight = obstacle.displayHeight;

    return obstacleHeight < pukerHeight * 0.5;
  }

  knockPukerSide(obstacle) {
    if (!this.puker) return;

    const dir = obstacle.x >= this.puker.x ? -1 : 1;

    const knockX = this.puker.x + dir * 18;
    const knockY = this.puker.y - 10; // slight pop up

    this.tweens.killTweensOf(this.puker);

    this.tweens.add({
      targets: this.puker,
      x: knockX,
      y: knockY,
      duration: 80,
      yoyo: true,
      ease: "Quad.easeOut",
      onUpdate: () => {
        this.pukerStates.getChildren().forEach(child => {
          child.x = this.puker.x;
          child.y = this.puker.y;
        });
      }
    });
  }

  bumpPukerBack(obstacle) {
    if (!this.puker) return;

    const dir = obstacle.x >= this.puker.x ? -1 : 1;
    const startX = this.puker.x;
    const targetX = startX + dir * 12;

    this.tweens.killTweensOf(this.puker);

    this.tweens.add({
      targets: this.puker,
      x: targetX,
      duration: 70,
      yoyo: true,
      ease: "Quad.easeOut",
      onUpdate: () => {
        this.pukerStates.getChildren().forEach((child) => {
          child.x = this.puker.x;
        });
      }
    });
  }

  changePukerState(state, anim) {
    let previousY = Phaser.Math.Clamp(this.h * 0.7, PUKER_MIN_Y, PUKER_MAX_Y);
    let previousX = this.w * 0.3;

    if (this.puker) {
      previousY = this.puker.y;
      previousX = this.puker.x;

      this.puker.anims.stop();
      this.puker.visible = false;
    }

    const nextPuker = this.pukerStates.getChildren()[state];
    if (!nextPuker) return;

    this.puker = nextPuker;

    this.puker.x = previousX;
    this.puker.y = previousY;

    this.puker.play(anim, true);
    this.puker.visible = true;

    this.setShading(this.puker);
    this.setPerspective(this.puker);
    this.updatePukerDepth();

    if (
      this.puker.anims.currentAnim &&
      this.puker.anims.currentAnim.key === PUKER_ANIM.DRINKING
    ) {
      this.puker.once("animationcomplete", () => {
        this.pukerPause = false;
        this.pukerSpeed = 1;
        this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
        this.pukeLevel.y += 35;
      });
    }
  }

  createNewPerson() {
    const personIndex = Phaser.Math.Between(0, PEOPLE_SPRITES.length - 1);
    const personY = Phaser.Math.Between(PUKER_MIN_Y, PUKER_MAX_Y);
    const personName = PEOPLE_SPRITES[personIndex].name;

    const newPerson = this.add.sprite(
      this.w + OBJECT_START_X_OFFSET,
      personY,
      personName
    );

    newPerson.setOrigin(0.5, 1);
    newPerson.name = personName;
    newPerson.hit = false;

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
      this.floor.uvScroll(0.012 + this.level * 0.002, 0);
    }
  }

  doBackgroundObjectsStuff() {
    this.backgroundItems.getChildren().forEach((element) => {
      element.x -= this.pukerSpeed;
      if (element.x < 0) element.destroy();
    });

    this.obstacles.getChildren().forEach((element) => {
      element.setDepth(element.y + (element.isWobbling ? 1 : 0));
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
      walker.x -= this.pukerSpeed == 0 ? 1 : this.pukerSpeed;
      if (walker.x < 0) walker.destroy();
    });

    if (this.avatar.x > this.noMoreStuffLine) return;
    if (++this.backgroundItemsTimer > this.backgroundItemsTimerMax) {
      const image = this.add
        .sprite(this.w + OBJECT_START_X_OFFSET, this.backgroundItemsY, "background items")
        .setFrame(Phaser.Math.Between(0, 9));

      this.backgroundItems.add(image);
      this.backgroundItemsTimer = 0;
      this.backgroundItemsTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax / 2);
    }
    if (++this.obstaclesTimer > this.obstaclesTimerMax) this.createNewObstacle();
    if (++this.waterTimer > this.waterTimerMax) this.createNewWater();
    if (++this.peopleTimer > this.peopleTimerMax) this.createNewPerson();
    if (++this.walkersTimer > this.walkersTimerMax) this.createNewWalker();
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
      this.updatePukerDepth();
    } else if (this.cursors.down.isDown && this.puker.y < PUKER_MAX_Y) {
      this.puker.y++;
      this.pukerStates.getChildren().forEach((element) => {
        element.y = this.puker.y;
      });
      this.setShading(this.puker);
      this.setPerspective(this.puker);
      this.updatePukerDepth();
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

    this.puker.y = Phaser.Math.Clamp(this.puker.y, PUKER_MIN_Y, PUKER_MAX_Y);
    this.pukerStates.getChildren().forEach((element) => {
      element.y = this.puker.y;
    });
  }

  setShading(sprite) {
    const gameHeight = this.h;
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
      this.w + OBJECT_START_X_OFFSET,
      BACKGROUND_WALKERS_Y,
      WALKER_SPRITES[walkerIndex].name
    );

    newWalker.setScale(-1, 0.8);
    newWalker.anims.play(WALKER_SPRITES[walkerIndex].name);

    this.walkers.add(newWalker);

    this.walkersTimer = 0;
    this.walkersTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax + 500);
  }

  createNewObstacle() {
    const obstacleY = Phaser.Math.Between(PUKER_MIN_Y, PUKER_MAX_Y);
    const frame = Phaser.Math.Between(0, 8);

    const image = this.add
      .sprite(this.w + OBJECT_START_X_OFFSET, obstacleY, "obstacle_sprites")
      .setFrame(frame)
      .setOrigin(0.5, 1)
      .setDepth(obstacleY);

    this.setShading(image);
    this.setPerspective(image);

    const keysArray = Object.keys(OBSTACLE_TYPE);
    image.id = frame;
    image.name = keysArray[frame];
    image.hit = false;
    image.hitCooldownUntil = 0;
    image.isWobbling = false;
    image.baseY = obstacleY;

    this.obstacles.add(image);

    this.obstaclesTimer = 0;
    this.obstaclesTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  createNewWater() {
    const obstacleY = Phaser.Math.Between(PUKER_MIN_Y, PUKER_MAX_Y);

    const image = this.add
      .sprite(this.w + OBJECT_START_X_OFFSET, obstacleY, "water")
      .setOrigin(0.5, 1)
      .setDepth(obstacleY);

    this.setShading(image);
    this.setPerspective(image);
    image.hit = false;

    this.waters.add(image);

    this.waterTimer = 0;
    this.waterTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  update() {

    if (!this.startGame || !this.puker || this.levelComplete || this.levelFailed) return;

    if (this.pukeLevel.y > MAX_PUKE_LIMIT && this.gameState != GAME_STATE.LEVEL_INTRO) {
      this.pukeLevel.y -= 0.1;
    }
    else {
      this.failLevel();
    }

    if (this.avatar.x > this.levelGoalX - 50) {
      this.drawExitWall();
      this.exitWall.rightX -= this.pukerSpeed * 3;
      this.exitWall.leftX -= this.pukerSpeed;
      const wallMid = this.getExitWallMidpoint();
      this.bouncer.setPosition(wallMid.x, wallMid.y).setVisible(true);
    }

    if (this.avatar.x > this.levelGoalX - 25) {
      this.pukerPause = true;
      this.pukerSpeed = 0;
      this.puker.setVisible(false);
      this.pukerStanding.setPosition(this.puker.x, this.puker.y).setVisible(true).setDepth(this.puker.depth);
      this.gameState = GAME_STATE.LEVEL_INTRO;
      this.completeLevel();
    }

    this.pukeSign.visible = this.pukeLevel.y < 80;

    if (!this.pukerPause) {
      if (this.avatar.x < this.levelGoalX) {
        this.distanceCovered++;
        this.score++;
        this.avatar.x += this.pukerSpeed / 10;
      } else {
        this.completeLevel();
        return;
      }
    }

    this.refreshHud();
    if (this.pukeLevel.y >= this.failYThreshold) {
      this.failLevel();
      return;
    }

    this.updatePukerDepth();

    this.doWallAndFloorStuff();
    this.doBackgroundObjectsStuff();
    this.checkPukerMove();
  }
}