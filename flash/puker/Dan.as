class puker.Dan extends MovieClip
{
   var _app;
   var isWalking;
   var mRadius;
   var mc;
   var onEnterFrame;
   var xInc;
   var yInc;
   static var MAXSPEED = 12;
   static var WALKSPEED = 6;
   static var MINSPEED = 4;
   static var MAXY = 340;
   static var MINY = 175;
   var inControl = true;
   function Dan()
   {
      super();
      this.init();
   }
   function init()
   {
      this._x = -50;
      this._y = 300;
      this.yInc = 0;
      this.gotoAndStop("walk");
      this.mc.gotoAndPlay("seq" + Math.ceil(Math.random() * 2));
      this.isWalking = true;
      this._xscale = this._yscale = this._y / 8 + 60;
      this.depthCheck();
      this._app.distLevel += this._app.curSpeed / 100;
      this._app.pukeLevel = Math.max(this._app.pukeLevel += 0.2,0);
      this.mRadius._xscale = 40 + this._app.pukeLevel / 6;
      this.mRadius._yscale = this.mRadius._xscale / 2;
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:puker.Dan.WALKSPEED,ease:"easeInQuad",delay:0.5,seconds:1});
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,scope:this,_x:200,ease:"easeOutQuad",seconds:2,func:"onScreen"});
   }
   function updateMove()
   {
      if(this.inControl)
      {
         if(Key.isDown(39) || Key.isDown(68))
         {
            this.xInc = (350 + (this._y - 225) / 10 - this._x) / 35;
            this._x += this.xInc;
            this._app.curSpeed = Math.min(this._app.curSpeed += 0.2,puker.Dan.MAXSPEED) + this.xInc / 5;
            this._app.pukeLevel += 0.075;
            if(this.isWalking)
            {
               this.gotoAndStop("run");
               this.mc.gotoAndPlay("seq" + Math.ceil(Math.random() * 2));
               this.isWalking = false;
            }
         }
         else if(Key.isDown(37) || Key.isDown(65))
         {
            this.xInc = (50 + (this._y - 225) / 10 - this._x) / 35;
            this._x += this.xInc;
            this._app.curSpeed = Math.max(this._app.curSpeed *= 0.9,puker.Dan.MINSPEED) + this.xInc / 5;
            if(!this.isWalking)
            {
               this.gotoAndStop("walk");
               this.mc.gotoAndPlay("seq" + Math.ceil(Math.random() * 2));
               this.isWalking = true;
            }
         }
         else
         {
            this.xInc = (200 + (this._y - 225) / 10 - this._x) / 40;
            this._x += this.xInc;
            this._app.curSpeed = Math.max(this._app.curSpeed *= 0.9,puker.Dan.WALKSPEED) + this.xInc / 5;
            if(!this.isWalking)
            {
               this.gotoAndStop("walk");
               this.mc.gotoAndPlay("seq" + Math.ceil(Math.random() * 2));
               this.isWalking = true;
            }
         }
         if(Key.isDown(38) || Key.isDown(87))
         {
            this.yInc = Math.max(this.yInc - puker.Dan.WALKSPEED / (this._app.curSpeed * 1.5),-5);
         }
         else if(Key.isDown(40) || Key.isDown(83))
         {
            this.yInc = Math.min(this.yInc + puker.Dan.WALKSPEED / (this._app.curSpeed * 1.5),5);
         }
         else
         {
            this.yInc *= 0.7;
         }
      }
      this._y += this.yInc;
      if(this._y > puker.Dan.MAXY)
      {
         this._y = puker.Dan.MAXY;
         this.yInc = 0;
      }
      else if(this._y < puker.Dan.MINY)
      {
         this._y = puker.Dan.MINY;
         this.yInc = 0;
      }
      this._xscale = this._yscale = this._y / 8 + 60;
      this.depthCheck();
      this._app.distLevel += this._app.curSpeed / 100;
      this._app.pukeLevel += 0.15;
      this.mRadius._xscale = 40 + this._app.pukeLevel / 6;
      this.mRadius._yscale = this.mRadius._xscale / 2;
   }
   function depthCheck()
   {
      var _loc3_ = Math.round(this._y);
      var _loc2_ = this._parent.getInstanceAtDepth(_loc3_);
      if(_loc2_ && _loc2_ != this)
      {
         this.swapDepths(_loc2_);
      }
      else
      {
         this.swapDepths(_loc3_);
      }
   }
   function hitItem(addPuke, reactStyle, inFront, fullStop)
   {
      var _loc2_;
      if(this.inControl)
      {
         this._app.pukeLevel += addPuke;
         this.inControl = false;
         this.gotoAndStop(reactStyle);
         this.isWalking = true;
         if(fullStop)
         {
            this._app.curSpeed = -1;
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:0,ease:"easeInQuad",seconds:0.2});
         }
         else
         {
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:0,ease:"easeInQuad",seconds:0.2});
         }
         this.xInc = this.yInc = 0;
         if(inFront)
         {
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_y:Math.min(this._y + 20,puker.Dan.MAXY),ease:"easeOutQuad",seconds:0.3});
         }
         else
         {
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_y:Math.max(this._y - 20,puker.Dan.MINY),ease:"easeOutQuad",seconds:0.3});
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            this.attachMovie("_mDribble","mDribble",this.getNextHighestDepth(),{_y:-110});
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function hitDrink()
   {
      this._app.curSpeed = -1;
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:0,ease:"easeInQuad",seconds:0.2});
      this.inControl = false;
      this.gotoAndStop("drink");
      this.isWalking = true;
      this.xInc = this.yInc = 0;
   }
   function seqDone()
   {
      if(!this._app.runLevelOver)
      {
         this.gotoAndStop("walk");
         this.inControl = true;
         com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:puker.Dan.WALKSPEED,ease:"easeInQuad",seconds:0.2});
      }
      else
      {
         this.startRetching();
      }
   }
   function walkOffScreen()
   {
      this.inControl = false;
      delete this.onEnterFrame;
      this.gotoAndStop("run");
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:0,_x:0,ease:"easeOutQuad",seconds:0.5});
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,scope:this,_x:850,ease:"linear",seconds:1.5,func:"runLevelOver"});
   }
   function startRetching()
   {
      this.inControl = false;
      delete this.onEnterFrame;
      this.gotoAndStop("retch");
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this._app,curSpeed:0,_x:0,ease:"easeOutQuad",seconds:0.2});
   }
   function runLevelOver()
   {
      this._app.initSubGame();
      this.removeMovieClip();
   }
   function onScreen()
   {
      this.onEnterFrame = this.updateMove;
      this._app.addPause();
   }
   function pauseHit(pauseState)
   {
      if(pauseState)
      {
         delete this.onEnterFrame;
         this.mc.stop();
      }
      else
      {
         this.onEnterFrame = this.updateMove;
         this.mc.play();
      }
   }
}
