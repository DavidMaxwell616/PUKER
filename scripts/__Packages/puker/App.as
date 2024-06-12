class puker.App
{
   var lRoot;
   var soundControl;
   var mSndIntroMusic;
   var mSndDrone;
   var mInfoScreens;
   var keyListener;
   var mSndAmbient;
   var mLevelHolder;
   var instScroller;
   var mHud;
   var mDan;
   var mSubGame;
   var curSpeed = 0;
   var gameLevel = 1;
   var subLevel = 1;
   var pukeLevel = 0;
   var distLevel = 0;
   var runLevelOver = false;
   var pauseState = false;
   var pointage = 0;
   function App(_lRoot)
   {
      com.mosesSupposes.fuse.ZigoEngine.simpleSetup(com.mosesSupposes.fuse.Shortcuts,com.mosesSupposes.fuse.PennerEasing,com.mosesSupposes.fuse.FuseItem,com.mosesSupposes.fuse.FuseFMP);
      this.lRoot = _lRoot;
      this.soundControl = new com.happylander.utils.SoundControl(this.lRoot);
      this.init();
   }
   function init()
   {
      this.mSndIntroMusic = this.soundControl.playSoundFade("_sndIntroMusic",0.5,100,true);
      this.mSndDrone = this.soundControl.playSound("_sndDrone",0,true);
      this.mInfoScreens = this.lRoot.attachMovie("_mInfoScreens","mInfoScreens",200,{_app:this});
      var lc = this;
      this.keyListener = new Object();
      this.keyListener.onKeyUp = function()
      {
         if(Key.getCode() == 80)
         {
            if(this.pauseState)
            {
               this.pauseState = false;
            }
            else
            {
               this.pauseState = true;
            }
            lc.instScroller.pauseHit(this.pauseState);
            lc.mDan.pauseHit(this.pauseState);
            lc.mHud.pauseHit(this.pauseState);
            lc.mSubGame.pauseHit(this.pauseState);
         }
         else if(Key.getCode() == 27 || Key.getCode() == 81)
         {
            trace("quit");
         }
      };
   }
   function addPause()
   {
      Key.addListener(this.keyListener);
   }
   function removePause()
   {
      Key.removeListener(this.keyListener);
   }
   function initGame()
   {
      _quality = "LOW";
      this.curSpeed = 0;
      this.pukeLevel = 0;
      this.distLevel = 0;
      this.runLevelOver = false;
      this.pointage = 0;
      this.mSndAmbient = this.soundControl.playSoundFade("_sndAmbient0" + this.gameLevel,0.5,50,true);
      this.mLevelHolder = this.lRoot.createEmptyMovieClip("mLevelHolder",100);
      this.instScroller = new puker.SkewScroller(this.mLevelHolder.createEmptyMovieClip("mInstScroller",this.mLevelHolder.getNextHighestDepth()),this);
      this.mHud = this.mLevelHolder.attachMovie("_mHud","mHud",this.mLevelHolder.getNextHighestDepth(),{_app:this});
      this.mDan = this.instScroller.lRoot.attachMovie("_mDan","mDan",this.instScroller.lRoot.getNextHighestDepth(),{_app:this});
      this.instScroller.init();
   }
   function initSubGame()
   {
      _quality = "LOW";
      this.soundControl.fadeTo(this.mSndAmbient,0,0.5);
      this.instScroller.destroy();
      this.mHud.destroy();
      this.mSubGame = this.lRoot.attachMovie("_mSubGame_" + this.gameLevel,"mSubGame",this.lRoot.getNextHighestDepth(),{_app:this});
      Key.addListener(this.keyListener);
   }
   function addPickup()
   {
      this.instScroller.addPickup();
   }
   function distBarFull()
   {
      this.pointage += 300 + (160 - this.pukeLevel) * 5;
      this.removePause();
      this.runLevelOver = true;
      this.mDan.walkOffScreen();
      this.instScroller.fadeOutItems();
      this.subLevel = 3;
   }
   function pukeBarFull(_subLevel)
   {
      this.pointage += _subLevel * 100;
      this.removePause();
      this.runLevelOver = true;
      this.subLevel = _subLevel;
      this.mDan.startRetching();
      this.instScroller.goQueazy();
      this.instScroller.fadeOutItems();
   }
   function destroySubGame()
   {
      this.mSubGame.destroy();
      this.mSubGame.removeMovieClip();
   }
}
