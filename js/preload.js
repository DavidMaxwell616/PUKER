function preload() {
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