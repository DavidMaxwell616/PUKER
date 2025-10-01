class com.mosesSupposes.fuse.Shortcuts
{
   var __fadeOutEnd;
   var __owner;
   var _currentframe;
   var _height;
   var _totalframes;
   var _visible;
   var _width;
   var _xscale;
   var _yscale;
   var addListener;
   var gotoAndStop;
   var onTweenInterrupt;
   static var registryKey = "shortcuts";
   static var shortcuts = null;
   static var mcshortcuts = null;
   function Shortcuts()
   {
   }
   static function initialize()
   {
      if(com.mosesSupposes.fuse.Shortcuts.shortcuts == null)
      {
         com.mosesSupposes.fuse.Shortcuts.initShortcuts();
      }
   }
   static function doShortcut(obj, methodName)
   {
      com.mosesSupposes.fuse.Shortcuts.initialize();
      var _loc5_ = com.mosesSupposes.fuse.Shortcuts.shortcuts[methodName];
      if(_loc5_ == undefined)
      {
         if(typeof obj == "movieclip")
         {
            _loc5_ = com.mosesSupposes.fuse.Shortcuts.mcshortcuts[methodName];
         }
      }
      if(_loc5_ == undefined)
      {
         return null;
      }
      obj = arguments.shift();
      methodName = String(arguments.shift());
      if(!(obj instanceof Array))
      {
         obj = [obj];
      }
      var _loc3_ = "";
      var _loc2_;
      for(var _loc6_ in obj)
      {
         _loc2_ = String(_loc5_.apply(obj[_loc6_],arguments));
         if(_loc2_ != null && _loc2_.length > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc2_ + "|" + _loc3_;
            }
            else
            {
               _loc3_ = _loc2_;
            }
         }
      }
      return _loc3_ != "" ? _loc3_ : null;
   }
   static function addShortcutsTo()
   {
      com.mosesSupposes.fuse.Shortcuts.initialize();
      var _loc5_ = function(o, so)
      {
         var _loc2_;
         for(var _loc5_ in so)
         {
            _loc2_ = so[_loc5_];
            if(_loc2_.getter || _loc2_.setter)
            {
               o.addProperty(_loc5_,_loc2_.getter,_loc2_.setter);
               _global.ASSetPropFlags(o,_loc5_,3,1);
            }
            else
            {
               o[_loc5_] = _loc2_;
               _global.ASSetPropFlags(o,_loc5_,7,1);
            }
         }
      };
      var _loc4_;
      for(var _loc7_ in arguments)
      {
         _loc4_ = arguments[_loc7_];
         if(_loc4_ == MovieClip.prototype || typeof _loc4_ == "movieclip")
         {
            _loc5_(_loc4_,com.mosesSupposes.fuse.Shortcuts.mcshortcuts);
         }
         _loc5_(_loc4_,com.mosesSupposes.fuse.Shortcuts.shortcuts);
      }
   }
   static function removeShortcutsFrom()
   {
      com.mosesSupposes.fuse.Shortcuts.initialize();
      var _loc5_ = function(o, so)
      {
         var _loc2_;
         for(var _loc5_ in so)
         {
            _global.ASSetPropFlags(o,_loc5_,0,2);
            _loc2_ = so[_loc5_];
            if(_loc2_.getter || _loc2_.setter)
            {
               o.addProperty(_loc5_,null,null);
            }
            delete o[_loc5_];
         }
      };
      var _loc3_;
      for(var _loc7_ in arguments)
      {
         _loc3_ = arguments[_loc7_];
         if(_loc3_ == MovieClip.prototype || typeof _loc3_ == "movieclip")
         {
            _loc5_(_loc3_,com.mosesSupposes.fuse.Shortcuts.mcshortcuts);
         }
         _loc5_(_loc3_,com.mosesSupposes.fuse.Shortcuts.shortcuts);
      }
   }
   static function parseStringTypeCallback(callbackStr)
   {
      var evaluate = function(val)
      {
         var first = val.charAt(0);
         if(first == val.slice(-1) && (first == "\"" || first == "\'"))
         {
            return val.slice(1,-1);
         }
         if(val == "true")
         {
            return Object(true);
         }
         if(val == "false")
         {
            return Object(false);
         }
         if(val == "null")
         {
            return Object(null);
         }
         if(_global.isNaN(Number(val)) == false)
         {
            return Object(Number(val));
         }
         return Object(eval(val));
      };
      var trimWhite = function(str)
      {
         while(str.charAt(0) == " ")
         {
            str = str.slice(1);
         }
         while(str.slice(-1) == " ")
         {
            str = str.slice(0,-1);
         }
         return str;
      };
      var evaluateList = function(list)
      {
         var _loc11_ = [];
         var _loc4_ = 0;
         var _loc3_;
         var _loc5_;
         var _loc10_;
         var _loc6_;
         var _loc2_;
         var _loc1_;
         var _loc8_;
         var _loc7_;
         while(_loc4_ < list.length)
         {
            _loc3_ = list[_loc4_];
            _loc3_ = trimWhite(_loc3_);
            _loc5_ = _loc3_.charAt(0) == "{" && (_loc3_.indexOf("}") > -1 || _loc3_.indexOf(":") > -1);
            _loc10_ = _loc3_.charAt(0) == "[";
            if((_loc5_ || _loc10_) == true)
            {
               _loc6_ = _loc5_ != true ? [] : {};
               _loc2_ = _loc4_;
               while(_loc2_ < list.length)
               {
                  if(_loc2_ == _loc4_)
                  {
                     _loc3_ = _loc3_.slice(1);
                  }
                  _loc8_ = _loc1_.slice(-1) == (_loc5_ != true ? "]" : "}") || _loc2_ == list.length - 1;
                  if(_loc8_ == true)
                  {
                     _loc1_ = _loc1_.slice(0,-1);
                  }
                  if(_loc5_ == true && _loc1_.indexOf(":") > -1)
                  {
                     _loc7_ = _loc1_.split(":");
                     _loc6_[trimWhite(_loc7_[0])] = evaluate(trimWhite(_loc7_[1]));
                  }
                  else if(_loc10_ == true)
                  {
                     _loc6_.push(evaluate(trimWhite(_loc1_)));
                  }
                  if(_loc8_ == true)
                  {
                     _loc11_.push(_loc6_);
                     _loc4_ = _loc2_;
                     break;
                  }
                  _loc2_ = _loc2_ + 1;
               }
            }
            else
            {
               _loc11_.push(evaluate(trimWhite(_loc3_)));
            }
            _loc4_ = _loc4_ + 1;
         }
         return _loc11_;
      };
      var parts = callbackStr.split("(");
      var p0 = parts[0];
      var p1 = parts[1];
      return {func:p0.slice(p0.lastIndexOf(".") + 1),scope:eval(p0.slice(0,p0.lastIndexOf("."))),args:evaluateList(p1.slice(0,p1.lastIndexOf(")")).split(","))};
   }
   static function initShortcuts()
   {
      com.mosesSupposes.fuse.Shortcuts.shortcuts = new Object();
      var methods = {alphaTo:"_alpha",scaleTo:"_scale",sizeTo:"_size",rotateTo:"_rotation",brightnessTo:"_brightness",brightOffsetTo:"_brightOffset",contrastTo:"_contrast",colorTo:"_tint",tintPercentTo:"_tintPercent",colorResetTo:"_colorReset",invertColorTo:"_invertColor"};
      var _loc4_ = _global.com.mosesSupposes.fuse.FuseFMP.getAllShortcuts();
      var _loc6_ = {blur:1,blurX:1,blurY:1,strength:1,shadowAlpha:1,highlightAlpha:1,angle:1,distance:1,alpha:1,color:1};
      for(var _loc9_ in _loc4_)
      {
         if(_loc6_[_loc4_[_loc9_].split("_")[1]] === 1)
         {
            methods[_loc4_[_loc9_] + "To"] = _loc4_[_loc9_];
         }
      }
      var _loc7_ = {__resolve:function(name)
      {
         var propName = methods[name];
         return function()
         {
            var _loc4_ = _global.com.mosesSupposes.fuse.ZigoEngine.doTween.apply(com.mosesSupposes.fuse.ZigoEngine,new Array(this,propName).concat(arguments));
            return _loc4_;
         };
      }};
      var _loc5_ = {__resolve:function(name)
      {
         var prop = name.slice(1);
         var _loc3_ = {getter:function()
         {
            return _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this)[prop];
         }};
         if(prop == "tintString" || prop == "tint")
         {
            _loc3_.setter = function(v)
            {
               _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,"tint",_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tintPercent || 100,v);
            };
         }
         else if(prop == "tintPercent")
         {
            _loc3_.setter = function(v)
            {
               _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,"tint",v,_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tint);
            };
         }
         else if(prop == "colorReset")
         {
            _loc3_.setter = function(v)
            {
               var _loc3_ = _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this);
               _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,"tint",Math.min(100,Math.max(0,Math.min(_loc3_.tintPercent,100 - v))),_loc3_.tint);
            };
         }
         else
         {
            _loc3_.setter = function(v)
            {
               _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this,prop,v);
            };
         }
         return _loc3_;
      }};
      for(_loc9_ in methods)
      {
         com.mosesSupposes.fuse.Shortcuts.shortcuts[_loc9_] = _loc7_[_loc9_];
         if(_loc9_ == "colorTo")
         {
            com.mosesSupposes.fuse.Shortcuts.shortcuts._tintString = _loc5_._tintString;
         }
         if(_loc9_.indexOf("bright") == 0 || _loc9_ == "contrastTo" || _loc9_ == "colorTo" || _loc9_ == "invertColor" || _loc9_ == "tintPercentTo" || _loc9_ == "colorResetTo")
         {
            com.mosesSupposes.fuse.Shortcuts.shortcuts[methods[_loc9_]] = _loc5_[methods[_loc9_]];
         }
      }
      com.mosesSupposes.fuse.Shortcuts.shortcuts.tween = function(props, endVals, seconds, ease, delay, callback)
      {
         if(arguments.length == 1 && typeof props == "object")
         {
            return com.mosesSupposes.fuse.ZigoEngine.doTween({target:this,action:props});
         }
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,props,endVals,seconds,ease,delay,callback);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.removeTween = com.mosesSupposes.fuse.Shortcuts.shortcuts.stopTween = function(props)
      {
         com.mosesSupposes.fuse.ZigoEngine.removeTween(this,props);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.removeAllTweens = com.mosesSupposes.fuse.Shortcuts.shortcuts.stopAllTweens = function()
      {
         com.mosesSupposes.fuse.ZigoEngine.removeTween("ALL");
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweening = function(prop)
      {
         return com.mosesSupposes.fuse.ZigoEngine.isTweening(this,prop);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.getTweens = function()
      {
         return com.mosesSupposes.fuse.ZigoEngine.getTweens(this);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.lockTween = function()
      {
         com.mosesSupposes.fuse.ZigoEngine.lockTween(this,true);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.unlockTween = function()
      {
         com.mosesSupposes.fuse.ZigoEngine.lockTween(this,false);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweenLocked = function()
      {
         return com.mosesSupposes.fuse.ZigoEngine.isTweenLocked(this);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweenPaused = function(prop)
      {
         return com.mosesSupposes.fuse.ZigoEngine.isTweenPaused(this,prop);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.pauseTween = function(props)
      {
         com.mosesSupposes.fuse.ZigoEngine.pauseTween(this,props);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.resumeTween = com.mosesSupposes.fuse.Shortcuts.shortcuts.unpauseTween = function(props)
      {
         com.mosesSupposes.fuse.ZigoEngine.unpauseTween(this,props);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.pauseAllTweens = function()
      {
         com.mosesSupposes.fuse.ZigoEngine.pauseTween("ALL");
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.resumeAllTweens = com.mosesSupposes.fuse.Shortcuts.shortcuts.unpauseAllTweens = function()
      {
         com.mosesSupposes.fuse.ZigoEngine.unpauseTween("ALL");
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.ffTween = function(props)
      {
         com.mosesSupposes.fuse.ZigoEngine.ffTween(this,props);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.rewTween = function(props, suppressStartEvents)
      {
         com.mosesSupposes.fuse.ZigoEngine.rewTween(this,props,false,suppressStartEvents);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.rewAndPauseTween = function(props, suppressStartEvents)
      {
         com.mosesSupposes.fuse.ZigoEngine.rewTween(this,props,true,suppressStartEvents);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.fadeIn = function(seconds, ease, delay, callback)
      {
         this._visible = true;
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_alpha",100,seconds,ease,delay);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.fadeOut = function(seconds, ease, delay, callback)
      {
         if(this.__fadeOutEnd == undefined)
         {
            this.__fadeOutEnd = {__owner:this,onTweenEnd:function(o)
            {
               this.onTweenInterrupt(o);
               if(String(o.props.join(",")).indexOf("_alpha") > -1 && this.__owner._alpha < 1)
               {
                  o.target._visible = false;
               }
            },onTweenInterrupt:function(o)
            {
               if(o.target == this.__owner && String(o.props.join(",")).indexOf("_alpha") > -1)
               {
                  this.__owner.removeListener(this);
                  com.mosesSupposes.fuse.ZigoEngine.removeListener(this);
               }
            }};
            _global.ASSetPropFlags(this,"__fadeOutEnd",7,1);
         }
         this.addListener(this.__fadeOutEnd);
         var _loc3_ = com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_alpha",0,seconds,ease,delay,callback);
         com.mosesSupposes.fuse.ZigoEngine.addListener(this.__fadeOutEnd);
         return _loc3_;
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.bezierTo = function(destX, destY, controlX, controlY, seconds, ease, delay, callback)
      {
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_bezier_",{x:destX,y:destY,controlX:controlX,controlY:controlY},seconds,ease,delay,callback);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.colorTransformTo = function(ra, rb, ga, gb, ba, bb, aa, ab, seconds, ease, delay, callback)
      {
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_colorTransform",{ra:ra,rb:rb,ga:ga,gb:gb,ba:ba,bb:bb,aa:aa,ab:ab},seconds,ease,delay,callback);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.tintTo = function(rgb, percent, seconds, ease, delay, callback)
      {
         var _loc3_ = {};
         _loc3_.rgb = arguments.shift();
         _loc3_.percent = arguments.shift();
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_tint",{tint:rgb,percent:percent},seconds,ease,delay,callback);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts.slideTo = function(destX, destY, seconds, ease, delay, callback)
      {
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_x,_y",[destX,destY],seconds,ease,delay,callback);
      };
      com.mosesSupposes.fuse.Shortcuts.shortcuts._size = {getter:function()
      {
         return this._width != this._height ? null : this._width;
      },setter:function(v)
      {
         com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_size",v,0);
      }};
      com.mosesSupposes.fuse.Shortcuts.shortcuts._scale = {getter:function()
      {
         return this._xscale != this._yscale ? null : this._xscale;
      },setter:function(v)
      {
         com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_scale",v,0);
      }};
      com.mosesSupposes.fuse.Shortcuts.mcshortcuts = new Object();
      com.mosesSupposes.fuse.Shortcuts.mcshortcuts._frame = {getter:function()
      {
         return this._currentframe;
      },setter:function(v)
      {
         this.gotoAndStop(Math.round(v));
      }};
      com.mosesSupposes.fuse.Shortcuts.mcshortcuts.frameTo = function(endframe, seconds, ease, delay, callback)
      {
         return com.mosesSupposes.fuse.ZigoEngine.doTween(this,"_frame",endframe == undefined ? this._totalframes : endframe,seconds,ease,delay,callback);
      };
   }
}
