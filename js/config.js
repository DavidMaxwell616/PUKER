export const STAGEWIDTH = 800;
export const STAGEHEIGHT = 350;
export const MAX_ITEMS = 9;
export const PUKER_MIN_Y = 275;
export const PUKER_MAX_Y = 500;
export const OBSTACLE_MIN_Y = 275;
export const OBSTACLE_MAX_Y = 468;
export const MIDLINE = 385
export const FLOOR_TEXTURE_HEIGHT = 300;
export const OBJECT_START_X_OFFSET = 50;
export const PUKER_SIZE_FACTOR = 0.8;
export const MAX_DISTANCE = 500;
export const MIN_TINT = 0xFFFFFF; // White
export const MAX_TINT = 0x000000; // Black
export const BACKGROUND_WALKERS_Y = 190;
export const DEBUG = true;
export const MAX_PUKE_LIMIT = 40;

export const PUKER_STATE = Object.freeze({
    BUMPING: 0,
    DRINKING: 1,
    FALLING: 2,
    GAGGING: 3,
    RUNNING: 4,
    STUMBLING: 5,
    WALKING: 6,
    HIT: 7,
});

export const OBSTACLE_TYPE = Object.freeze({
    GAME_CONSOLE_1: 0,
    GAME_CONSOLE_2: 1,
    GAME_CONSOLE_3: 2,
    GAME_CONSOLE_4: 3,
    GAME_CONSOLE_5: 4,
    GAME_CONSOLE_6: 5,
    GAME_CONSOLE_7: 6,
    TABLE: 7,
    CHAIR: 8
});

export const PUKER_ANIM = Object.freeze({
    BUMPING: "puker_bumping",
    DRINKING: "puker_drinking",
    FALLING: "puker_falling",
    GAGGING: "puker_gagging",
    RUNNING: "puker_running",
    STUMBLING: "puker_stumbling",
    WALKING: "puker_walking",
    HIT: "puker_bumping",
});

export const PUKER_STATES = [
    {
        id: 0,
        name: "puker_bumping",
        width: 194,
        height: 238,
        frames: 12,
        repeat: false,
    },
    {
        id: 1,
        name: "puker_drinking",
        width: 188,
        height: 240,
        frames: 18,
        repeat: false,
    },
    {
        id: 2,
        name: "puker_falling",
        width: 226,
        height: 240,
        frames: 19,
        repeat: false,
    },
    {
        id: 3,
        name: "puker_gagging",
        width: 182,
        height: 227,
        frames: 31,
        repeat: false,
    },
    {
        id: 4,
        name: "puker_running",
        width: 209,
        height: 225,
        frames: 9,
        repeat: true,
    },
    {
        id: 5,
        name: "puker_stumbling",
        width: 175,
        height: 240,
        frames: 17,
        repeat: false,
    },
    {
        id: 6,
        name: "puker_walking",
        width: 172,
        height: 238,
        frames: 9,
        repeat: true,
    }
];

export const PEOPLE_SPRITES = [
    {
        id: 0,
        name: "dude_1",
        width: 170,
        height: 240,
        frames: 31,
        hit: false,
        repeat: false
    },
    {
        id: 1,
        name: "dude_2",
        width: 200,
        height: 240,
        frames: 36,
        hit: false,
        repeat: false
    },
    {
        id: 2,
        name: "dude_3",
        width: 186,
        height: 240,
        frames: 12,
        hit: false,
        repeat: false
    },
    {
        id: 3,
        name: "dude_4",
        width: 249,
        height: 240,
        frames: 31,
        hit: false,
        repeat: false
    },
    {
        id: 4,
        name: "girl",
        width: 178,
        height: 240,
        frames: 16,
        hit: false,
        repeat: false
    }
];

export const WALKER_SPRITES = [
    {
        id: 0,
        name: "walker_1",
        width: 161,
        height: 240,
        frames: 15,
        repeat: true,
    },
    {
        id: 1,
        name: "walker_2",
        width: 183,
        height: 240,
        frames: 19,
        repeat: true
    },
    {
        id: 2,
        name: "walker_3",
        width: 173,
        height: 240,
        frames: 16,
        repeat: true
    },
];

export const startButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(560, 352),
    new Phaser.Geom.Point(815, 335),
    new Phaser.Geom.Point(823, 392),
    new Phaser.Geom.Point(563, 408)
]);

export const instructionsButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(485, 450),
    new Phaser.Geom.Point(693, 435),
    new Phaser.Geom.Point(702, 475),
    new Phaser.Geom.Point(490, 490)
]);

export const scoreboardButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(715, 434),
    new Phaser.Geom.Point(893, 446),
    new Phaser.Geom.Point(895, 485),
    new Phaser.Geom.Point(715, 470)
]);

export const exitInstructionsShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(558, 435),
    new Phaser.Geom.Point(650, 428),
    new Phaser.Geom.Point(655, 465),
    new Phaser.Geom.Point(558, 475)
]);

export const GAME_STATE = Object.freeze({
    INTRO: 0,
    LEVEL_INTRO: 1,
    INSTRUCTIONS: 2,
    SCOREBOARD: 3,
    LEVEL: 4
});

export const FLOOR_TEXTURES = {
    Level1: `level_1_floor_1`,
    Level2: `level_2_floor_1`,
    Level3: `level_3_floor_1`,
}

export const exitScoreboardShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(890, 447),
    new Phaser.Geom.Point(986, 442),
    new Phaser.Geom.Point(986, 491),
    new Phaser.Geom.Point(885, 485)
]);

