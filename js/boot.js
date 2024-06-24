var puker;
var startGame;
var wall;
var wall2;
var floorMesh;
   var _app;
   var bmpHolder;
   var mBmp;
   var mSprayHolder;
   var mSplatterHolder;
   var mMask;
   var mPukometer;
   var mRecepArea;
   var mBk;
   var mSndSplatter;
   var mHint;
   var mTarg;
   var intDelay;
   var intCanvas;
   var mFiller;
   const MAXSPEED = 25;
   const RADIAN = 0.017453292519943295;
   const PUKETOT = 7;
   const PERCENT_TARG = 45;
   var xInc = 0;
   var yInc = 0;
   var xPull = 0;
   var yPull = 0;
   var cnt = 40;
   var allPercent = 0;
   var inPercent = 0;
   var outPercent = 0;
   var fade = 0.95;
   var lRoot;
   var app;
   var oOnGround;
   var mWall;
   var mForeground;
   var mWalker;
   var mLight;
   var intWalker;
   var _y;
   var yInc;
   var _parent;
   var xInc;
   var realRot;
   var _rotation;
   var yStart;
   var XMID = 0;
   var xAngle = null;
   var xGap = 120;
   var tileTot = 3;
   var itemTot = 0;
   const STAGEWIDTH = 800;
   const STAGEHEIGHT = 350;
   const MAX_ITEMS = 9;
   var tileGap = 0;
   var startDepth = 10;
  var floorShadow;
const white = '0xffffff';
const black = '0x000000';
const floorTextureHeight = 300;

   //    function SubGame()
//    {
//       super();
//       this.init();
//    }
//    function init()
//    {
//       this.gotoAndStop(this._app.subLevel);
//       this._app.soundControl.fadeTo(this._app.mSndDrone,50,0.5);
//       var _loc4_ = 0;
//       this.bmpHolder = new flash.display.BitmapData(800,380,true,0);
//       this.mBmp = this.createEmptyMovieClip("mBmp",this.getNextHighestDepth());
//       this.mBmp.attachBitmap(this.bmpHolder,0);
//       this.mSprayHolder = this.createEmptyMovieClip("mSprayHolder",this.getNextHighestDepth());
//       var _loc3_ = 0;
//       while(_loc3_ < puker.SubGame.PUKETOT)
//       {
//          var _loc2_ = this.mSprayHolder.attachMovie("_mPukeLine","mPukeLine" + _loc3_,this.mSprayHolder.getNextHighestDepth());
//          _loc2_.mc.gotoAndPlay(_loc3_ * 3);
//          _loc2_._x = 400;
//          _loc2_._y = 400;
//          _loc2_._yscale = 0;
//          _loc2_.mc._y = _loc4_;
//          _loc2_.mc._yscale = _loc2_.mc._xscale = 100 - _loc3_ * 10;
//          _loc4_ = _loc2_.mc._y - 75 * (_loc2_.mc._yscale / 100);
//          _loc2_.mc.mToMask.setMask(_loc2_.mc.mMask);
//          _loc3_ = _loc3_ + 1;
//       }
//       this.mSplatterHolder = this.createEmptyMovieClip("mSplatterHolder",this.getNextHighestDepth());
//       this.mSplatterHolder.setMask(this.mMask);
//       this.mPukometer = this.attachMovie("_mPukometer","mPukometer",this.getNextHighestDepth(),{_x:-75});
//       this.mPukometer.mBaseMask.gotoAndPlay(30);
//       this.mPukometer.mBaseMask._yscale *= -1;
//       this.mPukometer.mUpperMask._yscale *= -1;
//       this.mRecepArea.gotoAndStop(1);
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mBk,scope:this,start_alpha:100,_alpha:50,start_Blur_blurX:50,Blur_blurX:15,start_scale:120,_scale:100,ease:"easeOutBounce",seconds:2.5,func:"initGame"});
//    }
//    function initGame()
//    {
//       this._app.soundControl.playSound("_sndStartPuke",100);
//       this.mSndSplatter = this._app.soundControl.playSoundFade("_sndSplatter",1,100,true);
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mPukometer,_x:15,ease:"easeOutBack",seconds:1});
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mHint,_alpha:0,ease:"easeInQuad",seconds:0.5});
//       this.mTarg = this.attachMovie("_mTarg","mTarg",this.getNextHighestDepth(),{_alpha:0});
//       this.mTarg._x = 400;
//       this.mTarg._y = 400;
//       this.xPull = Math.random() * 1 - 0.5;
//       this.yPull = -1;
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mTarg,_alpha:100,ease:"easeInQuad",seconds:0.5});
//       this.mTarg.onEnterFrame = mx.utils.Delegate.create(this,this.updateMove);
//       clearInterval(this.intDelay);
//       this.intDelay = setInterval(this,"addPuke",50);
//       clearInterval(this.intCanvas);
//       this.intCanvas = setInterval(this,"updateCanvas",500);
//    }
//    function updateMove()
//    {
//       if(Key.isDown(39))
//       {
//          this.xInc = Math.min(this.xInc += 1.5,puker.SubGame.MAXSPEED);
//       }
//       else if(Key.isDown(37))
//       {
//          this.xInc = Math.max(this.xInc -= 1.5,- puker.SubGame.MAXSPEED);
//       }
//       else
//       {
//          this.xInc *= 0.9;
//       }
//       if(Key.isDown(40))
//       {
//          this.yInc = Math.min(this.yInc += 2,puker.SubGame.MAXSPEED);
//       }
//       else if(Key.isDown(38))
//       {
//          this.yInc = Math.max(this.yInc -= 2,- puker.SubGame.MAXSPEED);
//       }
//       else
//       {
//          this.yInc *= 0.9;
//       }
//       this.mTarg.mc._x = Math.random() * 8 - 4;
//       this.mTarg.mc._y = Math.random() * 8 - 4;
//       this.xInc += this.xPull;
//       this.yInc += this.yPull;
//       if(++this.cnt > puker.SubGame.PERCENT_TARG + this._app.gameLevel * 5)
//       {
//          this.xPull = Math.random() * 1 - 0.5;
//          this.yPull = Math.random() * 1 - 0.5;
//          this.cnt = Math.random() * 30;
//          this._app.soundControl.playSound("_sndRetch0" + Math.ceil(Math.random() * 5),Math.random() * 10 + 10);
//       }
//       var _loc2_ = this.mSprayHolder.mPukeLine0;
//       _loc2_.scalePrev = _loc2_._yscale;
//       _loc2_.rotPrev2 = _loc2_.rotPrev1;
//       _loc2_.rotPrev1 = _loc2_._rotation;
//       _loc2_._rotation = Math.atan2(this.mTarg._x - 400,- (this.mTarg._y - 400)) / puker.SubGame.RADIAN;
//       _loc2_._yscale = Math.sqrt((this.mTarg._x - 400) * (this.mTarg._x - 400) + (- (this.mTarg._y - 380)) * (- (this.mTarg._y - 380))) * 0.32;
//       var _loc3_ = 1;
//       while(_loc3_ < puker.SubGame.PUKETOT)
//       {
//          _loc2_ = this.mSprayHolder["mPukeLine" + _loc3_];
//          _loc2_.scalePrev = _loc2_._yscale;
//          _loc2_.rotPrev2 = _loc2_.rotPrev1;
//          _loc2_.rotPrev1 = _loc2_._rotation;
//          _loc2_._rotation = this.mSprayHolder["mPukeLine" + (_loc3_ - 1)].rotPrev2;
//          _loc2_._yscale = this.mSprayHolder["mPukeLine" + (_loc3_ - 1)].scalePrev;
//          _loc3_ = _loc3_ + 1;
//       }
//       this.mTarg._x += this.xInc;
//       this.mTarg._y += this.yInc;
//       if(this.mTarg._x > 800)
//       {
//          this.mTarg._x = 800;
//       }
//       else if(this.mTarg._x < 0)
//       {
//          this.mTarg._x = 0;
//       }
//       if(this.mTarg._y > 300)
//       {
//          this.mTarg._y = 300;
//       }
//       else if(this.mTarg._y < 0)
//       {
//          this.mTarg._y = 0;
//       }
//    }
//    function updateCanvas()
//    {
//       this.bmpHolder.draw(this.mSplatterHolder);
//       this.mSplatterHolder.removeMovieClip();
//       this.mSplatterHolder = this.createEmptyMovieClip("mSplatterHolder",this.getNextHighestDepth());
//       this.mSplatterHolder.setMask(this.mMask);
//    }
//    function addPuke()
//    {
//       this.mBk._alpha = Math.random() * 75;
//       this.mPukometer.mBaseMask._y = this.mPukometer.mUpperMask._y -= 2;
//       this.allPercent = Math.round(100 - (this.mPukometer.mBaseMask._y - 21) / 330 * 100);
//       if(this.allPercent >= 100)
//       {
//          this.endGame();
//          return undefined;
//       }
//       var _loc2_ = this.mSplatterHolder.attachMovie("_mPuke","mPuke",this.mSplatterHolder.getNextHighestDepth());
//       var _loc3_ = this.mSprayHolder["mPukeLine" + (puker.SubGame.PUKETOT - 1)];
//       _loc2_._x = Math.random() * 50 + 375 + _loc3_._yscale * 3.2 * Math.cos(puker.SubGame.RADIAN * (_loc3_._rotation - 90));
//       _loc2_._y = Math.random() * 50 + 375 + _loc3_._yscale * 3.2 * Math.sin(puker.SubGame.RADIAN * (_loc3_._rotation - 90));
//       _loc2_._xscale = _loc2_._yscale = Math.random() * 15 + 15;
//       if(this.mRecepArea.hitTest(_loc2_._x,_loc2_._y,true))
//       {
//          _loc2_._rotation = Math.random() * 90 - 45 + Math.atan2(- (_loc2_._x - this.mRecepArea._x),_loc2_._y - this.mRecepArea._y) / puker.SubGame.RADIAN;
//          this.mFiller._alpha += 2;
//          this.mRecepArea.gotoAndStop(1);
//          this.inPercent = this.allPercent - this.outPercent;
//          if(this.inPercent >= puker.SubGame.PERCENT_TARG + this._app.gameLevel * 5)
//          {
//             this.mTarg.gotoAndStop(2);
//          }
//          if(this.inPercent > 9)
//          {
//             this.mTarg.td.text = this.inPercent + "%";
//          }
//          else
//          {
//             this.mTarg.td.text = "0" + this.inPercent + "%";
//          }
//       }
//       else
//       {
//          _loc2_._rotation = Math.random() * 360;
//          var _loc4_ = this.mSplatterHolder.attachMovie("_mPuddle","mPuddle",this.mSplatterHolder.getNextHighestDepth(),{_rotation:Math.random() * 360,_x:_loc2_._x,_y:_loc2_._y,_alpha:Math.random() * 20 + 15});
//          _loc4_.gotoAndStop(Math.ceil(Math.random() * _loc4_._totalframes));
//          this.outPercent = this.allPercent - this.inPercent;
//          if(this.inPercent < puker.SubGame.PERCENT_TARG + this._app.gameLevel * 5)
//          {
//             this.mRecepArea.play();
//          }
//       }
//       _loc2_._alpha = Math.random() * 50 + 25;
//    }
//    function endGame()
//    {
//       clearInterval(this.intDelay);
//       clearInterval(this.intCanvas);
//       delete this.mTarg.onEnterFrame;
//       this._quality = "HIGH";
//       this._app.removePause();
//       this._app.soundControl.fadeTo(this.mSndSplatter,0,0.5);
//       this._app.soundControl.fadeTo(this._app.mSndDrone,0,0.5);
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mPukometer,_x:-75,ease:"easeInQuad",seconds:0.5});
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mTarg.mc,_alpha:0,ease:"easeInQuad",seconds:0.5});
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:this.mTarg,scope:this,scale:150,_x:this.mFiller._x,_y:this.mFiller._y + 50,ease:"easeOutBack",seconds:2,func:"showResult"});
//       var _loc2_ = 0;
//       while(_loc2_ < puker.SubGame.PUKETOT)
//       {
//          var _loc3_ = this.mSprayHolder["mPukeLine" + _loc2_];
//          com.mosesSupposes.fuse.ZigoEngine.doTween({target:_loc3_,_alpha:0,ease:"easeInQuad",seconds:(_loc2_ + 1) * 0.1});
//          _loc2_ = _loc2_ + 1;
//       }
//       this.allPercent = 100;
//       this.mRecepArea.gotoAndStop(1);
//    }
//    function showResult()
//    {
//       var _loc2_ = undefined;
//       this._app.soundControl.playSound("_sndSpit",100);
//       this._app.pointage += this.inPercent * 2;
//       if(this.inPercent >= puker.SubGame.PERCENT_TARG + this._app.gameLevel * 5)
//       {
//          _loc2_ = this.attachMovie("_mResultGood","mResult",this.getNextHighestDepth());
//          if(this._app.gameLevel == 3)
//          {
//             this._app.mInfoScreens.setKeyListener("endGameGood");
//          }
//          else
//          {
//             this._app.mInfoScreens.setKeyListener("intro" + (this._app.gameLevel + 1));
//          }
//       }
//       else
//       {
//          _loc2_ = this.attachMovie("_mResultBad","mResult",this.getNextHighestDepth());
//          this._app.mInfoScreens.setKeyListener("endGameBad");
//       }
//       _loc2_.gotoAndStop(Math.ceil(Math.random() * _loc2_._totalframes));
//       com.mosesSupposes.fuse.ZigoEngine.doTween({target:_loc2_,start_y:200,_y:0,ease:"easeOutBack",seconds:0.5});
//    }
//    function pauseHit(pauseState)
//    {
//       if(pauseState)
//       {
//          delete this.mTarg.onEnterFrame;
//          clearInterval(this.intDelay);
//          clearInterval(this.intCanvas);
//       }
//       else
//       {
//          this.mTarg.onEnterFrame = mx.utils.Delegate.create(this,this.updateMove);
//          clearInterval(this.intDelay);
//          this.intDelay = setInterval(this,"addPuke",50);
//          clearInterval(this.intCanvas);
//          this.intCanvas = setInterval(this,"updateCanvas",500);
//       }
//    }
//    function destroy()
//    {
//       this.bmpHolder.dispose();
//    }
// }
