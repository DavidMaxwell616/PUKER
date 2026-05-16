
export class LevelIntroScene extends Phaser.Scene {
    constructor() {
        super("LevelIntroScene");
    }
    init(data) {
        this.level = data.level ?? 1;
        this.score = data.score ?? 0;
        this.lives = data.lives ?? 3;
    }

    preload() {
        this.load.image("splash2", "./assets/images/splash_2.jpg");
        this.load.image("splash3", "./assets/images/splash_3.jpg");
        this.load.image("splash4", "./assets/images/splash_4.jpg");
        this.load.image("gameOver", "./assets/images/game_over.png");
        this.load.image("gameOverTitle", "./assets/images/Game_Over_Title.png");
    }

    create() {
        this.levelIntros = [];
        const w = this.game.config.width;
        const h = this.game.config.height;
        const level1Intro = this.add.sprite(0, 0, "splash2")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(w, h);
        this.levelIntros.push(level1Intro);
        const level2Intro = this.add.sprite(0, 0, "splash3")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(w, h);
        this.levelIntros.push(level2Intro);
        const level3Intro = this.add.sprite(0, 0, "splash4")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(w, h);
        this.levelIntros.push(level3Intro);

        this.gameOver = this.add.sprite(0, 0, "gameOver")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(w, h);

        this.gameOverTitle = this.add.sprite(w / 2, h / 2, "gameOverTitle")
            .setOrigin(0.5)
            .setVisible(false)
            .setScale(.3)
            .setInteractive();

        console.log(this.level);

        if (this.level > this.maxLevels) {
            this.gameOver.setVisible(true);
            this.gameOverTitle.setVisible(true);
            this.time.delayedCall(5000, () => {
                this.gameOverTitle.destroy();
                this.finalScoreText = this.add.text(200, 130, this.score, {
                    fontFamily: "Arial",
                    fontSize: "40px",
                    fontWeight: "bold",
                    color: '#723E41'
                });
            });
        }
        else {
            this.levelIntros[this.level - 1].setVisible(true);
            this.spaceKey = this.input.keyboard.addKey(
                Phaser.Input.Keyboard.KeyCodes.SPACE
            );
            this.input.on('pointerdown', (pointer) => {
                this.scene.start("GameScene", {
                    level: this.level,
                    score: this.score,
                    lives: this.lives,
                    maxLevels: this.maxLevels
                });
            })
        }
    }
    update() {
        if (this.spaceKey.isDown) {
            this.scene.start("GameScene", {
                level: this.level,
                score: this.score,
                lives: this.lives,
                maxLevels: this.maxLevels
            });
        }
    }
}
