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
var puker_states;
var puker_state;

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
