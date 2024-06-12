class puker.Hud extends MovieClip
{
   var mPukometer;
   var intUpdate;
   var mDistometer;
   var _app;
   static var PUKE_MIN = 335;
   static var PUKE_MAX = 27;
   static var DIST_MIN = 75;
   var nextPickupPoint = 10;
   var cnt = 0;
   function Hud()
   {
      super();
      this.init();
   }
   function init()
   {
      this.mPukometer.mBaseMask.gotoAndPlay(30);
      this.mPukometer.mPukeWord.gotoAndStop(1);
      this.updateHud();
      clearInterval(this.intUpdate);
      this.intUpdate = setInterval(this,"updateHud",200);
      this.mPukometer.mBaseMask.onEnterFrame = mx.utils.Delegate.create(this,this.updateBaseMask);
   }
   function updateBaseMask()
   {
      this.mPukometer.mBaseMask._y -= (this.mPukometer.mBaseMask._y - this.mPukometer.mUpperMask._y) / 10;
   }
   function updateHud()
   {
      this.mDistometer.mBar._x = this._app.distLevel * 5.75 + puker.Hud.DIST_MIN;
      this.mPukometer.mUpperMask._y = puker.Hud.PUKE_MIN - this._app.pukeLevel * 2;
      this._app.mSndDrone.snd.setVolume(this._app.pukeLevel / 4);
      if(++this.cnt > 20)
      {
         this.cnt = Math.random() * 10;
         this._app.soundControl.playSound("_sndRetch0" + Math.ceil(Math.random() * 5),Math.random() * 10 + 10);
      }
      if(this._app.distLevel > this.nextPickupPoint)
      {
         this._app.addPickup();
         this.nextPickupPoint += 10;
         this._app.instScroller.addHitItem();
      }
      else if(this._app.distLevel > 100)
      {
         this._app.distBarFull();
         clearInterval(this.intUpdate);
      }
      if(this.mPukometer.mBaseMask._y < puker.Hud.PUKE_MAX)
      {
         if(this._app.distLevel < 70)
         {
            this._app.pukeBarFull(1);
         }
         else
         {
            this._app.pukeBarFull(2);
         }
         clearInterval(this.intUpdate);
      }
      else if(this.mPukometer.mUpperMask._y < puker.Hud.PUKE_MAX + 30)
      {
         this.mPukometer.mPukeWord.play();
      }
      else
      {
         this.mPukometer.mPukeWord.gotoAndStop(1);
      }
   }
   function pauseHit(pauseState)
   {
      if(pauseState)
      {
         clearInterval(this.intUpdate);
      }
      else
      {
         clearInterval(this.intUpdate);
         this.intUpdate = setInterval(this,"updateHud",200);
      }
   }
   function destroy()
   {
      clearInterval(this.intUpdate);
      this.removeMovieClip();
      false;
   }
}
