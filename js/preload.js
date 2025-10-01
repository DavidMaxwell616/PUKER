function preload() {
    this.load.path = '../assets/';
    this.load.spritesheet('puker', 'spritesheets/puker.png', { frameWidth: 166, frameHeight: 238 });
    this.load.spritesheet('puker2', 'spritesheets/puker 2.png', { frameWidth: 172, frameHeight: 238 });
    this.load.spritesheet('background items', 'spritesheets/background items.png', { frameWidth: 381, frameHeight: 196 });
    this.load.spritesheet('girl walker', 'spritesheets/girl walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('dude walker', 'spritesheets/dude walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('hoodie walker', 'spritesheets/hoodie walking.png', { frameWidth: 168, frameHeight: 218 });
    this.load.spritesheet('game consoles', 'spritesheets/game consoles.png', { frameWidth: 96, frameHeight: 152 });
    this.load.image('wall', 'images/brick wall.png');
    this.load.image('floor', 'images/floor tile.png');
    this.load.image('pukeMeter', 'images/pukeMeter.png');
    this.load.image('splash', 'images/splash.png');
    this.load.image('avatar', 'images/avatar.png')
    this.load.image('power bar', 'images/power bar.png')
    //this.load.image('floor', 'images/p2.jpg');
    //this.load.image('floor 2', 'images/floor 2.png');
}