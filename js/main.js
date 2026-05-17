
import { GameScene } from "./GameScene.js";
import { SplashScene } from "./SplashScene.js";
import { LevelIntroScene } from "./LevelIntroScene.js";
const W = 960, H = 540;


new Phaser.Game({
    type: Phaser.AUTO,
    width: W,
    height: H,
    pixelArt: true,
    backgroundColor: '#4488aa',
    physics: {
        default: "arcade",
        arcade: { debug: false }
    },
    scene: [SplashScene, LevelIntroScene, GameScene]
});