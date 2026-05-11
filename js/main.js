
import { GameScene } from "./GameScene.js";
import { HubScene } from "./HubScene.js";
import { LevelIntroScene } from "./LevelIntroScene.js";
const W = 960, H = 540;


new Phaser.Game({
    type: Phaser.AUTO,
    width: W,
    height: H,
    backgroundColor: '#4488aa',
    physics: {
        default: "arcade",
        arcade: { debug: true }
    },
    scene: [HubScene, LevelIntroScene, GameScene]
});