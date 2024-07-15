function preload() {
this.load.path = '../assets/';
this.load.spritesheet('puker', 'spritesheets/puker.png', { frameWidth: 172, frameHeight: 238 });
this.load.spritesheet('background items', 'spritesheets/background items.png', { frameWidth: 381, frameHeight: 196 });
this.load.spritesheet('girl Walker', 'spritesheets/girl walking.png', { frameWidth: 168, frameHeight: 218});
this.load.spritesheet('dude Walker', 'spritesheets/dude walking.png', { frameWidth: 168, frameHeight: 218 });
this.load.spritesheet('hoodie Walker', 'spritesheets/hoodie walking.png', { frameWidth: 168, frameHeight: 218 });
this.load.image('wall', 'images/brick wall.png');
this.load.image('floor', 'images/floor tile.png');
this.load.image('pukeMeter','images/pukeMeter.png');
this.load.image('splash','images/splash.png');
//this.load.image('floor', 'images/p2.jpg');
//this.load.image('floor 2', 'images/floor 2.png');
}