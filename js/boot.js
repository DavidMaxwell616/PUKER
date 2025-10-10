var puker;
var startGame;
var wall;
var wall2;
var floorMesh;
const STAGEWIDTH = 800;
const STAGEHEIGHT = 350;
const MAX_ITEMS = 9;
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

var cursors;
var isUpDown;
var isDownDown;
var pukeMeter;
var splash;
var powerBar;
var avatar;

const PUKER_STATE_ENUM =
{
    "puker_bumping": 0,
    "puker_drinking": 1,
    "puker_falling": 2,
    "puker_gagging": 3,
    "puker_running": 4,
    "puker_stumbling_1": 5,
    "puker_stumbling_2": 6,
    "puker_walking": 7
};

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
        frames: 19
    },
    {
        id: 2,
        name: "puker_falling",
        width: 226,
        height: 420,
        frames: 33
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
