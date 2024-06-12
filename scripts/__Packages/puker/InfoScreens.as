class puker.InfoScreens extends MovieClip
{
   var keyListener;
   var intDelay;
   var mPlayBut;
   var mInstructBut;
   var mHighscoreBut;
   var _app;
   var mBackBut;
   var td;
   var mEnterBut;
   var mLinkBut;
   var mFrankBut;
   function InfoScreens()
   {
      super();
      this.init();
   }
   function init()
   {
      this.keyListener = new Object();
      this.changeScreen("open");
   }
   function changeScreen(nextScreen)
   {
      Key.removeListener(this.keyListener);
      clearInterval(this.intDelay);
      this.gotoAndStop(nextScreen);
      trace("dressing screen: " + nextScreen);
      switch(nextScreen)
      {
         case "open":
            this._quality = "HIGH";
            this.mPlayBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("intro1");
            }
            );
            this.mPlayBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0x899427",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mPlayBut.onRollOver = _loc0_;
            this.mPlayBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mPlayBut.onRollOut = _loc0_;
            this.mInstructBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("instruct");
            }
            );
            this.mInstructBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xB1B00A",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mInstructBut.onRollOver = _loc0_;
            this.mInstructBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mInstructBut.onRollOut = _loc0_;
            this.mHighscoreBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("highscores");
            }
            );
            this.mHighscoreBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mHighscoreBut.onRollOver = _loc0_;
            this.mHighscoreBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mHighscoreBut.onRollOut = _loc0_;
            this.setKeyListener("intro1");
            break;
         case "highscores":
            this._app.gameLevel = 1;
            this.setKeyListener("playLevel");
            this.mBackBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("open");
            }
            );
            this.mBackBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOver = _loc0_;
            this.mBackBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOut = _loc0_;
            break;
         case "instruct":
            this._app.gameLevel = 1;
            this.setKeyListener("playLevel");
            this.mBackBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("open");
            }
            );
            this.mBackBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOver = _loc0_;
            this.mBackBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOut = _loc0_;
            break;
         case "intro1":
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,start_alpha:0,_alpha:100,ease:"easeOutQuad",seconds:0.5});
            this._app.gameLevel = 1;
            this.setKeyListener("playLevel");
            this.intDelay = setInterval(this,"changeScreen",2500,"playLevel");
            break;
         case "intro2":
            this._quality = "HIGH";
            this._app.destroySubGame();
            this._app.soundControl.fadeTo(this._app.mSndIntroMusic,100,0.5);
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,start_alpha:0,_alpha:100,ease:"easeOutQuad",seconds:0.5});
            this._app.gameLevel = 2;
            this.setKeyListener("playLevel");
            this.intDelay = setInterval(this,"changeScreen",2500,"playLevel");
            break;
         case "intro3":
            this._quality = "HIGH";
            this._app.destroySubGame();
            this._app.soundControl.fadeTo(this._app.mSndIntroMusic,100,0.5);
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,start_alpha:0,_alpha:100,ease:"easeOutQuad",seconds:0.5});
            this._app.gameLevel = 3;
            this.setKeyListener("playLevel");
            this.intDelay = setInterval(this,"changeScreen",2500,"playLevel");
            break;
         case "playLevel":
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,scope:this,_alpha:0,ease:"easeInQuad",seconds:0.5,func:"changeScreen",args:"hideMe"});
            this._app.soundControl.fadeTo(this._app.mSndIntroMusic,0,0.5);
            this._app.initGame();
            break;
         case "endGameGood":
         case "endGameBad":
            this._quality = "HIGH";
            this._app.soundControl.fadeTo(this._app.mSndIntroMusic,100,0.5);
            this._app.destroySubGame();
            com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,start_alpha:0,_alpha:100,ease:"easeOutQuad",seconds:0.5});
            this._app.pointage = Math.round(this._app.pointage * 10);
            this.td.text = String(this._app.pointage);
            this.mEnterBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("enterHighscore");
            }
            );
            this.mEnterBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0x899427",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mEnterBut.onRollOver = _loc0_;
            this.mEnterBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mEnterBut.onRollOut = _loc0_;
            this.mLinkBut.onRelease = _loc0_ = function()
            {
               this.getURL("http://talktofrank.com/drugs.aspx?id=172","_blank");
            };
            this.mFrankBut.onRelease = _loc0_;
            this.mFrankBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xB1B00A",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mFrankBut.onRollOver = _loc0_;
            this.mFrankBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mFrankBut.onRollOut = _loc0_;
            this.mHighscoreBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("enterHighscore");
            }
            );
            this.mHighscoreBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mHighscoreBut.onRollOver = _loc0_;
            this.mHighscoreBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mHighscoreBut.onRollOut = _loc0_;
            this.mBackBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("open");
            }
            );
            this.mBackBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOver = _loc0_;
            this.mBackBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOut = _loc0_;
            this.setKeyListener("enterHighscore");
            _root.pointage = this._app.pointage;
            break;
         case "enterHighscore":
            this.mBackBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("open");
            }
            );
            this.mBackBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0xBB8300",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOver = _loc0_;
            this.mBackBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mBackBut.onRollOut = _loc0_;
            this.mPlayBut.onRelease = mx.utils.Delegate.create(this,function()
            {
               this.playButSnd();
               this.changeScreen("intro1");
            }
            );
            this.mPlayBut.onDragOver = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_tint:"0x899427",_tintPercent:30,ease:"easeOutQuad",seconds:0.3});
            };
            this.mPlayBut.onRollOver = _loc0_;
            this.mPlayBut.onDragOut = _loc0_ = function()
            {
               com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,_brightness:0,ease:"easeOutQuad",seconds:0.3});
            };
            this.mPlayBut.onRollOut = _loc0_;
            break;
         case "hideMe":
      }
   }
   function playButSnd()
   {
      this._app.soundControl.playSound("_sndRetch0" + Math.ceil(Math.random() * 5),50);
   }
   function setKeyListener(nextScreen)
   {
      this.keyListener.onKeyUp = mx.utils.Delegate.create(this,function()
      {
         this.changeScreen(nextScreen);
      }
      );
      Key.addListener(this.keyListener);
   }
}
