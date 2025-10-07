function preload() {

    puker_states = [
        {
            id: 0,
            name: "puker_bumping",
            height: 194,
            width: 238
        },
        {
            id: 1,
            name: "puker_drinking",
            height: 188,
            width: 320
        },
        {
            id: 2,
            name: "puker_falling",
            height: 226,
            width: 420
        },
        {
            id: 3,
            name: "puker_gagging",
            height: 182,
            width: 227
        },
        {
            id: 4,
            name: "puker_running",
            height: 209,
            width: 225
        },
        {
            id: 5,
            name: "puker_stumbling_1",
            height: 197,
            width: 240
        },
        {
            id: 6,
            name: "puker_stumbling_2",
            height: 175,
            width: 240
        },
        {
            id: 7,
            name: "puker_walking",
            height: 166,
            width: 240
        }
    ];

    this.load.path = '../assets/';
    puker_states.forEach(state => {
        this.load.spritesheet(state.name, 'spritesheets/' + state.name + '.png', { frameWidth: state.width, frameHeight: state.height });
    });

    this.load.spritesheet('background items', 'spritesheets/background items.png', { frameWidth: 381, frameHeight: 196 });
    this.load.spritesheet('girl walker', 'spritesheets/girl walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('dude walker', 'spritesheets/dude walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('hoodie walker', 'spritesheets/hoodie walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('game consoles', 'spritesheets/game consoles.png', { frameWidth: 96, frameHeight: 152 });
    this.load.image('wall', 'images/brick wall.png');
    this.load.image('floor', 'images/floor tile.png');
    this.load.image('pukeMeter', 'images/pukeMeter.png');
    this.load.image('puke', 'images/puke.png');
    this.load.image('splash', 'images/splash.png');
    this.load.image('avatar', 'images/avatar.png')
    this.load.image('power bar', 'images/power bar.png')
    //this.load.image('floor', 'images/p2.jpg');
    //this.load.image('floor 2', 'images/floor 2.png');
}