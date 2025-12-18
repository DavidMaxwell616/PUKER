const STAGEWIDTH = 800;
const STAGEHEIGHT = 350;
const MAX_ITEMS = 9;
const PUKER_MIN_Y = 275;
const PUKER_MAX_Y = 500;
const OBSTACLE_MIN_Y = 275;
const OBSTACLE_MAX_Y = 468;
const MIDLINE = 385
const FLOOR_TEXTURE_HEIGHT = 300;
const OBJECT_START_X_OFFSET = 50;
const PUKER_SIZE_FACTOR = 0.8;
const MAX_DISTANCE = 500;
const MIN_TINT = 0xFFFFFF; // White
const MAX_TINT = 0x000000; // Black

var puker;
var startGame;
var wall;
var wall2;
var floorMesh;

var tileGap = 0;
var startDepth = 10;
var floorShadow;
var backgroundItems;
var backgroundItemsTimer = 0;
var backgroundItemsTimerMax = 0;
var backgroundImages;
var backgroundItemsY = 186;
var cursors;
var isUpDown;
var isDownDown;
var pukerScale = 1;
var pukerSpeed = 1;
var walkerShowing = false;
var walkerSpeed = 1;
var backgroundWalkers = [];
var backgroundWalkersTimer = 0;
var backgroundWalkers;
var backgroundWalkersY = 190;
var people;
var peopleTimer = 0;
var peopleTimerMax = 0;
var pukerPause = false;
var pukerPauseTimer = 0;
var pukerPauseTimeMax = 100;
var puke_sign;
var obstacles;
var waters;
var waterTimer = 0;
var waterTimerMax;
var obstacle_sprites;
var obstaclesTimer = 0;
var obstaclesTimerMax;
var walkersTimer = 0;
var walkersTimerMax;
var pukerStates;
var puker;
var timeMin = 400;
var timeMax = 1000;
var cursors;
var isUpDown;
var isDownDown;
var pukeMeter;
var splash;
var instructions;
var powerBar;
var avatar;
var pukeLevel;
var pukeTint;
var currentPukerState;
var game_state;
var scoreboard;

const PUKER_STATE = Object.freeze({
    BUMPING: 0,
    DRINKING: 1,
    FALLING: 2,
    GAGGING: 3,
    RUNNING: 4,
    STUMBLING_1: 5,
    STUMBLING_2: 6,
    WALKING: 7
});

const OBSTACLE_TYPE = Object.freeze({
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

const PUKER_ANIM = Object.freeze({
    BUMPING: "puker_bumping",
    DRINKING: "puker_drinking",
    FALLING: "puker_falling",
    GAGGING: "puker_gagging",
    RUNNING: "puker_running",
    STUMBLING_1: "puker_stumbling_1",
    STUMBLING_2: "puker_stumbling_2",
    WALKING: "puker_walking"
});

const puker_states = [
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
        height: 420,
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
        name: "puker_stumbling_1",
        width: 197,
        height: 240,
        frames: 17,
        repeat: false,
    },
    {
        id: 6,
        name: "puker_stumbling_2",
        width: 175,
        height: 240,
        frames: 17,
        repeat: false,
    },
    {
        id: 7,
        name: "puker_walking",
        width: 172,
        height: 238,
        frames: 9,
        repeat: true,
    }
];

const people_sprites = [
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

const walker_sprites = [
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

const startButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(560, 352),
    new Phaser.Geom.Point(815, 335),
    new Phaser.Geom.Point(823, 392),
    new Phaser.Geom.Point(563, 408)
]);

const instructionsButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(485, 450),
    new Phaser.Geom.Point(693, 435),
    new Phaser.Geom.Point(702, 475),
    new Phaser.Geom.Point(490, 490)
]);

const scoreboardButtonShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(715, 434),
    new Phaser.Geom.Point(893, 446),
    new Phaser.Geom.Point(895, 485),
    new Phaser.Geom.Point(715, 470)
]);

const exitInstructionsShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(558, 435),
    new Phaser.Geom.Point(650, 428),
    new Phaser.Geom.Point(655, 465),
    new Phaser.Geom.Point(558, 475)
]);

const GAME_STATE = Object.freeze({
    INTRO: 0,
    INSTRUCTIONS: 1,
    SCOREBOARD: 2,
    LEVEL_1: 3,
    LEVEL_2: 4,
    LEVEL_3: 5
});

const exitScoreboardShape = new Phaser.Geom.Polygon([
    new Phaser.Geom.Point(890, 447),
    new Phaser.Geom.Point(986, 442),
    new Phaser.Geom.Point(986, 491),
    new Phaser.Geom.Point(885, 485)
]);

