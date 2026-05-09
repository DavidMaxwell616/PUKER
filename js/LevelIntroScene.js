
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


    }

    create() {
        this.levelIntros = [];

        const level1Intro = this.add.sprite(0, 0, "splash2")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.levelIntros.push(level1Intro);
        const level2Intro = this.add.sprite(0, 0, "splash3")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.levelIntros.push(level2Intro);
        const level3Intro = this.add.sprite(0, 0, "splash4")
            .setOrigin(0)
            .setVisible(false)
            .setInteractive()
            .setDisplaySize(this.game.config.width, this.game.config.height);
        this.levelIntros.push(level3Intro);

        this.levelIntros[this.level - 1].setVisible(true);
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
