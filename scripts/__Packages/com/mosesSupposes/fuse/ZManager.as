class com.mosesSupposes.fuse.ZManager
{
   var tweens;
   var now;
   var numTweens = 0;
   function ZManager()
   {
      this.tweens = {};
      this.numTweens = 0;
   }
   function addTween(obj, props, endvals, seconds, ease, delay, callback)
   {
      var _loc20_ = callback.skipLevel != undefined ? callback.skipLevel : 0;
      var _loc38_ = callback.cycles != undefined ? callback.cycles : 1;
      var _loc25_ = callback.extra1;
      var _loc24_ = callback.extra2;
      var _loc19_ = [];
      var _loc15_ = _global.com.mosesSupposes.fuse.FuseFMP;
      var _loc37_ = String("|" + _loc15_.getAllShortcuts().join("|") + "|");
      var _loc36_ = com.mosesSupposes.fuse.FuseKitCommon._cts();
      var _loc21_ = "";
      var _loc23_ = "";
      var _loc7_ = this.tweens[String(obj.__zigoID__)];
      if(_loc7_ != undefined && com.mosesSupposes.fuse.ZigoEngine.AUTOSTOP == true)
      {
         if(obj._listeners.length > 0)
         {
            for(var _loc34_ in _loc7_.props)
            {
               _loc19_.unshift(_loc34_);
            }
         }
         _loc7_.numProps = 0;
         this.cleanUp(true);
      }
      for(var _loc41_ in props)
      {
         var _loc6_ = props[_loc41_];
         var _loc13_ = _loc36_.indexOf("|" + _loc6_ + "|") > -1;
         var _loc16_ = _loc7_.colorProp;
         if(_loc7_ != undefined)
         {
            if(_loc13_ == true && _loc16_ != undefined)
            {
               _loc19_.unshift(_loc16_);
               delete _loc7_.props[_loc16_];
               delete _loc7_.colorProp;
               _loc7_.numProps = _loc7_.numProps - 1;
            }
            else if(_loc7_.props[_loc6_] != undefined)
            {
               _loc19_.unshift(_loc6_);
               delete _loc7_[_loc6_];
               _loc7_.numProps = _loc7_.numProps - 1;
            }
         }
         var _loc3_ = {c:-1,fmp:-1};
         var _loc4_ = endvals[_loc41_];
         var _loc11_ = _loc20_ == 0 && seconds + delay == 0 || _loc20_ > 0 && seconds == 0;
         var _loc10_ = false;
         var _loc14_ = _loc15_ != undefined && _loc37_.indexOf("|" + _loc6_ + "|") > -1;
         if(_loc14_ == true)
         {
            _loc3_.fmp = _loc15_;
            _loc3_.ps = _loc15_.getFilterProp(obj,_loc6_,true);
            _loc3_.special = true;
         }
         if(_loc13_ == true || _loc14_ == true && _loc6_.indexOf("lor") > -1 && _loc6_.charAt(2) != "l" && _loc11_ == false)
         {
            if(_loc13_ == true)
            {
               _loc3_.c = new Color(obj);
               _loc3_.ps = _loc3_.c.getTransform();
               if(_loc6_ != "_colorTransform")
               {
                  var _loc17_ = !(_loc6_ == "_tint" || _loc6_ == "_tintPercent" || _loc6_ == "_colorReset") ? _loc6_.slice(1) : "tint";
                  var _loc8_ = null;
                  var _loc12_ = null;
                  if(_loc17_ == "tint")
                  {
                     if(typeof _loc4_ == "object")
                     {
                        _loc12_ = _loc4_.tint;
                        _loc8_ = _global.isNaN(_loc4_.percent) != true ? _loc4_.percent : 100;
                     }
                     else if(_loc6_ == "_tintPercent" || _loc6_ == "_colorReset")
                     {
                        var _loc18_ = com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(obj).tintPercent;
                        _loc8_ = typeof _loc4_ != "string" ? Number(_loc4_) : (_loc18_ || 0) + Number(_loc4_);
                        _loc8_ = Math.max(0,Math.min(_loc8_,100));
                        if(_loc6_ == "_colorReset")
                        {
                           _loc8_ = Math.min(_loc18_,100 - _loc8_);
                        }
                        _loc12_ = com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(obj).tint || 0;
                     }
                     else
                     {
                        _loc12_ = _loc4_;
                        _loc8_ = 100;
                     }
                  }
                  else
                  {
                     _loc8_ = typeof _loc4_ != "string" ? _loc4_ : (com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(obj)[_loc17_] || 0) + Number(_loc4_);
                  }
                  _loc4_ = com.mosesSupposes.fuse.ZigoEngine.getColorTransObj(_loc17_,_loc8_,_loc12_);
               }
            }
            else
            {
               _loc3_.c = 1;
               _loc3_.ps = com.mosesSupposes.fuse.ZigoEngine.getColorTransObj("tint",100,_loc3_.ps);
               _loc4_ = com.mosesSupposes.fuse.ZigoEngine.getColorTransObj("tint",100,_loc4_);
            }
            if(_loc11_ == true)
            {
               _loc3_.c.setTransform(_loc4_);
            }
            else
            {
               _loc3_.ch = {};
               for(_loc34_ in _loc4_)
               {
                  if((_loc3_.c === 1 && _loc34_.charAt(1) == "b" || _loc4_[_loc34_] != _loc3_.ps[_loc34_]) && _loc4_[_loc34_] != null && _global.isNaN(Number(_loc4_[_loc34_])) == false)
                  {
                     _loc3_.ch[_loc34_] = typeof _loc4_[_loc34_] != "string" ? _loc4_[_loc34_] - _loc3_.ps[_loc34_] : Number(_loc4_[_loc34_]);
                     if(_global.isNaN(_loc3_.ch[_loc34_]) == true)
                     {
                        _loc3_.ch[_loc34_] = 0;
                     }
                     else if(_loc3_.ch[_loc34_] != 0)
                     {
                        _loc10_ = true;
                     }
                  }
               }
            }
         }
         else if(_loc6_ == "_bezier_")
         {
            this.removeTween(obj,"_x,_y",true);
            if(_loc11_ == true)
            {
               if(_loc4_.x != null && _global.isNaN(Number(_loc4_.x)) == false)
               {
                  obj._x = typeof _loc4_.x != "string" ? _loc4_.x : obj._x + Number(_loc4_.x);
               }
               if(_loc4_.y != null && _global.isNaN(Number(_loc4_.y)) == false)
               {
                  obj._y = typeof _loc4_.y != "string" ? _loc4_.y : obj._y + Number(_loc4_.y);
               }
            }
            else
            {
               _loc3_.special = true;
               _loc3_.ps = 0;
               _loc3_.ch = 1;
               _loc3_.bz = {sx:obj._x,sy:obj._y};
               if(_loc4_.x == null || _global.isNaN(Number(_loc4_.x)))
               {
                  _loc4_.x = _loc3_.bz.sx;
               }
               if(_loc4_.y == null || _global.isNaN(Number(_loc4_.y)))
               {
                  _loc4_.y = _loc3_.bz.sy;
               }
               _loc3_.bz.chx = typeof _loc4_.x != "string" ? _loc4_.x - _loc3_.bz.sx : Number(_loc4_.x);
               if(_global.isNaN(_loc3_.bz.chx) == true)
               {
                  _loc3_.bx.chx = 0;
               }
               _loc3_.bz.chy = typeof _loc4_.y != "string" ? _loc4_.y - _loc3_.bz.sy : Number(_loc4_.y);
               if(_global.isNaN(_loc3_.bz.chy) == true)
               {
                  _loc3_.bx.chy = 0;
               }
               if(_loc4_.controlX == null || _global.isNaN(Number(_loc4_.controlX)))
               {
                  _loc3_.bz.ctrlx = _loc3_.bz.sx + _loc3_.bz.chx / 2;
               }
               else
               {
                  _loc3_.bz.ctrlx = typeof _loc4_.controlX != "string" ? _loc4_.controlX : _loc3_.bz.sx + Number(_loc4_.controlX);
               }
               if(_loc4_.controlY == null || _global.isNaN(Number(_loc4_.controlY)))
               {
                  _loc3_.bz.ctrly = _loc3_.bz.sy + _loc3_.bz.chy / 2;
               }
               else
               {
                  _loc3_.bz.ctrly = typeof _loc4_.controlY != "string" ? _loc4_.controlY : _loc3_.bz.sy + Number(_loc4_.controlY);
               }
               _loc3_.bz.ctrlx -= _loc3_.bz.sx;
               _loc3_.bz.ctrly -= _loc3_.bz.sy;
               _loc10_ = _loc3_.bz.chx + _loc3_.bz.chy != 0;
            }
         }
         else
         {
            if(_loc6_ == "_x" || _loc6_ == "_y")
            {
               this.removeTween(obj,"_bezier_",true);
            }
            if(_loc6_ == "_frame" && typeof obj == "movieclip")
            {
               _loc3_.ps = obj._currentframe;
               _loc3_.special = true;
            }
            else if(_loc14_ == false)
            {
               _loc3_.ps = obj[_loc6_];
            }
            if(_loc11_ == true)
            {
               _loc4_ = typeof _loc4_ != "string" ? _loc4_ : _loc3_.ps + Number(_loc4_);
               if(_loc14_ == true)
               {
                  _loc15_.setFilterProp(obj,_loc6_,_loc4_);
               }
               else
               {
                  obj[_loc6_] = _loc4_;
               }
            }
            else
            {
               if(_loc4_ == null || _global.isNaN(Number(_loc4_)))
               {
                  _loc4_ = _loc3_.ps;
               }
               _loc3_.ch = typeof _loc4_ != "string" ? Number(_loc4_) - _loc3_.ps : Number(_loc4_);
               if(_global.isNaN(_loc3_.ch) == true)
               {
                  _loc3_.ch = 0;
               }
               _loc10_ = _loc3_.ch != 0;
            }
         }
         if(_loc20_ == 0 && (_loc10_ == true || _loc11_ == false) || _loc10_ == true && _loc11_ == false)
         {
            _loc3_.ts = this.now + delay * 1000;
            _loc3_.pt = -1;
            _loc3_.d = seconds * 1000;
            _loc3_.ef = ease;
            _loc3_.sf = false;
            _loc3_.cycles = _loc38_;
            if(_loc25_ != undefined)
            {
               _loc3_.e1 = _loc25_;
            }
            if(_loc24_ != undefined)
            {
               _loc3_.e2 = _loc24_;
            }
            if(callback.start != undefined)
            {
               _loc3_.scb = callback.start;
            }
            if(callback.upd != undefined)
            {
               _loc3_.ucb = callback.upd;
            }
            if(callback.end != undefined)
            {
               _loc3_.ecb = callback.end;
            }
            if(this.tweens[String(obj.__zigoID__)] == undefined)
            {
               var _loc0_ = null;
               _loc7_ = this.tweens[String(obj.__zigoID__)] = {numProps:0,locked:false,targ:obj,targID:String("\"" + (obj._name == undefined ? obj.toString() : obj._name) + "\""),targZID:obj.__zigoID__,props:{}};
               this.numTweens = this.numTweens + 1;
            }
            if(_loc13_ == true)
            {
               _loc7_.colorProp = _loc6_;
            }
            _loc7_.props[_loc6_] = _loc3_;
            _loc7_.numProps = _loc7_.numProps + 1;
            _loc21_ = _loc6_ + "," + _loc21_;
            _loc23_ = (typeof _loc4_ != "string" ? _loc4_ : "\"" + _loc4_ + "\"") + "," + _loc23_;
         }
         false;
      }
      if(_loc7_ == undefined || _loc7_.numProps <= 0)
      {
         this.cleanUp();
      }
      if(_loc19_.length > 0 && com.mosesSupposes.fuse.ZigoEngine._listeners.length > 0)
      {
         com.mosesSupposes.fuse.ZigoEngine.broadcastMessage("onTweenInterrupt",{target:obj,props:_loc19_,__zigoID__:obj.__zigoID__});
      }
      if(_loc21_ == "")
      {
         if(_loc20_ == 2)
         {
            if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL == 2)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("011",obj._name == undefined ? obj.toString() : obj._name,props.toString());
            }
         }
         else
         {
            var _loc42_ = obj._listeners.length > 0;
            if(_loc42_ == true)
            {
               obj.broadcastMessage("onTweenStart",{target:obj,props:props});
            }
            if(callback.start != undefined)
            {
               callback.start.f.apply(callback.start.s,callback.start.a);
            }
            if(_loc42_ == true)
            {
               obj.broadcastMessage("onTweenUpdate",{target:obj,props:props});
            }
            if(callback.upd != undefined)
            {
               callback.upd.f.apply(callback.upd.s,callback.upd.a);
            }
            if(_loc42_ == true)
            {
               obj.broadcastMessage("onTweenEnd",{target:obj,props:props});
            }
            if(callback.end != undefined)
            {
               callback.end.f.apply(callback.end.s,callback.end.a);
            }
         }
         this.cleanUp();
      }
      if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL == 2)
      {
         if(_loc21_ == "")
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("012",obj._name == undefined ? obj.toString() : obj._name,props.toString(),endvals.toString());
         }
         else
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("013",obj._name == undefined ? obj.toString() : obj._name,_loc21_.slice(0,-1),_loc23_.slice(0,-1));
         }
      }
      return _loc21_ != "" ? _loc21_.slice(0,-1) : null;
   }
   function removeTween(targs, props, noInit)
   {
      var _loc4_ = {};
      var _loc11_ = this.paramsObj(targs,props);
      if(_loc11_.none == true)
      {
         return undefined;
      }
      var _loc15_ = _loc11_.all;
      var _loc16_ = _loc11_.allprops;
      var _loc9_ = _loc15_ != true ? Object(_loc11_.tg) : this.tweens;
      var _loc8_ = false;
      for(var _loc18_ in _loc9_)
      {
         var _loc3_ = _loc15_ != true ? String(_loc9_[_loc18_].__zigoID__) : _loc18_;
         var _loc2_ = this.tweens[_loc3_];
         var _loc6_ = _loc16_ != true ? _loc11_.props : _loc2_.props;
         for(var _loc13_ in _loc6_)
         {
            var _loc5_ = _loc13_ == com.mosesSupposes.fuse.FuseKitCommon.ALLCOLOR && _loc2_.colorProp != undefined;
            if(_loc2_.props[_loc13_] != undefined || _loc5_ == true)
            {
               if(_loc4_[_loc3_] == null)
               {
                  _loc4_[_loc3_] = [];
               }
               _loc4_[_loc3_].unshift(_loc13_);
               if(_loc13_ == _loc2_.colorProp || _loc5_ == true)
               {
                  delete _loc2_.props[_loc2_.colorProp];
                  delete _loc2_.colorProp;
               }
               else
               {
                  delete _loc2_.props[_loc13_];
               }
               _loc2_.numProps = _loc2_.numProps - 1;
               if(_loc2_.numProps <= 0)
               {
                  _loc8_ = true;
                  break;
               }
            }
         }
      }
      if(com.mosesSupposes.fuse.ZigoEngine._listeners.length > 0)
      {
         for(var _loc17_ in _loc4_)
         {
            var _loc7_ = this.tweens[_loc17_].targ;
            com.mosesSupposes.fuse.ZigoEngine.broadcastMessage("onTweenInterrupt",{target:(typeof _loc7_.addProperty != "function" ? "[MISSING(\"" + this.tweens[_loc17_].targID + "\")]" : _loc7_),props:_loc4_[_loc17_],__zigoID__:this.tweens[_loc17_].targZID});
         }
      }
      if(_loc8_ == true)
      {
         this.cleanUp(noInit);
      }
   }
   function alterTweens(type, targs, props, pauseFlag, suppressStartEvents)
   {
      if(type == "lock")
      {
         this.tweens[String(targs.__zigoID__)].locked = Boolean(props == true);
         return undefined;
      }
      var _loc11_ = this.paramsObj(targs,props);
      if(_loc11_.none == true)
      {
         return undefined;
      }
      var _loc13_ = _loc11_.all;
      var _loc14_ = _loc11_.allprops;
      var _loc8_ = _loc13_ != true ? Object(_loc11_.tg) : this.tweens;
      var _loc7_ = 0;
      for(var _loc15_ in _loc8_)
      {
         var _loc6_ = _loc13_ != true ? String(_loc8_[_loc15_].__zigoID__) : _loc15_;
         var _loc5_ = this.tweens[_loc6_];
         var _loc4_ = _loc14_ != true ? _loc11_.props : _loc5_.props;
         if(_loc4_.ALLCOLOR == true)
         {
            _loc4_[_loc5_.colorProp] = true;
            delete _loc4_.ALLCOLOR;
         }
         for(var _loc9_ in _loc4_)
         {
            _loc7_ = _loc7_ + 1;
            var _loc2_ = _loc5_.props[_loc9_];
            if(type == "rewind")
            {
               if(pauseFlag == true)
               {
                  _loc2_.pt = this.now;
               }
               _loc2_.ts = this.now;
               if(suppressStartEvents != true)
               {
                  _loc2_.sf = false;
                  if(_loc2_.scb != undefined)
                  {
                     _loc2_.scb.fired = false;
                  }
               }
            }
            else if(type == "ff")
            {
               _loc2_.pt = -1;
               _loc2_.ts = this.now - _loc2_.d;
            }
            else if(type == "pause")
            {
               if(_loc2_.pt == -1)
               {
                  _loc2_.pt = this.now;
               }
            }
            else if(type == "unpause")
            {
               if(_loc2_.pt != -1)
               {
                  _loc2_.ts = this.now - (_loc2_.pt - _loc2_.ts);
                  _loc2_.pt = -1;
               }
            }
         }
      }
      if(type == "ff" && _loc7_ > 0)
      {
         this.update();
      }
      else if(type == "rewind" && _loc7_ > 0)
      {
         this.update(true);
      }
   }
   function getStatus(type, targ, param)
   {
      if(targ == null)
      {
         return null;
      }
      var _loc8_ = String(targ).toUpperCase() == com.mosesSupposes.fuse.FuseKitCommon.ALL;
      var _loc4_ = this.tweens[String(targ.__zigoID__)];
      switch(type)
      {
         case "paused":
            var _loc2_ = _loc4_.props;
            if(param != null)
            {
               if(_loc2_[String(param)] == undefined)
               {
                  return false;
               }
               return Boolean(_loc2_[String(param)].pt != -1);
            }
            for(var _loc6_ in _loc2_)
            {
               if(_loc2_[_loc6_].pt != -1)
               {
                  return true;
               }
            }
            return false;
            break;
         case "active":
            if(param == null)
            {
               return Boolean(_loc4_ != undefined);
            }
            if(String(param).toUpperCase() == com.mosesSupposes.fuse.FuseKitCommon.ALLCOLOR)
            {
               return Boolean(_loc4_.colorProp != undefined);
            }
            return Boolean(_loc4_.props[String(param)] != undefined);
            break;
         case "count":
            if(!_loc8_)
            {
               return _loc4_.numProps;
            }
            var _loc3_ = 0;
            for(_loc6_ in this.tweens)
            {
               _loc3_ += this.tweens[_loc6_].numProps;
            }
            return _loc3_;
            break;
         case "locked":
            return _loc4_.locked;
         default:
      }
   }
   function update(force)
   {
      var _loc17_ = {};
      var _loc19_ = {};
      var _loc18_ = {};
      var _loc13_ = {};
      var _loc11_ = {};
      var _loc12_ = {};
      var _loc22_ = false;
      var _loc20_ = com.mosesSupposes.fuse.ZigoEngine.ROUND_RESULTS;
      for(var _loc29_ in this.tweens)
      {
         var _loc10_ = this.tweens[_loc29_];
         var _loc6_ = _loc10_.targ;
         var _loc28_ = _loc10_.props;
         var _loc16_ = _loc6_._listeners.length > 0;
         if(_loc6_.__zigoID__ == undefined)
         {
            _loc22_ = true;
            if(com.mosesSupposes.fuse.ZigoEngine._listeners.length > 0)
            {
               var _loc21_ = [];
               for(var _loc24_ in _loc28_)
               {
                  _loc21_.unshift(_loc24_);
               }
               com.mosesSupposes.fuse.ZigoEngine.broadcastMessage("onTweenInterrupt",{target:(typeof _loc6_.addProperty != "function" ? "[MISSING:" + _loc10_.targID + "]" : _loc6_),props:_loc21_,__zigoID__:_loc10_.targZID});
            }
         }
         else
         {
            for(_loc24_ in _loc28_)
            {
               var _loc3_ = _loc28_[_loc24_];
               if(!((_loc3_.ts > this.now || _loc3_.pt != -1) && force != true))
               {
                  var _loc7_ = this.now >= _loc3_.ts + _loc3_.d;
                  if(_loc3_.c == -1)
                  {
                     var _loc5_ = undefined;
                     if(_loc7_ == true)
                     {
                        _loc5_ = _loc3_.ps + _loc3_.ch;
                        if(_loc3_.cycles > 1 || _loc3_.cycles == 0)
                        {
                           if(_loc3_.cycles > 1)
                           {
                              _loc3_.cycles = _loc3_.cycles - 1;
                           }
                           _loc3_.ps = _loc5_;
                           _loc3_.ch = - _loc3_.ch;
                           _loc3_.ts = this.now;
                           _loc7_ = false;
                        }
                     }
                     else
                     {
                        _loc5_ = _loc3_.ef(this.now - _loc3_.ts,_loc3_.ps,_loc3_.ch,_loc3_.d,_loc3_.e1,_loc3_.e2);
                     }
                     if(_global.isNaN(_loc5_) == false)
                     {
                        if(_loc20_ == true)
                        {
                           _loc5_ = Math.round(Number(_loc5_));
                        }
                        if(_loc3_.special != true)
                        {
                           _loc6_[_loc24_] = _loc5_;
                        }
                        else if(_loc3_.fmp != -1)
                        {
                           _loc3_.fmp.setFilterProp(_loc6_,_loc24_,_loc5_);
                        }
                        else if(_loc24_ == "_bezier_")
                        {
                           var _loc8_ = _loc3_.bz;
                           _loc6_._x = _loc8_.sx + _loc5_ * (2 * (1 - _loc5_) * _loc8_.ctrlx + _loc5_ * _loc8_.chx);
                           _loc6_._y = _loc8_.sy + _loc5_ * (2 * (1 - _loc5_) * _loc8_.ctrly + _loc5_ * _loc8_.chy);
                        }
                        else if(_loc24_ == "_frame")
                        {
                           MovieClip(_loc6_).gotoAndStop(Math.round(_loc5_));
                        }
                     }
                  }
                  else
                  {
                     var _loc4_ = {};
                     var _loc15_ = _loc7_ == true && (_loc3_.cycles > 1 || _loc3_.cycles == 0);
                     for(var _loc23_ in _loc3_.ch)
                     {
                        var _loc9_ = _loc3_.ch[_loc23_];
                        if(_loc7_ == true)
                        {
                           _loc4_[_loc23_] = _loc3_.ps[_loc23_] + _loc9_;
                           if(_loc15_ == true)
                           {
                              _loc3_.ch[_loc23_] = - _loc9_;
                           }
                        }
                        else
                        {
                           _loc4_[_loc23_] = _loc3_.ef(this.now - _loc3_.ts,_loc3_.ps[_loc23_],_loc9_,_loc3_.d,_loc3_.e1,_loc3_.e2);
                        }
                        if(_global.isNaN(_loc4_[_loc23_]) == false)
                        {
                           if(_loc20_ == true)
                           {
                              _loc4_[_loc23_] = Math.round(_loc4_[_loc23_]);
                           }
                           if(_loc3_.fmp == -1)
                           {
                              _loc3_.c.setTransform(_loc4_);
                           }
                           else
                           {
                              var _loc14_ = _loc4_.rb << 16 | _loc4_.gb << 8 | _loc4_.bb;
                              _loc3_.fmp.setFilterProp(_loc6_,_loc24_,_loc14_);
                           }
                        }
                     }
                     if(_loc15_ == true)
                     {
                        if(_loc3_.cycles > 1)
                        {
                           _loc3_.cycles = _loc3_.cycles - 1;
                        }
                        _loc7_ = false;
                        _loc3_.ts = this.now;
                        _loc3_.ps = _loc4_;
                     }
                  }
                  if(_loc3_.sf == false)
                  {
                     if(_loc16_ == true)
                     {
                        if(_loc13_[_loc29_] == undefined)
                        {
                           _loc13_[_loc29_] = [_loc6_,[]];
                        }
                        _loc13_[_loc29_][1].unshift(_loc24_);
                     }
                     _loc3_.sf = true;
                  }
                  if(_loc3_.scb.fired == false)
                  {
                     _loc17_[String(_loc3_.scb.id)] = _loc3_.scb;
                     _loc3_.scb.fired = true;
                  }
                  if(_loc16_ == true)
                  {
                     if(_loc11_[_loc29_] == undefined)
                     {
                        _loc11_[_loc29_] = [_loc6_,[]];
                     }
                     _loc11_[_loc29_][1].unshift(_loc24_);
                  }
                  if(_loc3_.ucb != undefined)
                  {
                     _loc19_[String(_loc3_.ucb.id)] = _loc3_.ucb;
                  }
                  if(_loc7_ == true)
                  {
                     if(_loc16_ == true)
                     {
                        if(_loc12_[_loc29_] == undefined)
                        {
                           _loc12_[_loc29_] = [_loc6_,[]];
                        }
                        _loc12_[_loc29_][1].unshift(_loc24_);
                     }
                     if(_loc3_.ecb != undefined)
                     {
                        _loc18_[String(_loc3_.ecb.id)] = _loc3_.ecb;
                     }
                     delete _loc28_[_loc24_];
                     if(_loc24_ == _loc10_.colorProp)
                     {
                        delete _loc10_.colorProp;
                     }
                     _loc10_.numProps = _loc10_.numProps - 1;
                     if(_loc10_.numProps <= 0)
                     {
                        _loc22_ = true;
                     }
                  }
               }
            }
         }
      }
      for(_loc29_ in _loc13_)
      {
         _loc13_[_loc29_][0].broadcastMessage("onTweenStart",{target:_loc13_[_loc29_][0],props:_loc13_[_loc29_][1]});
      }
      for(_loc29_ in _loc17_)
      {
         _loc17_[_loc29_].f.apply(_loc17_[_loc29_].s,_loc17_[_loc29_].a);
      }
      for(_loc29_ in _loc11_)
      {
         _loc11_[_loc29_][0].broadcastMessage("onTweenUpdate",{target:_loc11_[_loc29_][0],props:_loc11_[_loc29_][1]});
      }
      for(_loc29_ in _loc19_)
      {
         _loc19_[_loc29_].f.apply(_loc19_[_loc29_].s,_loc19_[_loc29_].a);
      }
      for(_loc29_ in _loc12_)
      {
         _loc12_[_loc29_][0].broadcastMessage("onTweenEnd",{target:_loc12_[_loc29_][0],props:_loc12_[_loc29_][1]});
      }
      for(_loc29_ in _loc18_)
      {
         _loc18_[_loc29_].f.apply(_loc18_[_loc29_].s,_loc18_[_loc29_].a);
      }
      if(_loc22_)
      {
         this.cleanUp();
      }
      this.now = getTimer();
   }
   function cleanUp(noInit)
   {
      for(var _loc4_ in this.tweens)
      {
         var _loc2_ = this.tweens[_loc4_].targ;
         if(this.tweens[_loc4_].numProps <= 0 || _loc2_.__zigoID__ == undefined)
         {
            if(_loc2_ != undefined && _loc2_.tween == undefined && noInit != true)
            {
               com.mosesSupposes.fuse.ZigoEngine.deinitializeTargets(_loc2_);
            }
            delete this.tweens[_loc4_];
            this.numTweens = this.numTweens - 1;
         }
      }
      if(this.numTweens <= 0)
      {
         this.numTweens = 0;
         delete this.tweens;
         this.tweens = {};
         if(noInit != true)
         {
            com.mosesSupposes.fuse.ZigoEngine.__mgrRelay(this,"setup",[true]);
         }
      }
   }
   function paramsObj(targs, props, endvals)
   {
      var _loc6_ = {};
      _loc6_.all = String(targs).toUpperCase() == com.mosesSupposes.fuse.FuseKitCommon.ALL;
      _loc6_.none = Boolean(targs == null);
      if(_loc6_.all == true)
      {
         _loc6_.tg = [null];
      }
      else
      {
         _loc6_.tg = !(targs instanceof Array) ? [targs] : targs;
         for(var _loc11_ in _loc6_.tg)
         {
            var _loc7_ = _loc6_.tg[_loc11_];
            if(_loc7_ == null || !(typeof _loc7_ == "object" || typeof _loc7_ == "movieclip"))
            {
               _loc6_.tg.splice(Number(_loc11_),1);
            }
         }
      }
      _loc6_.allprops = props == null;
      var _loc1_ = undefined;
      var _loc4_ = undefined;
      var _loc3_ = {};
      if(_loc6_.allprops == false)
      {
         if(typeof props == "string" && (String(props).indexOf(" ") > -1 || String(props).indexOf(",") > -1))
         {
            props = String(props.split(" ").join("")).split(",");
         }
         _loc1_ = !(props instanceof Array) ? [props] : props.slice();
         if(endvals != undefined)
         {
            if(typeof endvals == "string" && (String(endvals).indexOf(" ") > -1 || String(endvals).indexOf(",") > -1))
            {
               endvals = String(endvals.split(" ").join("")).split(",");
            }
            _loc4_ = !(endvals instanceof Array) ? [endvals] : endvals.slice();
            while(_loc4_.length < _loc1_.length)
            {
               _loc4_.push(_loc4_[_loc4_.length - 1]);
            }
            _loc4_.splice(_loc1_.length,_loc4_.length - _loc1_.length);
         }
         for(_loc11_ in _loc1_)
         {
            var _loc2_ = Number(_loc11_);
            if(_loc1_[_loc11_] != "_scale" && _loc1_[_loc11_] != "_size")
            {
               if(_loc3_[_loc1_[_loc11_]] == undefined)
               {
                  if(String(_loc1_[_loc11_]).toUpperCase() == com.mosesSupposes.fuse.FuseKitCommon.ALLCOLOR)
                  {
                     _loc1_[_loc11_] = com.mosesSupposes.fuse.FuseKitCommon.ALLCOLOR;
                  }
                  _loc3_[_loc1_[_loc11_]] = true;
               }
               else
               {
                  _loc1_.splice(_loc2_,1);
                  _loc4_.splice(_loc2_,1);
               }
            }
            else
            {
               var _loc8_ = String(_loc1_.splice(_loc2_,1)[0]);
               var _loc5_ = _loc4_.splice(_loc2_,1)[0];
               if(_loc8_ == "_scale")
               {
                  if(_loc3_._xscale == undefined)
                  {
                     _loc1_.splice(_loc2_,0,"_xscale");
                     _loc4_.splice(_loc2_,0,_loc5_);
                     _loc3_._xscale = true;
                     _loc2_ = _loc2_ + 1;
                  }
                  if(_loc3_._yscale == undefined)
                  {
                     _loc1_.splice(_loc2_,0,"_yscale");
                     _loc4_.splice(_loc2_,0,_loc5_);
                     _loc3_._yscale = true;
                  }
               }
               if(_loc8_ == "_size")
               {
                  if(_loc3_._width == undefined)
                  {
                     _loc1_.splice(_loc2_,0,"_width");
                     _loc4_.splice(_loc2_,0,_loc5_);
                     _loc3_._width = true;
                     _loc2_ = _loc2_ + 1;
                  }
                  if(_loc3_._yscale == undefined)
                  {
                     _loc1_.splice(_loc2_,0,"_height");
                     _loc4_.splice(_loc2_,0,_loc5_);
                     _loc3_._height = true;
                  }
               }
            }
         }
         for(_loc11_ in _loc1_)
         {
            if(_loc1_[_loc11_] == "_xscale" && _loc3_._width == true || _loc1_[_loc11_] == "_yscale" && _loc3_._height == true)
            {
               _loc1_.splice(Number(_loc11_),1);
               _loc4_.splice(Number(_loc11_),1);
               delete _loc3_[_loc1_[_loc11_]];
            }
         }
      }
      _loc6_.pa = _loc1_;
      _loc6_.va = _loc4_;
      _loc6_.props = _loc3_;
      return _loc6_;
   }
}
