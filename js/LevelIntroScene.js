
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
    }

    create() {
        this.level1Intro.setVisible(false);
        this.level2Intro.setVisible(false);
        this.level3Intro.setVisible(false);
        switch (this.level) {
            case 1:
                this.level1Intro.setVisible(true);
                break;
            case 2:
                this.level2Intro.setVisible(true);
                break;
            case 3:
                this.level2Intro.setVisible(true);
                break;
            default:
                break;
        }
        if (1 === 0) {
            this.scene.start("GameScene", {
                level: this.level,
                score: this.score,
                lives: this.lives,
                maxLevels: this.maxLevels
            });
        }
    }

}
