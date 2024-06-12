function updateLoad()
{
   var _loc2_ = int(_root.getBytesLoaded() / _root.getBytesTotal() * 100);
   mLoader.mBaseMask._y = _loc2_ * -3.5 + 377;
   mLoader.mUpperMask._y = mLoader.mBaseMask._y - 10;
   if(_loc2_ == 100)
   {
      clearInterval(intLoad);
      _root.gotoAndStop(3);
   }
}
stop();
mLoader.mPukeWord._visible = false;
mLoader.mBaseMask._y = mLoader.mUpperMask._y = 377;
intLoad = setInterval(this,"updateLoad",100);
