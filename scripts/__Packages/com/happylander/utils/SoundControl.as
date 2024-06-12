class com.happylander.utils.SoundControl
{
   var _lRoot;
   function SoundControl(lRoot)
   {
      com.mosesSupposes.fuse.ZigoEngine.simpleSetup(com.mosesSupposes.fuse.Shortcuts,com.mosesSupposes.fuse.PennerEasing,com.mosesSupposes.fuse.FuseItem);
      this._lRoot = lRoot;
   }
   function playSound(sndName, vol, loop, pan)
   {
      var _loc3_ = this._lRoot[sndName];
      if(_loc3_ == undefined)
      {
         _loc3_ = this._lRoot.createEmptyMovieClip(sndName,this._lRoot.getNextHighestDepth());
      }
      var _loc2_ = new Sound(_loc3_);
      _loc2_.attachSound(sndName);
      _loc3_.snd = _loc2_;
      _loc2_.setVolume(vol);
      _loc2_.setPan(pan);
      if(loop)
      {
         _loc2_.start(0,999999);
      }
      else
      {
         _loc2_.start(0);
      }
      return _loc3_;
   }
   function playSoundFade(sndName, secs, vol, loop, pan)
   {
      var _loc2_ = this.playSound(sndName,0,loop);
      _loc2_.soundFade = _loc2_.snd.getVolume();
      _loc2_.watch("soundFade",this.soundFadeWatcher,_loc2_);
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:_loc2_,scope:this,soundFade:vol,ease:"easeInQuad",seconds:secs,func:"volReached",args:_loc2_});
      return _loc2_;
   }
   function fadeTo(mc, vol, secs)
   {
      mc.soundFade = mc.snd.getVolume();
      mc.watch("soundFade",this.soundFadeWatcher,mc);
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:mc,scope:this,soundFade:vol,ease:"easeInQuad",seconds:secs,func:"volReached",args:mc});
   }
   function panTo(mc, pan, secs)
   {
      mc.soundPan = mc.snd.getPan();
      mc.watch("soundPan",this.soundPanWatcher,mc);
      com.mosesSupposes.fuse.ZigoEngine.doTween({target:mc,scope:this,soundPan:pan,ease:"linear",seconds:secs,func:"panReached",args:mc});
   }
   function volReached(mc)
   {
      mc.unwatch("soundFade");
   }
   function panReached(mc)
   {
      mc.unwatch("soundPan");
   }
   function soundFadeWatcher(prop, oldVal, newVal, target_mc)
   {
      target_mc.snd.setVolume(newVal);
      return newVal;
   }
   function soundPanWatcher(prop, oldVal, newVal, target_mc)
   {
      target_mc.snd.setPan(newVal);
      return newVal;
   }
}
