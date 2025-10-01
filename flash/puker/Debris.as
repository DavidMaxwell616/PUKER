class puker.Debris extends MovieClip
{
   var onEnterFrame;
   var xAcc;
   var yAcc;
   var _scale = 2;
   function Debris()
   {
      super();
      this.init();
   }
   function init()
   {
      this.xAcc = Math.random() * 10 + 2;
      this.yAcc = Math.random() * 10 - 5;
      this._xscale = Math.random() * this._scale + this._scale;
      this._yscale = Math.random() * this._scale + this._scale;
      this.onEnterFrame = this.fly;
   }
   function fly()
   {
      this._x += this.xAcc *= 0.96;
      this._y += this.yAcc += 0.3;
      this._alpha -= 4;
      if(this._alpha < 0)
      {
         this.destroy();
      }
   }
   function destroy()
   {
      delete this.onEnterFrame;
      this.removeMovieClip();
   }
}
