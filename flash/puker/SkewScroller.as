class puker.SkewScroller
{
   var _parent;
   var _rotation;
   var _y;
   var app;
   var intWalker;
   var lRoot;
   var mForeground;
   var mLight;
   var mWalker;
   var mWall;
   var oOnGround;
   var realRot;
   var xInc;
   var yInc;
   var yStart;
   var XMID = 0;
   var xAngle = null;
   var xGap = 120;
   var tileTot = 3;
   var itemTot = 0;
   static var STAGEWIDTH = 800;
   static var STAGEHEIGHT = 350;
   static var MAX_ITEMS = 9;
   var tileGap = 0;
   var startDepth = 10;
   var newNumber = 0;
   function SkewScroller(_lRoot, _app)
   {
      this.lRoot = _lRoot;
      this.app = _app;
      this.oOnGround = new Object();
   }
   function init()
   {
      this.mWall = this.lRoot.attachMovie("_mWall_" + this.app.gameLevel,"mWall",5,{_y:150});
      this.mForeground = this.lRoot.attachMovie("_mForeground_" + this.app.gameLevel,"mForeground",500,{_y:350});
      this.mWalker = this.lRoot.attachMovie("_mWalker","mWalker",150,{_x:850,_y:165});
      this.mWalker.xInc = 3;
      this.mWalker.mc.stop();
      this.getRandomFrame(this.mForeground);
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc2_ < this.tileTot)
      {
         _loc3_ = this.lRoot.attachMovie("_mFloor_" + this.app.gameLevel,"mTile" + _loc2_,50 + _loc2_,{_y:150,_x:puker.SkewScroller.STAGEWIDTH / 2 * _loc2_});
         _loc4_ = _loc3_.transform.matrix;
         _loc3_.mtxWall = _loc4_;
         _loc3_ = this.lRoot.attachMovie("_mBkItem_" + this.app.gameLevel,"mBkItem" + _loc2_,100 + _loc2_,{_y:155,_x:puker.SkewScroller.STAGEWIDTH / 2 * _loc2_});
         this.getRandomFrame(_loc3_);
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < 4 + this.app.gameLevel)
      {
         this.addHitItem();
         _loc2_ = _loc2_ + 1;
      }
      this.mLight = this.lRoot.attachMovie("_mLight_" + this.app.gameLevel,"mLight",450,{_y:0,_x:puker.SkewScroller.STAGEWIDTH / 2});
      this.startScroll();
   }
   function addWalker()
   {
      this.getRandomFrame(this.mWalker);
      this.mWalker.mc.play();
      this.mWalker.onEnterFrame = mx.utils.Delegate.create(this,this.updateWalker);
   }
   function updateWalker()
   {
      this.mWalker._x -= this.mWalker.xInc + this.app.curSpeed;
      if(this.mWalker._x < -50)
      {
         this.mWalker._x = 850;
         this.mWalker.mc.stop();
         delete this.mWalker.onEnterFrame;
      }
   }
   function addPickup()
   {
      this.newNumber = this.newNumber + 1;
      var _loc2_ = this.lRoot.attachMovie("_mPickup","mPickup" + this.newNumber,this.lRoot.getNextHighestDepth());
      _loc2_.Blur_blurY = 0;
      _loc2_.id = "mPickup" + this.newNumber;
      _loc2_.style = "once";
      _loc2_.contact = true;
      this.oOnGround[_loc2_.id] = _loc2_;
      this.findClearGround(_loc2_);
   }
   function addHitItem()
   {
      var _loc2_;
      if(++this.itemTot < puker.SkewScroller.MAX_ITEMS)
      {
         this.newNumber = this.newNumber + 1;
         _loc2_ = this.lRoot.attachMovie("_mItem_" + this.app.gameLevel,"mItem" + this.newNumber,this.lRoot.getNextHighestDepth());
         _loc2_.Blur_blurY = 0;
         _loc2_.id = "mItem" + this.newNumber;
         _loc2_.style = "repeat";
         _loc2_.contact = false;
         this.oOnGround[_loc2_.id] = _loc2_;
         this.findClearGround(_loc2_);
      }
   }
   function itemOffScreen(mc)
   {
      if(mc.style == "repeat")
      {
         this.findClearGround(mc);
      }
      else
      {
         delete this.oOnGround[mc.id];
         mc.removeMovieClip();
      }
   }
   function findClearGround(mc)
   {
      delete this.oOnGround[mc.id];
      var _loc4_ = Math.random() * 170 + 175;
      var _loc5_ = puker.SkewScroller.STAGEWIDTH + 50 + Math.random() * 300;
      if(Math.random() * 1 < 0.2)
      {
         _loc4_ = this.app.mDan._y;
      }
      var _loc2_;
      var _loc3_;
      var _loc6_;
      for(var _loc9_ in this.oOnGround)
      {
         _loc2_ = this.lRoot[_loc9_];
         _loc3_ = true;
         _loc6_ = 0;
         while(_loc3_)
         {
            _loc3_ = false;
            if(_loc2_._x > _loc5_ - 100 && _loc2_._x < _loc5_ + 100)
            {
               if(_loc2_._y > _loc4_ - 50 && _loc2_._y < _loc4_ + 50)
               {
                  _loc4_ = Math.random() * 170 + 175;
                  _loc5_ = puker.SkewScroller.STAGEWIDTH + 50 + Math.random() * 300;
                  trace("== POSITION OVERLAP ==");
                  _loc3_ = true;
               }
            }
            if((_loc6_ = _loc6_ + 1) > 10)
            {
               trace("============ POSITION EJECT ============");
               _loc3_ = false;
            }
         }
      }
      mc._x = _loc5_;
      mc._y = _loc4_;
      this.depthCheck(mc);
      this.getRandomFrame(mc);
      var _loc8_ = (mc._y / 8 + 70) / 100;
      mc._xscale = mc._yscale = _loc8_ * 100;
      var _loc10_ = new flash.geom.Transform(mc);
      _loc10_.colorTransform = new flash.geom.ColorTransform(_loc8_,_loc8_,_loc8_,1,0,0,0,0);
      if(Math.random() * 1 > 0.5)
      {
         mc.mc._xscale *= -1;
      }
      mc.mc.gotoAndStop(1);
      mc.contact = false;
      mc._rotation = mc.mc._rotation = mc._rotation = mc.mc.mc._rotation = 0;
      delete mc.mc.onEnterFrame;
      this.oOnGround[mc.id] = mc;
   }
   function depthCheck(mc)
   {
      var _loc3_ = Math.round(mc._y);
      var _loc2_ = true;
      var _loc4_ = 0;
      while(_loc2_)
      {
         _loc2_ = false;
         if(this.lRoot.getInstanceAtDepth(_loc3_))
         {
            _loc3_ = _loc3_ + 1;
            trace("== DEPTH OVERLAP == ");
            _loc2_ = true;
         }
         if((_loc4_ = _loc4_ + 1) > 10)
         {
            trace("============ DEPTH EJECT ============");
            _loc2_ = false;
         }
      }
      mc.swapDepths(_loc3_);
   }
   function startScroll()
   {
      this.lRoot.onEnterFrame = mx.utils.Delegate.create(this,this.updatePersp);
      if(this.mWalker._x < 850)
      {
         this.mWalker.mc.play();
         this.mWalker.onEnterFrame = mx.utils.Delegate.create(this,this.updateWalker);
      }
      clearInterval(this.intWalker);
      this.intWalker = setInterval(this,"addWalker",10000);
   }
   function stopScroll()
   {
      delete this.lRoot.onEnterFrame;
      delete this.mWalker.onEnterFrame;
      this.mWalker.mc.stop();
      clearInterval(this.intWalker);
   }
   function updatePersp()
   {
      if((this.mWall._x -= this.app.curSpeed) < -200)
      {
         this.mWall._x += 200;
      }
      if((this.mForeground._x -= this.app.curSpeed * 4) < - puker.SkewScroller.STAGEWIDTH)
      {
         this.mForeground._x += puker.SkewScroller.STAGEWIDTH * 2;
         this.getRandomFrame(this.mForeground);
      }
      if((this.mLight._x -= this.app.curSpeed * 1.5) < -100)
      {
         this.mLight._x += puker.SkewScroller.STAGEWIDTH + 200;
      }
      var _loc5_ = 0;
      var _loc2_;
      while(_loc5_ < this.tileTot)
      {
         _loc2_ = this.lRoot["mTile" + _loc5_];
         _loc2_.mtxWall.tx -= this.app.curSpeed;
         if(_loc2_.mtxWall.tx < 0)
         {
            _loc2_.mtxWall.tx += puker.SkewScroller.STAGEWIDTH + 400;
            this.getRandomFrame(_loc2_);
         }
         _loc2_.mtxWall.c = (_loc2_.mtxWall.tx - 600) * 0.0048;
         _loc2_.transform.matrix = _loc2_.mtxWall;
         _loc2_ = this.lRoot["mBkItem" + _loc5_];
         _loc2_._x -= this.app.curSpeed;
         if(_loc2_._x < -300)
         {
            _loc2_._x += puker.SkewScroller.STAGEWIDTH + 350;
            this.getRandomFrame(_loc2_);
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc3_ = 40;
      var _loc4_ = 20;
      for(_loc5_ in this.oOnGround)
      {
         _loc2_ = this.lRoot[_loc5_];
         _loc2_._x -= this.app.curSpeed * (1 + (_loc2_._y - 150) / 200);
         _loc2_.Blur_blurX = this.app.curSpeed * (_loc2_._xscale / 75);
         if(!_loc2_.contact)
         {
            if(_loc2_._x > this.app.mDan._x - _loc3_ && _loc2_._x < this.app.mDan._x + _loc3_)
            {
               if(_loc2_._y > this.app.mDan._y - _loc4_ && _loc2_._y < this.app.mDan._y + _loc4_)
               {
                  this.hitThis(_loc2_);
               }
            }
         }
         if(_loc2_._x < -50)
         {
            this.itemOffScreen(_loc2_);
         }
      }
   }
   function hitThis(mc)
   {
      switch(mc.hitType)
      {
         case "person":
            mc.mc.gotoAndPlay(2);
            mc.contact = true;
            this.app.mDan.hitItem(10,"hitPerson",mc._y < this.app.mDan._y,true);
            this.app.soundControl.playSound("_sndHitPerson0" + Math.ceil(Math.random() * 3),50);
            this.app.soundControl.playSound("_sndHitObject01",100);
            break;
         case "large":
            mc.contact = true;
            this.app.mDan.hitItem(15,"hitLarge",mc._y < this.app.mDan._y,true);
            this.app.soundControl.playSound("_sndHitObject0" + Math.ceil(Math.random() * 3),200);
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:mc.mc,start_rotation:Math.random() * 10 + 5,_rotation:0,ease:"easeOutElastic",seconds:1});
            break;
         case "medium":
            mc.contact = true;
            this.app.mDan.hitItem(8,"hitMedium",mc._y < this.app.mDan._y,false);
            this.app.soundControl.playSound("_sndHitObject0" + Math.ceil(Math.random() * 3),200);
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:mc.mc.mc,_rotation:90,ease:"easeOutBounce",seconds:1.5});
            break;
         case "small":
            mc.contact = true;
            this.kickThis(mc.mc);
            this.app.mDan.hitItem(5,"hitSmall",mc._y < this.app.mDan._y,false);
            this.app.soundControl.playSound("_sndHitObject0" + Math.ceil(Math.random() * 3),200);
            break;
         case "pickup":
            mc.contact = true;
            mc.mc.gotoAndPlay("drink");
            this.app.pukeLevel -= 25;
            this.app.mDan.hitDrink();
         default:
            return;
      }
   }
   function kickThis(mc)
   {
      mc.yInc = Math.random() * -8 - 8;
      mc.xInc = this.app.curSpeed * 2;
      mc.yStart = mc._y;
      mc.rotTarg = Math.ceil(Math.random() * 3) * 90 + 180;
      mc.realRot = 0;
      mc.onEnterFrame = function()
      {
         this._y += this.yInc += 1;
         this._parent._x += this.xInc *= 0.95;
         this.realRot += (mc.rotTarg - this.realRot) / 10;
         this._rotation = this.realRot;
         if(this._y > this.yStart)
         {
            this._y = this.yStart;
            this.yInc *= -0.4;
            this.xInc *= 0.7;
         }
      };
   }
   function goQueazy()
   {
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.lRoot,_tint:"0x93DF20",_tintPercent:25,ease:"easeInQuad",seconds:3});
   }
   function fadeOutItems()
   {
      for(var _loc6_ in this.oOnGround)
      {
         com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.oOnGround[_loc6_],_alpha:0,ease:"easeInQuad",seconds:0.5});
      }
   }
   function getRandomFrame(mc)
   {
      mc.gotoAndStop(Math.ceil(Math.random() * mc._totalframes));
   }
   function pauseHit(pauseState)
   {
      if(pauseState)
      {
         this.stopScroll();
      }
      else
      {
         this.startScroll();
      }
   }
   function destroy()
   {
      this.stopScroll();
      this.lRoot.removeMovieClip();
      false;
   }
}
