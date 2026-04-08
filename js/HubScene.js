import {
    GAME_STATE,
    startButtonShape,
    instructionsButtonShape,
    exitInstructionsShape,
    scoreboardButtonShape,
    exitScoreboardShape,
} from "./config.js";

export class HubScene extends Phaser.Scene {
    constructor() {
        super("HubScene");
    }

    init(data) {
        this.level = data.level ?? 1;
        this.score = data.score ?? 0;
        this.lives = data.lives ?? 3;
        this.result = data.result ?? "start";
        this.maxLevels = data.maxLevels ?? 3;

        this.gameState = GAME_STATE.INTRO;
    }

    preload() {
        this.load.image("splash1", "./assets/images/splash_1.png");
        this.load.image("splash2", "./assets/images/splash_2.jpg");
        this.load.image("splash3", "./assets/images/splash_3.jpg");
        this.load.image("splash4", "./assets/images/splash_4.jpg");
        this.load.image("instructions", "./assets/images/instructions.png");
        this.load.image("scoreboard", "./assets/images/scoreboard.png");
        this.load.image("maxxdaddy", "./assets/images/maxxdaddy.gif");
    }

    create() {
        this.splash = this.add.sprite(0, 0, "splash1")
            .setOrigin(0)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.level1Intro = this.add.sprite(0, 0, "splash2")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.level2Intro = this.add.sprite(0, 0, "splash3")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.level3Intro = this.add.sprite(0, 0, "splash4")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.instructions = this.add.sprite(0, 0, "instructions")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);

        this.scoreboard = this.add.sprite(0, 0, "scoreboard")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);

        this.maxxdaddy = this.add.image(
            this.game.config.width * 0.92,
            this.game.config.height * 0.94,
            "maxxdaddy"
        );

        this.splash.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

        this.instructions.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

        this.scoreboard.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

        this.level1Intro.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

    }

    SetSplashState(pointer) {
        if (
            this.gameState === GAME_STATE.INTRO &&
            Phaser.Geom.Polygon.Contains(startButtonShape, pointer.x, pointer.y)
        ) {
            this.maxxdaddy.setVisible(false);
            this.splash.setVisible(false);

            this.level1Intro.setVisible(false);
            this.level2Intro.setVisible(false);
            this.level3Intro.setVisible(false);

            if (this.level === 1) {
                this.level1Intro.setVisible(true);
            } else if (this.level === 2) {
                this.level2Intro.setVisible(true);
            } else {
                this.level3Intro.setVisible(true);
            }

            this.gameState = GAME_STATE.LEVEL_INTRO;
        }
        else if (this.gameState === GAME_STATE.LEVEL_INTRO) {
            this.level1Intro.setVisible(false);
            this.level2Intro.setVisible(false);
            this.level3Intro.setVisible(false);

            this.gameState = GAME_STATE.LEVEL;

            this.scene.start("GameScene", {
                level: this.level,
                score: this.score,
                lives: this.lives,
                maxLevels: this.maxLevels
            });
        }
        else if (
            this.gameState === GAME_STATE.INSTRUCTIONS &&
            Phaser.Geom.Polygon.Contains(exitInstructionsShape, pointer.x, pointer.y)
        ) {
            this.gameState = GAME_STATE.INTRO;
            this.splash.setVisible(true);
            this.instructions.setVisible(false);
        }
        else if (
            this.gameState === GAME_STATE.INTRO &&
            Phaser.Geom.Polygon.Contains(scoreboardButtonShape, pointer.x, pointer.y)
        ) {
            this.maxxdaddy.setVisible(false);
            this.gameState = GAME_STATE.SCOREBOARD;
            this.splash.setVisible(false);
            this.instructions.setVisible(false);
            this.scoreboard.setVisible(true);
        }
        else if (
            this.gameState === GAME_STATE.SCOREBOARD &&
            Phaser.Geom.Polygon.Contains(exitScoreboardShape, pointer.x, pointer.y)
        ) {
            this.gameState = GAME_STATE.INTRO;
            this.splash.setVisible(true);
            this.scoreboard.setVisible(false);
        }
    }
}