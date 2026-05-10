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
        this.load.image("splash", "./assets/images/splash_1.png");
        this.load.image("game_over", "./assets/images/game_over.png");
        this.load.image("instructions", "./assets/images/instructions.png");
        this.load.image("scoreboard", "./assets/images/scoreboard.png");
        this.load.image("maxxdaddy", "./assets/images/maxxdaddy.gif");
    }

    create() {
        this.splash = this.add.sprite(0, 0, "splash")
            .setOrigin(0)
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
        this.maxxdaddy = this.add.image(
            this.game.config.width,
            this.game.config.height,
            "game_over"
        ).setVisible(false);

        this.splash.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

        this.instructions.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

        this.scoreboard.on("pointerdown", (pointer) => {
            this.SetSplashState(pointer);
        });

    }

    SetSplashState(pointer) {
        if (
            (this.gameState === GAME_STATE.INTRO && pointer &&
                Phaser.Geom.Polygon.Contains(startButtonShape, pointer.x, pointer.y))
        ) {
            this.maxxdaddy.setVisible(false);
            this.splash.setVisible(false);

            this.gameState = GAME_STATE.LEVEL;

            this.scene.start("LevelIntroScene", {
                level: this.level,
                score: this.score,
                lives: this.lives,
                maxLevels: this.maxLevels
            });
        }
        else if (
            this.gameState === GAME_STATE.INTRO &&
            Phaser.Geom.Polygon.Contains(instructionsButtonShape, pointer.x, pointer.y)
        ) {
            this.gameState = GAME_STATE.INSTRUCTIONS;
            this.splash.setVisible(false);
            this.instructions.setVisible(true);
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
    update() {
        if (this.skipIntro) {
            this.SetSplashState(null, true);
        }
    }
}