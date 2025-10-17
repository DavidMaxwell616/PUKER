var puker;
var startGame;
var wall;
var wall2;
var floorMesh;
const STAGEWIDTH = 800;
const STAGEHEIGHT = 350;
const MAX_ITEMS = 9;
const PUKER_MIN_Y = 205;
const PUKER_MAX_Y = 368;
var tileGap = 0;
var startDepth = 10;
var floorShadow;
const floorTextureHeight = 300;
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
var walker;
var walkerSpeed = 1;
var backgroundWalkers = [];
var backgroundWalkersTimer = 0;
var backgroundWalkersTimerMax = 0;
var backgroundWalkers;
var backgroundWalkersY = 190;
var people;
var obstacles;
var game_consoles;
var obstaclesTimer = 0;
var obstaclesTimerMax;
var pukerStates;
var puker;
var timeMin = 400;
var timeMax = 600;
var cursors;
var isUpDown;
var isDownDown;
var pukeMeter;
var splash;
var powerBar;
var avatar;
var puke;
var pukeTint;
var currentPukerState;

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
        frames: 11
    },
    {
        id: 1,
        name: "puker_drinking",
        width: 188,
        height: 320,
        frames: 14
    },
    {
        id: 2,
        name: "puker_falling",
        width: 226,
        height: 420,
        frames: 19
    },
    {
        id: 3,
        name: "puker_gagging",
        width: 182,
        height: 227,
        frames: 30
    },
    {
        id: 4,
        name: "puker_running",
        width: 209,
        height: 225,
        frames: 9
    },
    {
        id: 5,
        name: "puker_stumbling_1",
        width: 197,
        height: 240,
        frames: 16
    },
    {
        id: 6,
        name: "puker_stumbling_2",
        width: 175,
        height: 240,
        frames: 16
    },
    {
        id: 7,
        name: "puker_walking",
        width: 166,
        height: 240,
        frames: 9
    }
];

const people_sprites = [
    {
        id: 0,
        name: "dude_1",
        width: 16,
        height: 116,
        frames: 31
    },
    {
        id: 1,
        name: "dude_2",
        width: 200,
        height: 240,
        frames: 36
    },
    {
        id: 2,
        name: "dude_3",
        width: 186,
        height: 180,
        frames: 12
    },
    {
        id: 3,
        name: "dude_4",
        width: 220,
        height: 212,
        frames: 31
    },
    {
        id: 4,
        name: "girl",
        width: 171,
        height: 230,
        frames: 16
    }
];
