var pointage = 0;
var app = new puker.App(this.createEmptyMovieClip("mHolder",this.getNextHighestDepth()));
var mMute = this.attachMovie("_mMute","mMute",this.getNextHighestDepth(),{_x:800,_y:380});
this.mute = new Sound();
this.mute.setVolume(100);
mMute.gotoAndStop(1);
mMute.onPress = function()
{
   if(this._parent.mute.getVolume() == 100)
   {
      this._parent.mute.setVolume(0);
      this.gotoAndStop(2);
   }
   else
   {
      this._parent.mute.setVolume(100);
      this.gotoAndStop(1);
   }
};
stop();
