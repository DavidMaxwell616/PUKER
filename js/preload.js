function preload() {
    this.load.path = '../assets/spritesheets/';
    puker_states.forEach(state => {
        this.load.spritesheet(state.name, state.name + '.png', { frameWidth: state.width, frameHeight: state.height });
    });
    people_sprites.forEach(person => {
        this.load.spritesheet(person.name, person.name + '.png', { frameWidth: person.width, frameHeight: person.height });
    });
    walker_sprites.forEach(walker => {
        this.load.spritesheet(walker.name, walker.name + '.png', { frameWidth: walker.width, frameHeight: walker.height });
    });

    this.load.spritesheet('background items', 'background items.png', { frameWidth: 381, frameHeight: 196 });
    this.load.spritesheet('game consoles', 'game consoles.png', { frameWidth: 96, frameHeight: 152 });
    this.load.path = '../assets/images/';
    this.load.image('wall', 'brick wall.png');
    this.load.image('floor', 'floor tile.png');
    this.load.image('pukeMeter', 'pukeMeter.png');
    this.load.image('pukeLevel', 'puke.png');
    this.load.image('splash1', 'splash_1.png');
    this.load.image('splash2', 'splash_2.jpg');
    this.load.image('splash3', 'splash_3.jpg');
    this.load.image('splash4', 'splash_4.jpg');
    this.load.image('avatar', 'avatar.png')
    this.load.image('power bar', 'power bar.png')
    //this.load.image('floor', 'images/p2.jpg');
    //this.load.image('floor 2', 'images/floor 2.png');
}