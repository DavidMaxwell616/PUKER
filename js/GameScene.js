import {
  PUKER_STATES, PEOPLE_SPRITES, WALKER_SPRITES, OBJECT_START_X_OFFSET,
  FLOOR_TEXTURE_HEIGHT, MIDLINE, OBSTACLE_TYPE, PUKER_STATE, PUKER_ANIM,
  BACKGROUND_WALKERS_Y, PUKER_MIN_Y, PUKER_MAX_Y
} from "./config.js";

export class GameScene extends Phaser.Scene {
  constructor() {
    super("GameScene");

    this.backgroundImages = null;
    this.backgroundItemsY = 186;

    this.timeMin = 400;
    this.timeMax = 1000;

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

    this.level = 1;
    this.score = 0;
    this.lives = 3;
    this.maxLevels = 3;

    this.levelComplete = false;
    this.levelFailed = false;
    this.levelGoalX = 900;
    this.failYThreshold = 540;

    this.laneData = [];
    this.currentLaneIndex = 0;
    this.laneCount = 5;
    this.laneSnapThreshold = 18;

    this.pukerInvincibleUntil = 0;
  }

  init(data) {
    this.level = data.level ?? 1;
    this.score = data.score ?? 0;
    this.lives = data.lives ?? 3;
    this.maxLevels = data.maxLevels ?? 3;

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
    this.load.spritesheet("puke_sign", "puke_sign.png", {
      frameWidth: 47,
      frameHeight: 20
    });

    this.load.path = "../assets/images/";
    this.load.image("wall", "brick wall.png");
    this.load.image("water", "water.png");
    this.load.image("floor 1", "floor 1.png");
    this.load.image("floor 2", "floor 2.png");
    this.load.image("floor 3", "floor 3.png");
    this.load.image("floor 4", "floor 4.jpg");
    this.load.image("pukeMeter", "pukeMeter.png");
    this.load.image("pukeLevel", "puke.png");
    this.load.image("avatar", "avatar.png");
    this.load.image("power bar", "power bar.png");
  }

  create() {
    this.backgroundItems = this.physics.add.group();
    this.obstacles = this.physics.add.group();
    this.people = this.physics.add.group();
    this.pukerStates = this.physics.add.group();
    this.walkers = this.physics.add.group();
    this.waters = this.physics.add.group();

    this.buildLaneData();

    const floorKey = `floor ${Phaser.Math.Clamp(this.level, 1, 4)}`;

    this.floor = this.add.plane(this.game.config.width / 2, 336, floorKey);
    this.floor.setGridSize(16, 16);
    this.floor.uvScale(16, 16);
    this.floor.viewPosition.z = 1.6;
    this.floor.rotateX = 285;
    this.floor.setScale(1.6);

    this.wall = this.add.sprite(0, 0, "wall").setOrigin(0, 0).setScale(1.5);
    this.wall2 = this.add.sprite(1000, 0, "wall").setOrigin(0, 0).setScale(1.5);
    this.exitwall = this.add.image(500, 0, "wall").setOrigin(0, 0).setScale(1.5);

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

    this.currentLaneIndex = this.getClosestLaneIndex(this.game.config.height * 0.7);

    PUKER_STATES.forEach((state) => {
      const newPuker = this.add.sprite(
        this.game.config.width * 0.3,
        this.getLaneY(this.currentLaneIndex),
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
      newPuker.laneIndex = this.currentLaneIndex;
      newPuker.currentLane = this.currentLaneIndex;
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

    this.physics.add.overlap(this.puker, this.people, this.pukerHitPerson, null, this);
    this.physics.add.overlap(this.puker, this.obstacles, this.pukerHitObstacle, null, this);
    this.physics.add.overlap(this.puker, this.waters, this.pukerHitWater, null, this);
  }

  buildLaneData() {
    this.laneData = [];

    const laneTop = PUKER_MIN_Y;
    const laneBottom = PUKER_MAX_Y;
    const usableHeight = laneBottom - laneTop;
    const laneSpacing = usableHeight / (this.laneCount - 1);

    for (let i = 0; i < this.laneCount; i++) {
      const y = Math.round(laneTop + i * laneSpacing);
      this.laneData.push({
        index: i,
        y,
        minY: y - this.laneSnapThreshold,
        maxY: y + this.laneSnapThreshold
      });
    }
  }

  drawExitWall() {
    const src = this.textures.get("wall").getSourceImage();
    const w = this.wallWidth;
    const h = this.wallHeight;
    const bottomInset = Phaser.Math.Clamp(this.bottomInset, 0, h * 0.45);

    const key = "wall_skewed_gradient";

    if (this.textures.exists(key)) {
      this.textures.remove(key);
    }

    const tex = this.textures.createCanvas(key, w, h);
    const ctx = tex.context;

    const srcW = src.width;
    const srcH = src.height;

    ctx.clearRect(0, 0, w, h);

    for (let x = 0; x < w; x++) {
      const t = x / (w - 1);

      // Trapezoid geometry (left narrow → right wide)
      const topY = bottomInset * (1 - t);
      const bottomY = h - bottomInset * (1 - t);
      const colHeight = bottomY - topY;

      // 🎯 Gradient shading (left darker → right lighter)
      const shade = 0.3 + 0.7 * t;

      ctx.save();

      // Draw texture slice
      ctx.drawImage(
        src,
        (x / w) * srcW, 0, Math.max(1, srcW / w), srcH,
        x, topY, 1, colHeight
      );

      // Apply shading
      ctx.globalCompositeOperation = "multiply";
      ctx.fillStyle = `rgba(0,0,0,${1 - shade})`;
      ctx.fillRect(x, topY, 1, colHeight);

      ctx.restore();
    }

    tex.refresh();

    this.exitwall.setTexture(key).setDepth(1000);


  }

  getClosestLaneIndex(y) {
    let bestIndex = 0;
    let bestDist = Number.MAX_SAFE_INTEGER;

    for (let i = 0; i < this.laneData.length; i++) {
      const dist = Math.abs(y - this.laneData[i].y);
      if (dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }

    return bestIndex;
  }

  getLaneY(index) {
    const safeIndex = Phaser.Math.Clamp(index, 0, this.laneData.length - 1);
    return this.laneData[safeIndex].y;
  }

  sameLane(a, b) {
    if (!a || !b) return false;
    return a.laneIndex === b.laneIndex;
  }

  isLaneSafe(laneIndex) {
    const dangerX = this.puker ? this.puker.x + 70 : this.game.config.width * 0.3 + 70;

    for (const obstacle of this.obstacles.getChildren()) {
      if (!obstacle.active) continue;
      if (obstacle.laneIndex !== laneIndex) continue;
      if (Math.abs(obstacle.x - dangerX) < 90) return false;
    }

    return true;
  }

  getOpenLaneAfterCollision(obstacleLaneIndex) {
    const laneCount = this.laneData.length;
    const candidates = [];

    if (this.currentLaneIndex < obstacleLaneIndex) {
      candidates.push(this.currentLaneIndex - 1, this.currentLaneIndex + 1);
    } else if (this.currentLaneIndex > obstacleLaneIndex) {
      candidates.push(this.currentLaneIndex + 1, this.currentLaneIndex - 1);
    } else {
      candidates.push(this.currentLaneIndex - 1, this.currentLaneIndex + 1);
    }

    for (let i = 0; i < laneCount; i++) {
      if (!candidates.includes(i)) candidates.push(i);
    }

    for (const laneIndex of candidates) {
      if (laneIndex < 0 || laneIndex >= laneCount) continue;
      if (this.isLaneSafe(laneIndex)) return laneIndex;
    }

    return this.currentLaneIndex;
  }

  movePukerToLaneAnimated(laneIndex, duration = 220) {
    const safeIndex = Phaser.Math.Clamp(laneIndex, 0, this.laneData.length - 1);
    const targetY = this.getLaneY(safeIndex);

    this.currentLaneIndex = safeIndex;

    const targets = this.pukerStates.getChildren();
    this.tweens.killTweensOf(targets);

    targets.forEach((child) => {
      child.laneIndex = safeIndex;
    });

    this.tweens.add({
      targets,
      y: targetY,
      duration,
      ease: "Cubic.easeInOut",
      onUpdate: () => {
        if (this.puker) {
          this.puker.laneIndex = safeIndex;
          this.setShading(this.puker);
          this.setPerspective(this.puker);
        }
      },
      onComplete: () => {
        if (this.puker) {
          this.puker.laneIndex = safeIndex;
          this.setShading(this.puker);
          this.setPerspective(this.puker);
        }
      }
    });
  }

  refreshHud() {
    if (!this.scoreText) return;
    this.scoreText.setText(`Score: ${this.score}`);
    this.levelText.setText(`Level: ${this.level}/${this.maxLevels}`);
    this.livesText.setText(`Lives: ${this.lives}`);
  }

  completeLevel() {
    if (this.levelComplete || this.levelFailed) return;

    this.levelComplete = true;
    this.startGame = false;
    this.score += 1000 * this.level;

    this.time.delayedCall(700, () => {
      this.scene.start("HubScene", {
        level: this.level + 1,
        score: this.score,
        lives: this.lives,
        result: "complete",
        maxLevels: this.maxLevels
      });
    });
  }

  failLevel() {
    if (this.levelComplete || this.levelFailed) return;

    this.levelFailed = true;
    this.startGame = false;
    this.lives -= 1;

    this.time.delayedCall(700, () => {
      this.scene.start("HubScene", {
        level: this.level,
        score: this.score,
        lives: this.lives,
        result: "failed",
        maxLevels: this.maxLevels
      });
    });
  }

  pukerHitPerson(puker, person) {
    if (!this.sameLane(puker, person)) return;
    if (person.hit) return;
    if (Math.abs((puker.x + 20) - person.x) > 24) return;

    person.hit = true;
    person.anims.play(person.name, true);

    const anims = [0, 2, 5];
    const randomIndex = Math.floor(Math.random() * anims.length);
    const stateValue = anims[randomIndex];
    const animKey = Object.keys(PUKER_STATE).find((key) => PUKER_STATE[key] === stateValue);

    this.changePukerState(stateValue, PUKER_ANIM[animKey]);
    this.pukerPause = true;
    this.pukerSpeed = 0;

    this.score += 100;
    this.refreshHud();

    person.once("animationcomplete", () => {
      person.setFrame(0);
      this.pukerPause = false;
      this.pukerSpeed = 1;
      person.x += 60;
      this.changePukerState(PUKER_STATE.WALKING, PUKER_ANIM.WALKING);
    });
  }

  pukerHitWater(puker, water) {
    if (!this.sameLane(puker, water)) return;
    if (Math.abs((puker.x + 10) - water.x) > 26) return;

    water.destroy();
    this.pukerPause = true;
    this.pukerSpeed = 0;
    this.changePukerState(PUKER_STATE.DRINKING, PUKER_ANIM.DRINKING);

    this.score += 50;
    this.refreshHud();
  }

  pukerHitObstacle(puker, obstacle) {
    if (!puker || !obstacle || this.levelFailed || this.levelComplete) return;
    if (!this.sameLane(puker, obstacle)) return;

    const now = this.time.now;
    if (obstacle.hitCooldownUntil && now < obstacle.hitCooldownUntil) return;
    if (this.pukerInvincibleUntil && now < this.pukerInvincibleUntil) return;

    const dx = Math.abs((puker.x + 10) - obstacle.x);
    if (dx > 26) return;

    obstacle.hitCooldownUntil = now + 450;
    this.pukerInvincibleUntil = now + 450;

    this.score = Math.max(0, this.score - 150);
    this.pukeLevel.y = Math.min(this.failYThreshold + 20, this.pukeLevel.y + 30);
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

    this.bumpPukerBack(obstacle);

    this.changePukerState(
      PUKER_STATE.HIT ?? PUKER_STATE.WALKING,
      PUKER_ANIM.HIT ?? PUKER_ANIM.WALKING
    );

    const nextLane = this.getOpenLaneAfterCollision(obstacle.laneIndex);
    if (nextLane !== this.currentLaneIndex) {
      this.time.delayedCall(70, () => {
        if (!this.levelFailed && !this.levelComplete) {
          this.movePukerToLaneAnimated(nextLane, 240);
        }
      });
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
    let previousY = this.getLaneY(this.currentLaneIndex);
    let previousLane = this.currentLaneIndex;
    let previousX = this.game.config.width * 0.3;

    if (this.puker) {
      previousY = this.puker.y;
      previousX = this.puker.x;
      previousLane = this.puker.currentLane ?? this.puker.laneIndex ?? this.currentLaneIndex;

      this.puker.anims.stop();
      this.puker.visible = false;
    }

    const nextPuker = this.pukerStates.getChildren()[state];
    if (!nextPuker) return;

    this.puker = nextPuker;

    this.currentLaneIndex = Phaser.Math.Clamp(previousLane, 0, this.laneData.length - 1);

    this.puker.x = previousX;
    this.puker.y = previousY;
    this.puker.laneIndex = this.currentLaneIndex;
    this.puker.currentLane = this.currentLaneIndex;

    this.puker.play(anim, true);
    this.puker.visible = true;

    this.setShading(this.puker);
    this.setPerspective(this.puker);

    if (
      this.puker.anims.currentAnim &&
      this.puker.anims.currentAnim.key === PUKER_ANIM.DRINKING
    ) {
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
    const laneIndex = Phaser.Math.Between(0, this.laneData.length - 1);
    const personY = this.getLaneY(laneIndex);
    const personName = PEOPLE_SPRITES[personIndex].name;

    const newPerson = this.add.sprite(
      this.game.config.width + OBJECT_START_X_OFFSET,
      personY,
      personName
    );

    newPerson.setOrigin(0.5, 1);
    newPerson.name = personName;
    newPerson.laneIndex = laneIndex;
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

    // if (this.exitWallMesh) {
    //   this.exitWallMesh.x -= this.pukerSpeed;

    //   if (this.exitWallMesh.x < this.scale.width * 0.7) {
    //     this.exitWallMesh.x = this.scale.width * 0.86;
    //   }
    // }

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
    const laneIndex = Phaser.Math.Between(0, this.laneData.length - 1);
    const obstacleY = this.getLaneY(laneIndex);
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
    image.hitCooldownUntil = 0;
    image.isWobbling = false;
    image.baseY = obstacleY;
    image.laneIndex = laneIndex;

    this.obstacles.add(image);

    this.obstaclesTimer = 0;
    this.obstaclesTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  createNewWater() {
    const laneIndex = Phaser.Math.Between(0, this.laneData.length - 1);
    const obstacleY = this.getLaneY(laneIndex);

    const image = this.add
      .sprite(this.game.config.width + OBJECT_START_X_OFFSET, obstacleY, "water")
      .setDepth(obstacleY);

    this.setShading(image);
    this.setPerspective(image);
    image.hit = false;
    image.laneIndex = laneIndex;

    this.waters.add(image);

    this.waterTimer = 0;
    this.waterTimerMax = Phaser.Math.Between(this.timeMin, this.timeMax);
  }

  update() {
    if (!this.startGame || !this.puker || this.levelComplete || this.levelFailed) return;
    if (this.pukeLevel.y > 40) {
      this.pukeLevel.y -= 0.1;
    }
    this.drawExitWall();

    this.pukeSign.visible = this.pukeLevel.y < 80;

    if (this.avatar.x < this.levelGoalX) {
      this.distanceCovered++;
      this.score++;
      // if (this.distanceCovered > 500) {
      //   this.exitWallMesh.x = 800;
      //   this.exitWallMesh.y = 150;
      //   this.exitWallMesh.setVisible(true).setDepth(1000);
      // }
      this.avatar.x += this.pukerSpeed / 10;
    } else {
      this.completeLevel();
      return;
    }

    this.refreshHud();

    if (this.pukeLevel.y >= this.failYThreshold) {
      this.failLevel();
      return;
    }

    this.pukeLevel.setDepth(1000);
    //    this.puker.setDepth(this.puker.y);

    this.doWallAndFloorStuff();
    this.doBackgroundObjectsStuff();
    this.checkPukerMove();
  }
}