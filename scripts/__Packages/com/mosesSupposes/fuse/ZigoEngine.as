class com.mosesSupposes.fuse.ZigoEngine
{
   var __zigoID__;
   var oldAddListener;
   static var _listeners;
   static var broadcastMessage;
   static var extensions;
   static var updateTime;
   static var tweenHolder;
   static var instance;
   static var updateIntId;
   static var VERSION = com.mosesSupposes.fuse.FuseKitCommon.VERSION + ", ZigoEngine based on concepts by Ladislav Zigo, laco.wz.cz/tween";
   static var EASING = "easeOutQuint";
   static var DURATION = 1;
   static var ROUND_RESULTS = false;
   static var OUTPUT_LEVEL = 1;
   static var AUTOSTOP = false;
   static var SKIP_LEVEL = 0;
   static var _playing = false;
   static var zigoIDs = 0;
   static var cbTicker = 0;
   function ZigoEngine()
   {
   }
   static function addListener(handler)
   {
      AsBroadcaster.initialize(com.mosesSupposes.fuse.ZigoEngine);
      com.mosesSupposes.fuse.ZigoEngine.addListener(handler);
   }
   static function removeListener(handler)
   {
   }
   static function isPlaying()
   {
      return com.mosesSupposes.fuse.ZigoEngine._playing;
   }
   static function simpleSetup(shortcutsClass)
   {
      if(arguments.length > 0)
      {
         com.mosesSupposes.fuse.ZigoEngine.register.apply(com.mosesSupposes.fuse.ZigoEngine,arguments);
      }
      _global.ZigoEngine = com.mosesSupposes.fuse.ZigoEngine;
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.fuse != undefined)
      {
         _global.Fuse = com.mosesSupposes.fuse.ZigoEngine.extensions.fuse;
      }
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.fuseFMP != undefined)
      {
         com.mosesSupposes.fuse.ZigoEngine.extensions.fuseFMP.simpleSetup();
      }
      com.mosesSupposes.fuse.ZigoEngine.initialize(MovieClip.prototype,Button.prototype,TextField.prototype);
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts == undefined)
      {
         com.mosesSupposes.fuse.FuseKitCommon.error("001");
      }
   }
   static function register(classReference)
   {
      if(com.mosesSupposes.fuse.ZigoEngine.extensions == undefined)
      {
         com.mosesSupposes.fuse.ZigoEngine.extensions = {};
      }
      var _loc3_ = "|fuse|fuseItem|fuseFMP|shortcuts|pennerEasing|";
      for(var _loc4_ in arguments)
      {
         var _loc2_ = arguments[_loc4_].registryKey;
         if(com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2_] == undefined && _loc3_.indexOf("|" + _loc2_ + "|") > -1)
         {
            com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2_] = arguments[_loc4_];
            if(_loc2_ == "fuseFMP" || _loc2_ == "shortcuts")
            {
               Object(com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2_]).initialize();
            }
         }
      }
   }
   static function initialize(target)
   {
      if(arguments.length > 0)
      {
         com.mosesSupposes.fuse.ZigoEngine.initializeTargets.apply(com.mosesSupposes.fuse.ZigoEngine,arguments);
         if(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
         {
            com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.addShortcutsTo.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts,arguments);
         }
      }
   }
   static function deinitialize(target)
   {
      if(arguments.length == 0 || target == null)
      {
         arguments.push(MovieClip.prototype,Button.prototype,TextField.prototype);
      }
      com.mosesSupposes.fuse.ZigoEngine.deinitializeTargets.apply(com.mosesSupposes.fuse.ZigoEngine,arguments);
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
      {
         com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.removeShortcutsFrom.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts,arguments);
      }
   }
   static function getUpdateInterval()
   {
      return com.mosesSupposes.fuse.ZigoEngine.updateTime;
   }
   static function setUpdateInterval(time)
   {
      if(com.mosesSupposes.fuse.ZigoEngine._playing)
      {
         com.mosesSupposes.fuse.ZigoEngine.setup(true);
         com.mosesSupposes.fuse.ZigoEngine.updateTime = time;
         com.mosesSupposes.fuse.ZigoEngine.setup();
      }
      else
      {
         com.mosesSupposes.fuse.ZigoEngine.updateTime = time;
      }
   }
   static function getControllerDepth()
   {
      return com.mosesSupposes.fuse.ZigoEngine.tweenHolder.getDepth();
   }
   static function setControllerDepth(depth)
   {
      if(depth == null || _global.isNaN(depth) == true)
      {
         depth = 6789;
      }
      if(Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof != null)
      {
         com.mosesSupposes.fuse.ZigoEngine.tweenHolder.swapDepths(depth);
      }
      else
      {
         com.mosesSupposes.fuse.ZigoEngine.tweenHolder = _root.createEmptyMovieClip("ZigoEnginePulse",depth);
      }
   }
   static function doShortcut(targets, methodName)
   {
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts == undefined)
      {
         if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("002");
         }
         return null;
      }
      return com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.doShortcut.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts,arguments);
   }
   static function doTween(targets, props, endvals, seconds, ease, delay, callback)
   {
      if(com.mosesSupposes.fuse.ZigoEngine.extensions.fuse.addBuildItem(arguments) == true)
      {
         return null;
      }
      if(com.mosesSupposes.fuse.ZigoEngine.instance == undefined || Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof == undefined && com.mosesSupposes.fuse.ZigoEngine.updateTime == undefined)
      {
         if(MovieClip.prototype.tween != null && typeof _global.$tweenManager == "object")
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("003");
         }
         com.mosesSupposes.fuse.ZigoEngine.instance = new com.mosesSupposes.fuse.ZManager();
         com.mosesSupposes.fuse.ZigoEngine._playing = false;
      }
      var _loc4_ = com.mosesSupposes.fuse.ZigoEngine.instance.paramsObj(targets,props,endvals);
      var _loc7_ = !(_loc4_.tg[0] == null || _loc4_.tg.length == 0) ? _loc4_.tg : undefined;
      if(_loc4_.pa == undefined || _loc7_ == undefined || arguments.length < 3)
      {
         if(com.mosesSupposes.fuse.ZigoEngine.extensions.fuseItem != null && typeof _loc7_[0] == "object")
         {
            return com.mosesSupposes.fuse.ZigoEngine.extensions.fuseItem.doTween(arguments[0]);
         }
         if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            if(arguments.length < 3)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("004",String(arguments.length));
            }
            else
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("005",_loc7_.toString(),_loc4_.pa.toString());
            }
         }
         return null;
      }
      if(com.mosesSupposes.fuse.ZigoEngine._playing != true)
      {
         com.mosesSupposes.fuse.ZigoEngine.setup();
      }
      if(seconds == null || _global.isNaN(seconds) == true)
      {
         seconds = com.mosesSupposes.fuse.ZigoEngine.DURATION || 1;
      }
      else if(seconds < 0.01)
      {
         seconds = 0;
      }
      if(delay < 0.01 || delay == null || _global.isNaN(delay) == true)
      {
         delay = 0;
      }
      var _loc12_ = com.mosesSupposes.fuse.ZigoEngine.parseCallback(callback,_loc7_);
      var _loc9_ = undefined;
      if(typeof ease == "function")
      {
         if(typeof Function(ease).call(null,1,1,1,1) == "number")
         {
            _loc9_ = Function(ease);
         }
         else if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("014",ease);
         }
      }
      else if(ease == null || ease == "")
      {
         if(com.mosesSupposes.fuse.ZigoEngine.EASING instanceof Function)
         {
            _loc9_ = Function(com.mosesSupposes.fuse.ZigoEngine.EASING);
         }
         else if(com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing != undefined)
         {
            ease = com.mosesSupposes.fuse.ZigoEngine.EASING;
         }
      }
      if(typeof ease == "string" && ease != "")
      {
         if(com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing[ease] != undefined)
         {
            _loc9_ = com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing[ease];
         }
         else if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("006",ease);
         }
      }
      else if(typeof ease == "object" && ease.ease != null && ease.pts != null)
      {
         _loc9_ = Function(ease.ease);
         _loc12_.extra1 = ease.pts;
      }
      if(typeof _loc9_ != "function")
      {
         _loc9_ = function(t, b, c, d)
         {
            return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
         };
      }
      var _loc6_ = "";
      for(var _loc13_ in _loc7_)
      {
         var _loc3_ = _loc7_[_loc13_];
         if(_loc3_.__zigoID__ == null)
         {
            com.mosesSupposes.fuse.ZigoEngine.initializeTargets(_loc3_);
         }
         else if(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("locked",_loc3_) == true)
         {
            if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("007",_loc3_._name == undefined ? _loc3_.toString() : _loc3_._name,_loc4_.pa.toString());
            }
            continue;
         }
         var _loc5_ = com.mosesSupposes.fuse.ZigoEngine.instance.addTween(_loc3_,_loc4_.pa,_loc4_.va,seconds,_loc9_,delay,_loc12_);
         _loc6_ = (_loc5_ != null ? _loc5_ + "|" : "|") + _loc6_;
      }
      _loc6_ = _loc6_.slice(0,-1);
      return !(_loc6_ == "" || _loc6_ == "|") ? _loc6_ : null;
   }
   static function removeTween(targs, props)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.removeTween(targs,props);
   }
   static function isTweening(targ, prop)
   {
      return Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("active",targ,prop));
   }
   static function getTweens(targ)
   {
      return Number(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("count",targ));
   }
   static function lockTween(targ, setLocked)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("lock",targ,setLocked);
   }
   static function isTweenLocked(targ)
   {
      return Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("locked",targ));
   }
   static function ffTween(targs, props)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("ff",targs,props);
   }
   static function rewTween(targs, props, pauseFlag, suppressStartEvents)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("rewind",targs,props,pauseFlag,suppressStartEvents);
   }
   static function isTweenPaused(targ, prop)
   {
      return Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("paused",targ,prop));
   }
   static function pauseTween(targs, props)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("pause",targs,props);
   }
   static function unpauseTween(targs, props)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("unpause",targs,props);
   }
   static function resumeTween(targs, props)
   {
      com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("unpause",targs,props);
   }
   static function setColorByKey(targetObj, type, amt, rgb)
   {
      new Color(targetObj).setTransform(com.mosesSupposes.fuse.ZigoEngine.getColorTransObj(type,amt,rgb));
   }
   static function getColorTransObj(type, amt, rgb)
   {
      switch(type)
      {
         case "brightness":
            var _loc3_ = 100 - Math.abs(amt);
            var _loc4_ = amt <= 0 ? 0 : 255 * (amt / 100);
            return {ra:_loc3_,rb:_loc4_,ga:_loc3_,gb:_loc4_,ba:_loc3_,bb:_loc4_};
         case "brightOffset":
            return {ra:100,rb:255 * (amt / 100),ga:100,gb:255 * (amt / 100),ba:100,bb:255 * (amt / 100)};
         case "contrast":
            return {ra:amt,rb:128 - 1.28 * amt,ga:amt,gb:128 - 1.28 * amt,ba:amt,bb:128 - 1.28 * amt};
         case "invertColor":
            return {ra:100 - 2 * amt,rb:amt * 2.55,ga:100 - 2 * amt,gb:amt * 2.55,ba:100 - 2 * amt,bb:amt * 2.55};
         case "tint":
            if(rgb != null)
            {
               var _loc5_ = undefined;
               if(typeof rgb == "string")
               {
                  if(rgb.charAt(0) == "#")
                  {
                     rgb = rgb.slice(1);
                  }
                  rgb = rgb.charAt(1).toLowerCase() == "x" ? rgb : "0x" + rgb;
               }
               _loc5_ = Number(rgb);
               return {ra:100 - amt,rb:(_loc5_ >> 16) * (amt / 100),ga:100 - amt,gb:(_loc5_ >> 8 & 255) * (amt / 100),ba:100 - amt,bb:(_loc5_ & 255) * (amt / 100)};
            }
            break;
      }
      return {rb:0,ra:100,gb:0,ga:100,bb:0,ba:100};
   }
   static function getColorKeysObj(targOrTransObj)
   {
      var _loc1_ = targOrTransObj.ra == undefined ? new Color(targOrTransObj).getTransform() : targOrTransObj;
      var _loc3_ = {};
      var _loc7_ = _loc1_.ra == _loc1_.ga && _loc1_.ga == _loc1_.ba;
      var _loc9_ = _loc1_.rb == _loc1_.gb && _loc1_.gb == _loc1_.bb;
      var _loc5_ = _loc7_ != true ? 0 : 100 - _loc1_.ra;
      if(_loc5_ != 0)
      {
         var _loc6_ = 100 / _loc5_;
         _loc3_.tint = _loc1_.rb * _loc6_ << 16 | _loc1_.gb * _loc6_ << 8 | _loc1_.bb * _loc6_;
         _loc3_.tintPercent = _loc5_;
         var _loc2_ = _loc3_.tint.toString(16);
         var _loc4_ = 6 - _loc2_.length;
         while(true)
         {
            _loc4_;
            if(_loc4_-- <= 0)
            {
               break;
            }
            _loc2_ = "0" + _loc2_;
         }
         _loc3_.tintString = "0x" + _loc2_.toUpperCase();
      }
      if(_loc7_ == true && _loc9_ == true)
      {
         if(_loc1_.ra < 0)
         {
            _loc3_.invertColor = _loc1_.rb * 0.39215686274509803;
         }
         else if(_loc1_.ra == 100 && _loc1_.rb != 0)
         {
            _loc3_.brightOffset = _loc1_.rb * 0.39215686274509803;
         }
         if(_loc1_.ra != 100)
         {
            if(_loc1_.rb == 0 || _loc1_.rb != 0 && 255 * ((100 - _loc1_.ra) / 100) - _loc1_.rb <= 1)
            {
               _loc3_.brightness = _loc1_.rb == 0 ? _loc1_.ra - 100 : 100 - _loc1_.ra;
            }
            if(128 - 1.28 * _loc1_.ra - _loc1_.rb <= 1)
            {
               _loc3_.contrast = _loc1_.ra;
            }
         }
      }
      return _loc3_;
   }
   static function initializeTargets()
   {
      for(var _loc5_ in arguments)
      {
         var _loc4_ = arguments[_loc5_];
         if(_loc4_ == MovieClip.prototype || _loc4_ == Button.prototype || _loc4_ == TextField.prototype || _loc4_ == Object.prototype)
         {
            if(_loc4_.oldAddListener == undefined)
            {
               if(_loc4_ == TextField.prototype)
               {
                  _loc4_.oldAddListener = _loc4_.addListener;
                  _global.ASSetPropFlags(_loc4_,"oldAddListener",7,1);
               }
               _loc4_.addListener = function(o)
               {
                  if(this.__zigoID__ == undefined)
                  {
                     com.mosesSupposes.fuse.ZigoEngine.initializeTargets(this);
                  }
                  if(this instanceof TextField)
                  {
                     Function(this.oldAddListener).call(this,o);
                  }
                  else
                  {
                     this.addListener(o);
                  }
               };
               if(_loc4_ == MovieClip.prototype)
               {
                  _global.ASSetPropFlags(_loc4_,"addListener",7,1);
               }
            }
         }
         else if(_loc4_.__zigoID__ == undefined)
         {
            _loc4_.__zigoID__ = com.mosesSupposes.fuse.ZigoEngine.zigoIDs;
            _global.ASSetPropFlags(_loc4_,"__zigoID__",7,1);
            com.mosesSupposes.fuse.ZigoEngine.zigoIDs = com.mosesSupposes.fuse.ZigoEngine.zigoIDs + 1;
            if(_loc4_._listeners == null || _loc4_.addListener == null)
            {
               AsBroadcaster.initialize(_loc4_);
            }
         }
      }
   }
   static function deinitializeTargets()
   {
      for(var _loc4_ in arguments)
      {
         var _loc3_ = arguments[_loc4_];
         if(_loc3_.__zigoID__ != undefined)
         {
            _global.ASSetPropFlags(_loc3_,"__zigoID__,_listeners,broadcastMessage,addListener,removeListener",0,2);
            delete _loc3_.__zigoID__;
            delete _loc3_._listeners;
            delete _loc3_.broadcastMessage;
            delete _loc3_.addListener;
            delete _loc3_.removeListener;
         }
         if(_loc3_.oldAddListener != undefined)
         {
            _global.ASSetPropFlags(_loc3_,"oldAddListener",0,2);
            _loc3_.addListener = _loc3_.oldAddListener;
            delete _loc3_.oldAddListener;
         }
      }
   }
   static function __mgrRelay(inst, method, args)
   {
      if(inst == com.mosesSupposes.fuse.ZigoEngine.instance)
      {
         Function(com.mosesSupposes.fuse.ZigoEngine[method]).apply(com.mosesSupposes.fuse.ZigoEngine,args);
      }
   }
   static function setup(deinitFlag)
   {
      if(deinitFlag == true)
      {
         com.mosesSupposes.fuse.ZigoEngine._playing = false;
         clearInterval(com.mosesSupposes.fuse.ZigoEngine.updateIntId);
         delete com.mosesSupposes.fuse.ZigoEngine.tweenHolder.onEnterFrame;
         return undefined;
      }
      com.mosesSupposes.fuse.ZigoEngine.instance.cleanUp();
      clearInterval(com.mosesSupposes.fuse.ZigoEngine.updateIntId);
      delete com.mosesSupposes.fuse.ZigoEngine.updateIntId;
      if(com.mosesSupposes.fuse.ZigoEngine.updateTime != null && com.mosesSupposes.fuse.ZigoEngine.updateTime > 0)
      {
         com.mosesSupposes.fuse.ZigoEngine.updateIntId = setInterval(com.mosesSupposes.fuse.ZigoEngine.instance,"update",com.mosesSupposes.fuse.ZigoEngine.updateTime);
      }
      else
      {
         if(Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof == null)
         {
            com.mosesSupposes.fuse.ZigoEngine.setControllerDepth(6789);
            Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof = 1;
         }
         var _inst = com.mosesSupposes.fuse.ZigoEngine.instance;
         com.mosesSupposes.fuse.ZigoEngine.tweenHolder.onEnterFrame = function()
         {
            _inst.update.call(_inst);
         };
      }
      com.mosesSupposes.fuse.ZigoEngine._playing = true;
      com.mosesSupposes.fuse.ZigoEngine.instance.now = getTimer();
   }
   static function parseCallback(callback, targets)
   {
      var validCBs = {skipLevel:com.mosesSupposes.fuse.ZigoEngine.SKIP_LEVEL,cycles:1};
      if(callback.skipLevel != undefined && typeof callback.skipLevel == "number" && callback.skipLevel != com.mosesSupposes.fuse.ZigoEngine.SKIP_LEVEL)
      {
         if(callback.skipLevel >= 0 && callback.skipLevel <= 2)
         {
            validCBs.skipLevel = callback.skipLevel;
         }
      }
      if(callback.cycles != undefined)
      {
         if(typeof callback.cycles == "number" && callback.cycles > -1)
         {
            validCBs.cycles = callback.cycles;
         }
         else if(callback.cycles.toUpperCase() == "LOOP")
         {
            validCBs.cycles = 0;
         }
      }
      if(callback.extra1 != undefined)
      {
         validCBs.extra1 = callback.extra1;
      }
      if(callback.extra2 != undefined)
      {
         validCBs.extra2 = callback.extra2;
      }
      if(callback == undefined)
      {
         return validCBs;
      }
      var cbErrors = [];
      var ezf;
      if(typeof callback == "string")
      {
         ezf = String(callback);
      }
      else if(typeof callback.easyfunc == "string")
      {
         ezf = callback.easyfunc;
      }
      if(ezf != undefined && ezf.indexOf("(") > -1 && ezf.indexOf(")") > -1)
      {
         if(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
         {
            callback = com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.parseStringTypeCallback(ezf);
         }
         else if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("008");
         }
      }
      else if(typeof callback == "function" || typeof callback == "string")
      {
         callback = {func:callback};
      }
      for(var i in callback)
      {
         var fi = i.toLowerCase().indexOf("func");
         if(fi > -1)
         {
            var prefix = i.slice(0,fi);
            var func = callback[i];
            var args = callback[prefix + "args"];
            var scope = callback[prefix + "scope"];
            if(typeof func == "string" && scope[func] == undefined)
            {
               for(var j in targets)
               {
                  var targ = targets[j];
                  if(typeof targ[func] == "function")
                  {
                     scope = targ;
                     break;
                  }
                  if(typeof targ._parent[func] == "function")
                  {
                     scope = targ._parent;
                     break;
                  }
               }
               if(scope == undefined && _level0[func] != undefined)
               {
                  scope = _level0;
               }
               if(scope == undefined && _global[func] != undefined)
               {
                  scope = _global;
               }
            }
            if(typeof func != "function")
            {
               if(typeof scope[String(func)] == "function")
               {
                  func = scope[String(func)];
               }
               else
               {
                  func = eval(String(func));
               }
            }
            if(func == undefined)
            {
               cbErrors.push(String(i + ":" + (typeof callback[i] != "string" ? callback[i] : "\"" + callback[i] + "\"") + "/" + prefix + "scope:" + scope));
            }
            else
            {
               if(args != undefined && !(args instanceof Array))
               {
                  args = [args];
               }
               if(prefix == "")
               {
                  prefix = "end";
               }
               validCBs[prefix] = {s:scope,f:func,a:args,id:com.mosesSupposes.fuse.ZigoEngine.cbTicker++};
               if(prefix == "start")
               {
                  validCBs.start.fired = false;
               }
            }
         }
         else if(com.mosesSupposes.fuse.FuseKitCommon._cbprops().indexOf("|" + i + "|") == -1)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("009",i);
         }
      }
      if(cbErrors.length > 0 && com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
      {
         if(com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("010",cbErrors.length,cbErrors.toString());
         }
      }
      return validCBs;
   }
}
