
import { GameScene } from "./GameScene.js";
import { HubScene } from "./HubScene.js";
const W = 960, H = 540;


new Phaser.Game({
    type: Phaser.AUTO,
    width: W,
    height: H,
    physics: {
        default: "arcade",
        arcade: { debug: false }
    },
    scene: [HubScene, GameScene]
});