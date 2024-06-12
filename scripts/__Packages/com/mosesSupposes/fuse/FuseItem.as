class com.mosesSupposes.fuse.FuseItem
{
   var _nItemID;
   var _nFuseID;
   var _initObj;
   var _aProfiles;
   var _oElements;
   var _oTemps;
   var _sImage;
   var _aTweens;
   static var _ZigoEngine;
   static var _aInstances;
   static var registryKey = "fuseItem";
   static var ADD_UNDERSCORES = true;
   var _nPlaying = -1;
   var _bStartSet = false;
   var _bTrigger = false;
   function FuseItem(id, o, fuseID)
   {
      com.mosesSupposes.fuse.FuseItem._ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
      this._nItemID = id;
      this._nFuseID = fuseID;
      this._initObj = o;
      this._aProfiles = [];
      this._oElements = {aEvents:[]};
      this._oTemps = {};
      if(!(o instanceof Array))
      {
         o = [o];
      }
      var _loc18_ = _global.com.mosesSupposes.fuse.Fuse;
      this._oTemps.outputLevel = _loc18_ == undefined ? _global.com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL : _loc18_.OUTPUT_LEVEL;
      if(o.length == 1)
      {
         var _loc17_ = o[0];
         var _loc9_ = _loc17_.action == undefined ? _loc17_ : _loc17_.action;
         if(_loc9_.__buildMode != true && _loc9_.command != undefined)
         {
            this._oElements.command = _loc9_.command;
            this._oElements.scope = _loc9_.scope;
            this._oElements.args = _loc9_.args;
            this._sImage = " Elements:[" + ("command" + (typeof _loc9_.command != "string" ? ", " : ":\"" + _loc9_.command + "\", "));
            if(_loc9_.label != undefined && typeof _loc9_.label == "string")
            {
               this._sImage += "label:\"" + _loc9_.label + "\", ";
               this._oElements.label = _loc9_.label;
            }
            if(_loc9_.delay != undefined)
            {
               this._sImage += "delay, ";
               this._oElements.delay = _loc9_.delay;
            }
            if(_loc9_.func != undefined && this._oTemps.outputLevel > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("113");
            }
            return undefined;
         }
      }
      this._oTemps.sImgS = "";
      this._oTemps.sImgE = "";
      this._oTemps.sImgB = "";
      this._oTemps.afl = 0;
      this._oTemps.ael = 0;
      this._oTemps.twDelayFlag = false;
      this._oTemps.nActions = o.length;
      this._oTemps.fuseProps = com.mosesSupposes.fuse.FuseKitCommon._fuseprops();
      this._oTemps.cbProps = com.mosesSupposes.fuse.FuseKitCommon._cbprops();
      this._oTemps.sUP = com.mosesSupposes.fuse.FuseKitCommon._underscoreable();
      this._oTemps.sCT = com.mosesSupposes.fuse.FuseKitCommon._cts();
      this._oTemps.bTriggerFound = false;
      for(var _loc16_ in o)
      {
         var _loc3_ = o[_loc16_];
         if(_loc3_.label != undefined && typeof _loc3_.label == "string")
         {
            this._oElements.label = _loc3_.label;
         }
         var _loc5_ = undefined;
         var _loc7_ = undefined;
         var _loc8_ = Boolean(typeof _loc3_.action == "object" && !(_loc3_.action instanceof Array));
         if(_loc8_ == true)
         {
            _loc5_ = _loc3_.action;
            _loc7_ = {delay:_loc3_.delay,target:_loc3_.target,addTarget:_loc3_.addTarget,label:_loc3_.label,trigger:_loc3_.trigger};
         }
         else
         {
            _loc5_ = _loc3_;
         }
         var _loc4_ = this.parseProfile(_loc5_,_loc7_);
         if(_loc4_ != undefined)
         {
            this._aProfiles.unshift(_loc4_);
         }
      }
      this._sImage = "";
      var _loc15_ = "";
      if(this._oElements.label != undefined)
      {
         _loc15_ += "label:\"" + this._oElements.label + "\", ";
      }
      if(this._oTemps.afl > 0)
      {
         _loc15_ += this._oTemps.afl <= 1 ? "callback, " : this._oTemps.afl + " callbacks, ";
      }
      if(this._oElements.delay != undefined || this._oTemps.twDelayFlag == true)
      {
         _loc15_ += "delay, ";
      }
      if(this._oTemps.bTriggerFound == true)
      {
         _loc15_ += "trigger, ";
      }
      if(this._oTemps.ael > 0)
      {
         _loc15_ += this._oTemps.ael <= 1 ? "event, " : this._oTemps.ael + " events, ";
      }
      if(_loc15_ != "")
      {
         this._sImage += " Elements:[" + _loc15_.slice(0,-2) + "]";
      }
      if(this._oTemps.sImgS != "")
      {
         this._sImage += " StartProps:[" + this._oTemps.sImgS.slice(0,-2) + "]";
      }
      if(this._oTemps.sImgE != "")
      {
         this._sImage += " Props:[" + this._oTemps.sImgE.slice(0,-2) + "]";
      }
      if(this._oTemps.sImgB != "")
      {
         this._sImage += " Simple Syntax Props:[" + this._oTemps.sImgB.slice(0,-1) + "]";
      }
      delete this._oTemps;
   }
   static function doTween()
   {
      for(var _loc3_ in arguments)
      {
         if(typeof arguments[_loc3_] == "object")
         {
            if(com.mosesSupposes.fuse.FuseItem._aInstances == undefined)
            {
               com.mosesSupposes.fuse.FuseItem._aInstances = new Array();
            }
            var _loc2_ = new com.mosesSupposes.fuse.FuseItem(com.mosesSupposes.fuse.FuseItem._aInstances.length,arguments[_loc3_],-1);
            return _loc2_.startItem();
         }
      }
   }
   function getLabel()
   {
      return this._oElements.label;
   }
   function hasTriggerFired()
   {
      return this._bTrigger == true;
   }
   function getInitObj()
   {
      return this._initObj;
   }
   function getActiveTargets(targetList)
   {
      if(this._aTweens.length <= 0)
      {
         return targetList;
      }
      var _loc3_ = false;
      for(var _loc5_ in this._aTweens)
      {
         for(var _loc4_ in targetList)
         {
            if(targetList[_loc4_] == this._aTweens[_loc5_].targ)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_ == false)
         {
            targetList.unshift(this._aTweens[_loc5_].targ);
         }
      }
      return targetList;
   }
   function toString()
   {
      return String(this._sID() + ":" + this._sImage);
   }
   function evalDelay(scope)
   {
      var _loc3_ = this._oElements.delay;
      if(_loc3_ instanceof Function)
      {
         _loc3_ = _loc3_.apply(this._oElements.delayscope == undefined ? scope : this._oElements.delayscope);
      }
      if(typeof _loc3_ == "string")
      {
         _loc3_ = this.parseClock(String(_loc3_));
      }
      if(_global.isNaN(Number(_loc3_)) == true)
      {
         return 0;
      }
      return Number(_loc3_);
   }
   function startItem(targs, scope)
   {
      com.mosesSupposes.fuse.FuseItem._ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
      var _loc10_ = _global.com.mosesSupposes.fuse.Fuse;
      var _loc5_ = _loc10_ == undefined ? com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL : _loc10_.OUTPUT_LEVEL;
      if(this._oElements.command != null)
      {
         var _loc12_ = "|start|stop|pause|resume|skipTo|setStartProps|";
         var _loc11_ = this._oElements.scope || scope;
         var _loc8_ = !(this._oElements.command instanceof Function) ? String(this._oElements.command) : String(this._oElements.command.apply(_loc11_));
         var _loc6_ = !(this._oElements.args instanceof Function) ? this._oElements.args : this._oElements.args.apply(_loc11_);
         if(_loc12_.indexOf("|" + _loc8_ + "|") == -1 || _loc8_ == "skipTo" && _loc6_ == undefined)
         {
            if(_loc5_ > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("111",_loc8_);
            }
         }
         else
         {
            this._nPlaying = 1;
            if(!(_loc6_ instanceof Array))
            {
               _loc6_ = _loc6_ != null ? [_loc6_] : [];
            }
            this.dispatchRequest(String(_loc8_),_loc6_);
         }
         return null;
      }
      if(this._aTweens.length > 0)
      {
         this.stop();
      }
      com.mosesSupposes.fuse.FuseItem._ZigoEngine.addListener(this);
      this._nPlaying = 2;
      var _loc4_ = null;
      if(this._aProfiles.length > 0)
      {
         if(com.mosesSupposes.fuse.FuseItem._ZigoEngine == undefined)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("112");
         }
         else
         {
            _loc4_ = this.doTweens(targs,scope,false);
         }
      }
      this._nPlaying = 1;
      var _loc3_ = this._oElements.aEvents;
      for(var _loc9_ in _loc3_)
      {
         if(!(_loc4_ == null && this._aTweens.length > 0 && _loc3_[_loc9_].skipLevel == 2))
         {
            this.fireEvents(_loc3_[_loc9_],scope,_loc5_);
         }
      }
      if(_loc4_ == null && this._aTweens.length <= 0 && this._nPlaying == 1)
      {
         if(_loc5_ == 3)
         {
            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no tweens added - item done. [getTimer()=" + getTimer() + "]");
         }
         this.complete();
      }
      return _loc4_;
   }
   function stop()
   {
      var _loc2_ = this._nPlaying > -1;
      this._nPlaying = -1;
      if(_loc2_ == true)
      {
         this.onStop();
      }
      com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeListener(this);
   }
   static function removeInstance(id)
   {
      com.mosesSupposes.fuse.FuseItem(com.mosesSupposes.fuse.FuseItem._aInstances[id]).destroy();
      delete com.mosesSupposes.fuse.FuseItem._aInstances[id];
   }
   function onStop()
   {
      this._bStartSet = false;
      for(var _loc3_ in this._aTweens)
      {
         var _loc2_ = this._aTweens[_loc3_];
         _loc2_.targ.removeListener(this);
         com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeTween(_loc2_.targ,_loc2_.props);
         delete this._aTweens[_loc3_];
      }
      delete this._aTweens;
      this._bTrigger = false;
   }
   function evtSetStart(o)
   {
      if(this._sImage.indexOf("StartProps:") == -1 || o.curIndex == this._nItemID)
      {
         return undefined;
      }
      if(o.all != true)
      {
         var _loc3_ = false;
         for(var _loc4_ in o.filter)
         {
            if(Number(o.filter[_loc4_]) == this._nItemID || String(o.filter[_loc4_]) == this._oElements.label)
            {
               _loc3_ = true;
            }
         }
         if(_loc3_ == false)
         {
            return undefined;
         }
      }
      this.doTweens(o.targs,o.scope,true);
      this._bStartSet = true;
   }
   function pause(resume)
   {
      if(this._nPlaying == -1)
      {
         return undefined;
      }
      this._nPlaying = resume != true ? 0 : 1;
      for(var _loc12_ in this._aTweens)
      {
         var _loc4_ = this._aTweens[_loc12_];
         var _loc2_ = _loc4_.targ;
         var _loc3_ = _loc4_.props;
         if(resume == true)
         {
            var _loc5_ = [];
            var _loc6_ = this._aTweens.length;
            for(var _loc8_ in _loc3_)
            {
               if(com.mosesSupposes.fuse.FuseItem._ZigoEngine.isTweenPaused(_loc2_,_loc3_[_loc8_]) == false)
               {
                  _loc5_.push(_loc3_[_loc8_]);
               }
            }
            if(_loc5_.length > 0)
            {
               this.onTweenEnd({__zigoID__:_loc4_.targZID,props:_loc5_,isResume:true});
            }
            if(this._aTweens.length == _loc6_)
            {
               _loc2_.addListener(this);
               com.mosesSupposes.fuse.FuseItem._ZigoEngine.unpauseTween(_loc2_,_loc4_.props);
            }
         }
         else
         {
            _loc2_.removeListener(this);
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.pauseTween(_loc2_,_loc4_.props);
         }
      }
      if(resume == true && this._aTweens.length <= 0)
      {
         this.complete();
      }
      else if(resume == true)
      {
         com.mosesSupposes.fuse.FuseItem._ZigoEngine.addListener(this);
      }
      else
      {
         com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeListener(this);
      }
   }
   function destroy()
   {
      var _loc3_ = this._nPlaying > -1;
      this._nPlaying = -1;
      for(var _loc5_ in this._aTweens)
      {
         var _loc2_ = this._aTweens[_loc5_];
         _loc2_.targ.removeListener(this);
         if(_loc3_ == true)
         {
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeTween(_loc2_.targ,_loc2_.props);
         }
         delete this._aTweens[_loc5_];
      }
      for(var _loc4_ in this)
      {
         delete this[_loc4_];
      }
   }
   function dispatchRequest(type, args)
   {
      var _loc4_ = _global.com.mosesSupposes.fuse.Fuse.getInstance(this._nFuseID);
      if(!(args instanceof Array) && args != null)
      {
         args = new Array(args);
      }
      Function(_loc4_[type]).apply(_loc4_,args);
   }
   function _sID()
   {
      var _loc3_ = undefined;
      if(this._nFuseID == -1)
      {
         _loc3_ = "One-off tween ";
      }
      else
      {
         var _loc4_ = _global.com.mosesSupposes.fuse.Fuse.getInstance(this._nFuseID);
         _loc3_ = "Fuse#" + String(this._nFuseID);
         if(_loc4_.label != undefined)
         {
            _loc3_ += ":\"" + _loc4_.label + "\"";
         }
      }
      _loc3_ += ">Item#" + String(this._nItemID);
      if(this._oElements.label != undefined)
      {
         _loc3_ += ":\"" + this._oElements.label + "\"";
      }
      return _loc3_;
   }
   function parseProfile(obj, aap)
   {
      var _loc39_ = undefined;
      var _loc2_ = undefined;
      var _loc8_ = undefined;
      if(obj.__buildMode == true)
      {
         if(obj.command != undefined)
         {
            if(obj.command == "delay")
            {
               this._oElements.delay = obj.commandargs;
            }
            else
            {
               this._oElements.command = obj.command;
               this._oElements.args = obj.commandargs;
            }
         }
         if(obj.func != undefined)
         {
            this._oTemps.afl = this._oTemps.afl + 1;
            this._oElements.aEvents.unshift({f:obj.func,s:obj.scope,a:obj.args});
         }
         if(obj.tweenargs != undefined)
         {
            this._oTemps.sImgB += obj.tweenargs[1].toString() + ",";
            return obj;
         }
         return null;
      }
      var _loc3_ = {delay:(aap.delay == undefined ? obj.delay : aap.delay),ease:obj.ease,seconds:obj.seconds,event:obj.event,eventparams:obj.eventparams,skipLevel:(!(typeof obj.skipLevel == "number" && obj.skipLevel >= 0 && obj.skipLevel <= 2) ? com.mosesSupposes.fuse.FuseItem._ZigoEngine.SKIP_LEVEL : obj.skipLevel),oSP:{},oEP:{},oAFV:{}};
      var _loc22_ = aap.trigger == undefined ? obj.trigger : aap.trigger;
      if(_loc22_ != undefined)
      {
         if(this._oTemps.bTriggerFound == false)
         {
            _loc3_.trigger = _loc22_;
            this._oTemps.bTriggerFound = true;
         }
         else if(this._oTemps.outputLevel > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("126",this._sID(),_loc22_);
         }
      }
      if(_loc3_.delay == undefined)
      {
         _loc3_.delay = obj.startAt;
      }
      if(_loc3_.ease == undefined)
      {
         _loc3_.ease = obj.easing;
      }
      if(_loc3_.seconds == undefined)
      {
         _loc3_.seconds = obj.duration == undefined ? obj.time : obj.duration;
      }
      if(aap.target != undefined)
      {
         _loc3_.target = !(aap.target instanceof Array) ? [aap.target] : aap.target;
      }
      else if(obj.target != undefined)
      {
         _loc3_.target = !(obj.target instanceof Array) ? [obj.target] : obj.target;
      }
      if(obj.addTarget != undefined)
      {
         _loc3_.addTarget = !(obj.addTarget instanceof Array) ? [obj.addTarget] : obj.addTarget;
      }
      if(aap.addTarget != undefined)
      {
         if(_loc3_.addTarget == undefined)
         {
            _loc3_.addTarget = !(aap.addTarget instanceof Array) ? [aap.addTarget] : aap.addTarget;
         }
         else
         {
            _loc3_.addTarget = !(_loc3_.addTarget instanceof Array) ? new Array(_loc3_.addTarget).concat(aap.addTarget) : _loc3_.addTarget.concat(aap.addTarget);
         }
      }
      var _loc15_ = false;
      for(_loc2_ in obj)
      {
         var _loc9_ = obj[_loc2_];
         if(this._oTemps.cbProps.indexOf("|" + _loc2_ + "|") > -1)
         {
            if(_loc2_ != "skipLevel")
            {
               _loc3_[_loc2_] = _loc9_;
            }
         }
         else if(this._oTemps.fuseProps.indexOf("|" + _loc2_ + "|") > -1)
         {
            if(_loc2_ == "command" && this._oTemps.nActions > 1 && this._oTemps.outputLevel > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("114",String(_loc9_));
            }
         }
         else
         {
            if(typeof _loc9_ == "object")
            {
               var _loc11_ = !(_loc9_ instanceof Array) ? {} : [];
               for(_loc8_ in _loc9_)
               {
                  _loc11_[_loc8_] = _loc9_[_loc8_];
               }
               _loc9_ = _loc11_;
            }
            var _loc4_ = undefined;
            var _loc21_ = undefined;
            if(_loc2_.indexOf("start") == 0)
            {
               _loc2_ = _loc2_.slice(6);
               _loc4_ = _loc3_.oSP;
            }
            else
            {
               _loc4_ = _loc3_.oEP;
            }
            if(com.mosesSupposes.fuse.FuseItem.ADD_UNDERSCORES == true && this._oTemps.sUP.indexOf("|_" + _loc2_ + "|") > -1)
            {
               _loc2_ = "_" + _loc2_;
            }
            if(this._oTemps.sCT.indexOf("|" + _loc2_ + "|") > -1)
            {
               var _loc13_ = _loc2_ == "_tintPercent" && _loc4_.colorProp.p == "_tint";
               var _loc12_ = _loc2_ == "_tint" && _loc4_.colorProp.p == "_tintPercent";
               if(_loc4_.colorProp == undefined || _loc13_ == true || _loc12_ == true)
               {
                  if(_loc13_ == true)
                  {
                     _loc4_.colorProp = {p:"_tint",v:{tint:_loc4_.colorProp.v,percent:_loc9_}};
                  }
                  else if(_loc12_ == true)
                  {
                     _loc4_.colorProp = {p:"_tint",v:{tint:_loc9_,percent:_loc4_.colorProp.v}};
                  }
                  else
                  {
                     _loc4_.colorProp = {p:_loc2_,v:_loc9_};
                  }
                  _loc15_ = true;
               }
               else if(this._oTemps.outputLevel > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("115",this._sID(),_loc2_);
               }
            }
            else if(_loc9_ != null)
            {
               if(_loc4_ == _loc3_.oEP && (obj.controlX != undefined || obj.controlY != undefined) && (_loc2_.indexOf("control") == 0 || _loc2_ == "_x" || _loc2_ == "_y"))
               {
                  if(_loc4_._bezier_ == undefined)
                  {
                     _loc4_._bezier_ = {};
                  }
                  if(_loc2_.indexOf("control") == 0)
                  {
                     _loc4_._bezier_[_loc2_] = _loc9_;
                  }
                  else
                  {
                     _loc4_._bezier_[_loc2_.charAt(1)] = _loc9_;
                  }
               }
               else
               {
                  _loc4_[_loc2_] = _loc9_;
               }
               _loc15_ = true;
            }
         }
      }
      if(_loc15_ == false && (_loc3_.trigger != undefined || (_loc3_.delay != undefined || _loc3_.seconds != undefined) && (_loc3_.startfunc != undefined || _loc3_.updfunc != undefined || _loc3_.func != undefined && this._oTemps.nActions > 1)))
      {
         if(com.mosesSupposes.fuse.FuseItem._ZigoEngine != undefined)
         {
            if(_loc3_.func != undefined)
            {
               this._oTemps.afl = this._oTemps.afl + 1;
            }
            if(_loc3_.event != undefined)
            {
               this._oTemps.ael = this._oTemps.ael + 1;
            }
            _loc3_._doTimer = true;
            if(_loc3_.delay != undefined)
            {
               this._oTemps.twDelayFlag = true;
            }
            return _loc3_;
         }
         com.mosesSupposes.fuse.FuseKitCommon.error("116");
      }
      if(_loc15_ == true)
      {
         var _loc17_ = _loc3_.oEP.colorProp != undefined;
         var _loc7_ = 0;
         while(_loc7_ < 2)
         {
            _loc4_ = _loc7_ != 0 ? _loc3_.oEP : _loc3_.oSP;
            var _loc6_ = _loc7_ != 0 ? this._oTemps.sImgE : this._oTemps.sImgS;
            var _loc10_ = _loc4_.colorProp.p;
            if(_loc10_ != undefined)
            {
               _loc4_[_loc10_] = _loc4_.colorProp.v;
               delete _loc4_.colorProp;
            }
            if((_loc4_._xscale != undefined || _loc4_._scale != undefined) && (_loc4_._width != undefined || _loc4_._size != undefined))
            {
               var _loc14_ = _loc4_._xscale == undefined ? "_scale" : "_xscale";
               delete _loc4_[_loc14_];
               if(this._oTemps.outputLevel > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("115",this._sID(),_loc14_);
               }
            }
            if((_loc4_._yscale != undefined || _loc4_._scale != undefined) && (_loc4_._height != undefined || _loc4_._size != undefined))
            {
               _loc14_ = _loc4_._yscale == undefined ? "_scale" : "_yscale";
               delete _loc4_[_loc14_];
               if(this._oTemps.outputLevel > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("115",this._sID(),_loc14_);
               }
            }
            for(_loc2_ in _loc4_)
            {
               if(_loc6_.indexOf(_loc2_ + ", ") == -1)
               {
                  _loc6_ += _loc2_ + ", ";
               }
               if(_loc4_ == _loc3_.oSP)
               {
                  if(_loc3_.oEP[_loc2_] == undefined && !(_loc2_ == _loc10_ && _loc17_ == true))
                  {
                     _loc3_.oAFV[_loc2_] = true;
                     _loc3_.oEP[_loc2_] = [];
                  }
               }
            }
            _loc7_ != 0 ? (this._oTemps.sImgE = _loc6_) : (this._oTemps.sImgS = _loc6_);
            _loc7_ = _loc7_ + 1;
         }
         return _loc3_;
      }
      if(_loc3_.delay != undefined && this._oTemps.nActions == 1)
      {
         this._oElements.delay = _loc3_.delay;
         this._oElements.delayscope = _loc3_.scope;
      }
      if(_loc3_.event != undefined)
      {
         this._oTemps.ael = this._oTemps.ael + 1;
         this._oElements.aEvents.unshift({e:_loc3_.event,s:_loc3_.scope,ep:_loc3_.eventparams,skipLevel:_loc3_.skipLevel});
      }
      var _loc23_ = this._oElements.aEvents.length;
      if(_loc3_.easyfunc != undefined)
      {
         this._oElements.aEvents.push({cb:_loc3_.easyfunc,s:_loc3_.scope,skipLevel:_loc3_.skipLevel});
      }
      if(_loc3_.func != undefined)
      {
         this._oElements.aEvents.push({f:_loc3_.func,s:_loc3_.scope,a:_loc3_.args,skipLevel:_loc3_.skipLevel});
      }
      this._oTemps.afl += this._oElements.aEvents.length - _loc23_;
      false;
      return undefined;
   }
   function doTweens(targs, defaultScope, setStart)
   {
      if(this._aTweens == null)
      {
         this._aTweens = [];
      }
      var _loc66_ = _global.com.mosesSupposes.fuse.Fuse;
      var _loc19_ = _loc66_ == undefined ? com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL : _loc66_.OUTPUT_LEVEL;
      var _loc27_ = "";
      var _loc65_ = 0;
      var _loc7_ = undefined;
      var _loc6_ = undefined;
      var _loc4_ = undefined;
      if(this._aProfiles[0].__buildMode == true)
      {
         var _loc48_ = 0;
         while(_loc48_ < this._aProfiles.length)
         {
            var _loc29_ = this._aProfiles[_loc48_].tweenargs;
            if(_loc29_[6].cycles === 0 || _loc29_[6].cycles.toUpperCase() == "LOOP")
            {
               delete _loc29_[6].cycles;
               if(_loc19_ > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("117",this._sID());
               }
            }
            var _loc31_ = com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween.apply(com.mosesSupposes.fuse.FuseItem._ZigoEngine,_loc29_);
            var _loc15_ = _loc31_ != null ? _loc31_.split(",") : [];
            if(_loc15_.length > 0)
            {
               this._aTweens.push({targ:_loc29_[0],props:_loc15_,targZID:_loc29_[0].__zigoID__});
               _loc29_[0].addListener(this);
               for(_loc6_ in _loc15_)
               {
                  if(_loc27_.indexOf(_loc15_[_loc6_] + ",") == -1)
                  {
                     _loc27_ += _loc15_[_loc6_] + ",";
                  }
               }
            }
            if(_loc19_ == 3)
            {
               com.mosesSupposes.fuse.FuseKitCommon.output("\n-" + this._sID() + " TWEEN (simple syntax)\n\ttargets:[" + _loc29_[0] + "]\n\tprops sent:[" + _loc29_[1] + "]");
            }
            _loc48_ = _loc48_ + 1;
         }
         return _loc27_ != "" ? _loc27_.slice(0,-1) : null;
      }
      var _loc67_ = this._bStartSet != true && (setStart == true || this._sImage.indexOf("StartProps:") > -1);
      _loc48_ = 0;
      for(; _loc48_ < this._aProfiles.length; _loc48_ = _loc48_ + 1)
      {
         var _loc3_ = this._aProfiles[_loc48_];
         var _loc9_ = defaultScope;
         if(_loc3_.scope != undefined)
         {
            _loc9_ = !(_loc3_.scope instanceof Function) ? _loc3_.scope : _loc3_.scope.apply(_loc9_);
         }
         var _loc20_ = undefined;
         if(_loc3_.event != undefined)
         {
            var _loc45_ = !(_loc3_.event instanceof Function) ? _loc3_.event : _loc3_.event.apply(_loc9_);
            var _loc56_ = !(_loc3_.eventparams instanceof Function) ? _loc3_.eventparams : _loc3_.eventparams.apply(_loc9_);
            if(_loc45_ != undefined && _loc45_.length > 0)
            {
               _loc20_ = {e:_loc45_,ep:_loc56_,s:_loc9_};
            }
         }
         var _loc51_ = !(_loc3_.skipLevel instanceof Function) ? _loc3_.skipLevel : _loc3_.skipLevel.apply(_loc9_);
         var _loc33_ = {skipLevel:_loc51_};
         var _loc8_ = {skipLevel:_loc51_};
         if(_loc3_.cycles != undefined)
         {
            var _loc46_ = !(_loc3_.cycles instanceof Function) ? _loc3_.cycles : _loc3_.cycles.apply(_loc9_);
            if((Number(_loc46_) == 0 || String(_loc46_).toUpperCase() == "LOOP") && _loc66_ != undefined)
            {
               delete _loc3_.cycles;
               if(_loc19_ > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("117",this._sID());
               }
            }
            else
            {
               _loc33_.cycles = _loc8_.cycles = _loc46_;
            }
         }
         var _loc37_ = "";
         if(_loc3_.easyfunc != undefined || _loc3_.func != undefined || _loc3_.startfunc != undefined || _loc3_.updfunc != undefined)
         {
            for(_loc7_ in _loc3_)
            {
               if(_loc7_.indexOf("func") > -1)
               {
                  _loc8_[_loc7_] = _loc3_[_loc7_];
               }
               else if(_loc7_ == "startscope" || _loc7_ == "updscope" || _loc7_.indexOf("args") > -1)
               {
                  _loc8_[_loc7_] = !(_loc3_[_loc7_] instanceof Function) ? _loc3_[_loc7_] : Function(_loc3_[_loc7_]).apply(_loc9_);
               }
            }
            if(_loc9_ != undefined)
            {
               if(_loc8_.func != undefined && _loc8_.scope == undefined)
               {
                  _loc8_.scope = _loc9_;
               }
               if(_loc8_.updfunc != undefined && _loc8_.updscope == undefined)
               {
                  _loc8_.updscope = _loc9_;
               }
               if(_loc8_.startfunc != undefined && _loc8_.startscope == undefined)
               {
                  _loc8_.startscope = _loc9_;
               }
            }
         }
         for(_loc6_ in _loc8_)
         {
            _loc37_ += _loc6_ + ":" + _loc8_[_loc6_] + "|";
         }
         var _loc42_ = _loc3_.trigger === true;
         var _loc17_ = undefined;
         if(_loc42_ == false && _loc3_.trigger != undefined)
         {
            _loc17_ = !(_loc3_.trigger instanceof Function) ? _loc3_.trigger : _loc3_.trigger.apply(_loc9_);
            if(typeof _loc17_ == "string")
            {
               _loc17_ = String(_loc17_).charAt(0) != "-" ? this.parseClock(String(_loc17_)) : - this.parseClock(String(_loc17_).slice(1));
            }
            if(_global.isNaN(_loc17_) == true)
            {
               _loc17_ = undefined;
            }
         }
         var _loc12_ = [];
         var _loc43_ = _loc3_.target != undefined ? _loc3_.target : targs;
         var _loc21_ = [];
         var _loc47_ = false;
         for(_loc7_ in _loc43_)
         {
            var _loc5_ = _loc43_[_loc7_];
            _loc21_ = _loc21_.concat(!(_loc5_ instanceof Function) ? _loc5_ : _loc5_.apply(_loc9_));
         }
         for(_loc7_ in _loc3_.addTarget)
         {
            _loc5_ = _loc3_.addTarget[_loc7_];
            _loc21_ = _loc21_.concat(!(_loc5_ instanceof Function) ? _loc5_ : _loc5_.apply(_loc9_));
         }
         for(_loc7_ in _loc21_)
         {
            _loc5_ = _loc21_[_loc7_];
            if(_loc5_ != null)
            {
               var _loc35_ = false;
               for(_loc6_ in _loc12_)
               {
                  if(_loc12_[_loc6_] == _loc5_)
                  {
                     _loc35_ = true;
                     break;
                  }
               }
               if(_loc35_ == false)
               {
                  _loc12_.unshift(_loc5_);
               }
            }
            else
            {
               _loc47_ = true;
            }
         }
         var _loc52_ = _loc12_.length == 0 && _loc3_._doTimer != true;
         var _loc49_ = _loc3_._doTimer == true && _loc12_.length == 0;
         if(_loc47_ == true || _loc52_ == true)
         {
            _loc65_ = _loc65_ + 1;
            if(_loc52_ == true)
            {
               continue;
            }
         }
         if(_loc67_ == true)
         {
            for(_loc7_ in _loc12_)
            {
               var _loc30_ = _loc12_[_loc7_];
               var _loc28_ = [];
               var _loc23_ = [];
               if(setStart == true)
               {
                  for(var _loc57_ in _loc3_.oEP)
                  {
                     _global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(_loc30_,_loc57_,true);
                  }
               }
               for(var _loc58_ in _loc3_.oSP)
               {
                  _loc5_ = _loc3_.oSP[_loc58_];
                  if(_loc5_ instanceof Function)
                  {
                     _loc5_ = _loc5_.apply(_loc9_);
                  }
                  if(_loc5_ === true || _loc5_ === false)
                  {
                     _loc30_[_loc58_] = _loc5_;
                     if(_loc3_.oAFV[_loc58_] == true)
                     {
                        for(_loc4_ in _loc3_.oEP[_loc58_])
                        {
                           if(_loc3_.oEP[_loc58_][_loc4_].targ == _loc30_)
                           {
                              _loc3_.oEP[_loc58_].splice(Number(_loc4_),1);
                           }
                        }
                        _loc3_.oEP[_loc58_].push({targ:_loc30_,val:"IGNORE"});
                     }
                  }
                  else
                  {
                     if(_loc3_.oAFV[_loc58_] == true && !(_loc58_ == "_colorReset" && _loc5_ == 100) && !(_loc58_ == "_tintPercent" && _loc5_ == 0))
                     {
                        var _loc16_ = undefined;
                        if(_loc58_ == "_tint" || _loc58_ == "_colorTransform")
                        {
                           _loc16_ = com.mosesSupposes.fuse.FuseItem._ZigoEngine.getColorTransObj();
                        }
                        else if("|_alpha|_contrast|_invertColor|_tintPercent|_xscale|_yscale|_scale|".indexOf("|" + _loc58_ + "|") > -1)
                        {
                           _loc16_ = 100;
                        }
                        else if("|_brightness|_brightOffset|_colorReset|_rotation|".indexOf("|" + _loc58_ + "|") > -1)
                        {
                           _loc16_ = 0;
                        }
                        else
                        {
                           var _loc25_ = _global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(_loc30_,_loc58_,true);
                           if(_loc25_ != null)
                           {
                              _loc16_ = _loc25_;
                           }
                           else
                           {
                              _loc16_ = _global.isNaN(_loc30_[_loc58_]) != false ? 0 : _loc30_[_loc58_];
                           }
                        }
                        for(_loc4_ in _loc3_.oEP[_loc58_])
                        {
                           if(_loc3_.oEP[_loc58_][_loc4_].targ == _loc30_)
                           {
                              _loc3_.oEP[_loc58_].splice(Number(_loc4_),1);
                           }
                        }
                        _loc3_.oEP[_loc58_].push({targ:_loc30_,val:_loc16_});
                     }
                     if(typeof _loc5_ == "object")
                     {
                        var _loc24_ = !(_loc5_ instanceof Array) ? {} : [];
                        for(_loc4_ in _loc5_)
                        {
                           _loc24_[_loc4_] = !(_loc5_[_loc4_] instanceof Function) ? _loc5_[_loc4_] : Function(_loc5_[_loc4_]).apply(_loc9_);
                        }
                        _loc5_ = _loc24_;
                     }
                     _loc28_.push(_loc58_);
                     _loc23_.push(_loc5_);
                  }
               }
               if(_loc23_.length > 0)
               {
                  if(_loc19_ == 3)
                  {
                     com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " " + _loc30_ + " SET STARTS: " + ["[" + _loc28_ + "]","[" + _loc23_ + "]"]);
                  }
                  com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc30_,_loc28_,_loc23_,0);
               }
            }
         }
         if(setStart != true)
         {
            var _loc10_ = undefined;
            var _loc13_ = undefined;
            var _loc11_ = undefined;
            var _loc36_ = false;
            var _loc44_ = _loc49_ != false ? [0] : _loc12_;
            for(_loc7_ in _loc44_)
            {
               var _loc18_ = _loc3_.ease;
               if(_loc18_ instanceof Function)
               {
                  var _loc38_ = Function(_loc18_);
                  if(typeof _loc38_(1,1,1,1) != "number")
                  {
                     _loc18_ = _loc38_.apply(_loc9_);
                  }
               }
               _loc10_ = !(_loc3_.seconds instanceof Function) ? _loc3_.seconds : _loc3_.seconds.apply(_loc9_);
               if(_loc10_ != undefined)
               {
                  if(typeof _loc10_ == "string")
                  {
                     _loc10_ = this.parseClock(String(_loc10_));
                  }
                  if(_global.isNaN(_loc10_) == true)
                  {
                     _loc10_ = com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION || 0;
                  }
               }
               _loc13_ = !(_loc3_.delay instanceof Function) ? _loc3_.delay : _loc3_.delay.apply(_loc9_);
               if(typeof _loc13_ == "string")
               {
                  _loc13_ = this.parseClock(String(_loc13_));
               }
               if(_loc13_ == null || _global.isNaN(_loc13_) == true)
               {
                  _loc13_ = 0;
               }
               if(_loc49_ != true)
               {
                  _loc30_ = _loc44_[_loc7_];
                  var _loc22_ = [];
                  var _loc14_ = [];
                  var _loc40_ = 0;
                  for(_loc58_ in _loc3_.oEP)
                  {
                     _loc5_ = _loc3_.oEP[_loc58_];
                     if(_loc5_ instanceof Function)
                     {
                        _loc5_ = _loc5_.apply(_loc9_);
                     }
                     if(_loc5_ === true || _loc5_ === false)
                     {
                        if(_loc11_ == undefined)
                        {
                           _loc11_ = {};
                        }
                        _loc11_[_loc58_] = _loc5_;
                        _loc40_ = _loc40_ + 1;
                     }
                     else
                     {
                        if(typeof _loc5_ == "object")
                        {
                           if(_loc5_[0].targ != undefined)
                           {
                              for(_loc4_ in _loc5_)
                              {
                                 if(_loc5_[_loc4_].targ == _loc30_)
                                 {
                                    _loc5_ = _loc5_[_loc4_].val;
                                    break;
                                 }
                              }
                           }
                           else
                           {
                              _loc24_ = !(_loc5_ instanceof Array) ? {} : [];
                              for(_loc4_ in _loc5_)
                              {
                                 _loc24_[_loc4_] = !(_loc5_[_loc4_] instanceof Function) ? _loc5_[_loc4_] : Function(_loc5_[_loc4_]).apply(_loc9_);
                              }
                              _loc5_ = _loc24_;
                           }
                        }
                        if(_loc5_ != "IGNORE")
                        {
                           _loc22_.push(_loc58_);
                           _loc14_.push(_loc5_);
                        }
                     }
                  }
                  _loc15_ = [];
                  if(_loc14_.length > 0)
                  {
                     _loc31_ = com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc30_,_loc22_,_loc14_,_loc10_,_loc18_,_loc13_,_loc8_);
                     if(_loc31_ != null)
                     {
                        _loc15_ = _loc31_.split(",");
                     }
                     if(_loc15_.length > 0)
                     {
                        var _loc32_ = {targ:_loc30_,props:_loc15_,bools:_loc11_,targZID:_loc30_.__zigoID__};
                        if(_loc36_ == false)
                        {
                           _loc8_ = _loc33_;
                           _loc32_.event = _loc20_;
                           _loc20_ = _loc11_ = undefined;
                           _loc32_.trigger = _loc42_;
                        }
                        this._aTweens.push(_loc32_);
                        _loc30_.addListener(this);
                        _loc36_ = true;
                     }
                     for(_loc6_ in _loc15_)
                     {
                        if(_loc27_.indexOf(_loc15_[_loc6_] + ",") == -1)
                        {
                           _loc27_ += _loc15_[_loc6_] + ",";
                        }
                     }
                     if(_loc19_ == 3)
                     {
                        var _loc39_ = _loc22_.toString();
                        if(_loc15_.length > _loc22_.length)
                        {
                           _loc39_ += "\n\t[NO-CHANGE PROPS DISCARDED. KEPT:" + _loc31_ + "]";
                        }
                        var _loc26_ = "";
                        for(_loc6_ in _loc14_)
                        {
                           _loc26_ = (typeof _loc14_[_loc6_] != "string" ? _loc14_[_loc6_] : "\"" + _loc14_[_loc6_] + "\"") + ", " + _loc26_;
                        }
                        com.mosesSupposes.fuse.FuseKitCommon.output("\n-" + this._sID() + " TWEEN:\n" + ["\t[getTimer():" + getTimer() + "] ","targ: " + _loc30_,"props: " + _loc39_,"endVals: " + _loc26_,"time: " + (_loc10_ != undefined ? _loc10_ : com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION),"easing: " + (_loc18_ != undefined ? _loc18_ : com.mosesSupposes.fuse.FuseItem._ZigoEngine.EASING),"delay: " + (_loc13_ != undefined ? _loc13_ : 0),"callbacks: " + (_loc37_ != "" ? _loc37_ : "(none)")].join("\n\t"));
                     }
                  }
               }
            }
            if(_loc10_ == undefined || _global.isNaN(_loc10_) == true)
            {
               _loc10_ = 0;
            }
            var _loc34_ = _loc13_ + _loc10_;
            if(_loc17_ != undefined)
            {
               if(_loc17_ < 0)
               {
                  _loc17_ += _loc34_;
               }
               if(_loc17_ > 0 && (_loc34_ == 0 || _loc17_ < _loc34_))
               {
                  if(_loc34_ == 0)
                  {
                     if(_loc19_ == 3)
                     {
                        com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " graft a timed trigger (" + _loc17_ + " sec). [has callback:" + (_loc8_ != _loc33_) + ", has event:" + (_loc20_ != undefined) + ", has booleans:" + (_loc11_ != undefined) + "]");
                     }
                     this.doTimerTween(null,_loc17_,0,true,_loc11_,_loc8_,_loc20_);
                     _loc36_ = true;
                  }
                  else
                  {
                     if(_loc19_ == 3)
                     {
                        com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " graft a timed trigger (" + _loc17_ + " sec).");
                     }
                     this.doTimerTween(null,_loc17_,0,true);
                  }
               }
               else if(_loc19_ == 3)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " timed trigger discarded: out of range. [" + _loc17_ + "/" + _loc34_ + "]");
               }
            }
            if(_loc36_ == false && (_loc8_ != _loc33_ || _loc20_ != undefined || _loc11_ != undefined))
            {
               if(_loc51_ == 0 && _loc34_ > 0)
               {
                  if(_loc19_ == 3)
                  {
                     com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no props tweened - graft a delay (" + _loc34_ + " sec). [has callback:" + (_loc8_ != _loc33_) + ", has event:" + (_loc20_ != undefined) + ", has booleans:" + (_loc11_ != undefined) + "]");
                  }
                  this.doTimerTween(_loc12_,_loc10_,_loc13_,_loc42_,_loc11_,_loc8_,_loc20_);
               }
               else
               {
                  if(_loc19_ == 3)
                  {
                     com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no props tweened, executing nontween items. [has callback:" + (_loc8_ != _loc33_) + ", has event:" + (_loc20_ != undefined) + ", has booleans:" + (_loc11_ != undefined) + "]");
                  }
                  for(_loc7_ in _loc12_)
                  {
                     for(_loc6_ in _loc11_)
                     {
                        _loc12_[_loc7_][_loc6_] = _loc11_[_loc6_];
                     }
                  }
                  if(_loc51_ < 2)
                  {
                     if(_loc8_ != undefined)
                     {
                        if(_loc8_.startfunc != undefined)
                        {
                           this.fireEvents({f:_loc8_.startfunc,s:_loc8_.startscope,a:_loc8_.startargs},_loc9_,_loc19_);
                        }
                        if(_loc8_.updfunc != undefined)
                        {
                           this.fireEvents({f:_loc8_.updfunc,s:_loc8_.updscope,a:_loc8_.updargs},_loc9_,_loc19_);
                        }
                        if(_loc8_.startfunc != undefined || _loc8_.easyfunc != undefined)
                        {
                           this.fireEvents({f:_loc8_.func,s:_loc8_.scope,a:_loc8_.args,cb:_loc8_.easyfunc},_loc9_,_loc19_);
                        }
                     }
                     if(_loc20_ != undefined)
                     {
                        this.fireEvents(_loc20_);
                     }
                  }
               }
            }
         }
      }
      if(_loc65_ > 0 && _loc19_ > 0)
      {
         if(_loc65_ == this._aProfiles.length && _loc27_ == "")
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("118",this._sID(),setStart);
         }
         else
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("119",_loc67_,_loc65_,this._sID());
         }
      }
      return _loc27_ != "" ? _loc27_.slice(0,-1) : null;
   }
   function doTimerTween(actualTargets, duration, delay, trigger, booleans, callback, event)
   {
      var _loc2_ = {__TweenedDelay:0};
      com.mosesSupposes.fuse.FuseItem._ZigoEngine.initializeTargets(_loc2_);
      this._aTweens.push({targ:_loc2_,props:["__TweenedDelay"],trigger:trigger,bools:booleans,event:event,actualTargs:actualTargets,targZID:_loc2_.__zigoID__});
      com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc2_,"__TweenedDelay",1,duration,null,delay,callback);
      _loc2_.addListener(this);
   }
   function onTweenEnd(o)
   {
      if(this._nPlaying < 1)
      {
         return undefined;
      }
      var _loc16_ = _global.com.mosesSupposes.fuse.Fuse;
      var _loc7_ = _loc16_ == undefined ? com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL : _loc16_.OUTPUT_LEVEL;
      if(_loc7_ == 3)
      {
         com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " onTweenEnd: " + (typeof o.target != "movieclip" ? typeof o.target : o.target._name) + "[" + o.props + "] [getTimer()=" + getTimer() + "]");
      }
      var _loc14_ = o.__zigoID__ === undefined ? o.target.__zigoID__ : o.__zigoID__;
      for(var _loc15_ in this._aTweens)
      {
         var _loc3_ = this._aTweens[_loc15_];
         if(_loc3_.targZID == _loc14_)
         {
            for(var _loc13_ in o.props)
            {
               var _loc4_ = _loc3_.props;
               for(var _loc12_ in _loc4_)
               {
                  var _loc5_ = _loc4_[_loc12_];
                  if(_loc5_ == o.props[_loc13_])
                  {
                     if(this._nPlaying == 2)
                     {
                        if(_loc7_ > 0)
                        {
                           com.mosesSupposes.fuse.FuseKitCommon.error("120",this._sID(),_loc5_);
                        }
                     }
                     _loc4_.splice(Number(_loc12_),1);
                     if(_loc4_.length == 0)
                     {
                        if(_loc3_.event != undefined)
                        {
                           this.fireEvents(_loc3_.event,_loc3_.event.s,_loc7_);
                        }
                        if(_loc5_ == "__TweenedDelay")
                        {
                           com.mosesSupposes.fuse.FuseItem._ZigoEngine.deinitializeTargets(_loc3_.targ);
                           delete _loc3_.targ;
                           for(var _loc10_ in _loc3_.bools)
                           {
                              for(var _loc9_ in _loc3_.actualTargs)
                              {
                                 _loc3_.actualTargs[_loc9_][_loc10_] = _loc3_.bools[_loc10_];
                              }
                           }
                        }
                        else
                        {
                           var _loc6_ = false;
                           for(_loc10_ in _loc3_.bools)
                           {
                              _loc3_.targ[_loc10_] = _loc3_.bools[_loc10_];
                           }
                           for(var _loc11_ in this._aTweens)
                           {
                              if(_loc11_ != _loc15_ && this._aTweens[_loc11_].targ == _loc3_.targ)
                              {
                                 _loc6_ = true;
                              }
                           }
                           if(_loc6_ == false)
                           {
                              _loc3_.targ.removeListener(this);
                           }
                        }
                        if(_loc3_.trigger == true)
                        {
                           if(this._bTrigger == false && o.isResume != true && this._aTweens.length > 1)
                           {
                              this._bTrigger = true;
                              if(_loc7_ == 3)
                              {
                                 com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " trigger fired!");
                              }
                              var breakChainInt;
                              breakChainInt = setInterval(function(fi)
                              {
                                 clearInterval(breakChainInt);
                                 fi.dispatchRequest("advance",[false]);
                              }
                              ,1,this);
                           }
                        }
                        this._aTweens.splice(Number(_loc15_),1);
                     }
                  }
               }
            }
         }
      }
      if(this._aTweens.length == 0 && this._nPlaying == 1 && o.isResume != true)
      {
         this.complete(_loc7_);
      }
   }
   function onTweenInterrupt(o)
   {
      if(this._nPlaying == -1)
      {
         return undefined;
      }
      var _loc3_ = o.__zigoID__;
      var _loc7_ = _global.com.mosesSupposes.fuse.Fuse;
      var _loc6_ = _loc7_ == undefined ? com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL : _loc7_.OUTPUT_LEVEL;
      if(_loc6_ == 3)
      {
         com.mosesSupposes.fuse.FuseKitCommon.output(this._sID() + " property interrupt caught! " + o.target + ",__zigoID__:" + _loc3_ + "[" + o.props + "].");
      }
      if(_loc3_ == undefined || typeof o.target != "string")
      {
         this.onTweenEnd(o);
         return undefined;
      }
      for(var _loc4_ in this._aTweens)
      {
         if(this._aTweens[_loc4_].targZID == _loc3_)
         {
            this._aTweens.splice(Number(_loc4_),1);
         }
      }
      if(this._aTweens.length == 0 && this._nPlaying == 1)
      {
         this.complete(_loc6_);
      }
   }
   function complete(outputLevel)
   {
      var trigger = this._bTrigger;
      this.stop();
      if(trigger != true)
      {
         if(outputLevel == 3)
         {
            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " complete.");
         }
      }
      var breakChainInt;
      breakChainInt = setInterval(function(fi)
      {
         clearInterval(breakChainInt);
         fi.dispatchRequest("advance",[trigger]);
      }
      ,1,this);
   }
   function parseClock(str)
   {
      if(str.indexOf(":") != 2)
      {
         com.mosesSupposes.fuse.FuseKitCommon.error("121");
         return com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION || 0;
      }
      var _loc4_ = 0;
      var _loc3_ = str.split(":");
      _loc3_.reverse();
      var _loc2_ = undefined;
      if(String(_loc3_[0]).length == 2 && _global.isNaN(_loc2_ = Math.abs(Number(_loc3_[0]))) == false)
      {
         _loc4_ += _loc2_ / 100;
      }
      if(String(_loc3_[1]).length == 2 && _global.isNaN(_loc2_ = Math.abs(Number(_loc3_[1]))) == false && _loc2_ < 60)
      {
         _loc4_ += _loc2_;
      }
      if(String(_loc3_[2]).length == 2 && _global.isNaN(_loc2_ = Math.abs(Number(_loc3_[2]))) == false && _loc2_ < 60)
      {
         _loc4_ += _loc2_ * 60;
      }
      if(String(_loc3_[3]).length == 2 && _global.isNaN(_loc2_ = Math.abs(Number(_loc3_[3]))) == false && _loc2_ < 24)
      {
         _loc4_ += _loc2_ * 3600;
      }
      return _loc4_;
   }
   function fireEvents(o, scope, outputLevel)
   {
      var s = o.s == null ? scope : o.s;
      if(o.e == undefined)
      {
         if(typeof o.cb == "string" && o.cb.length > 0)
         {
            var parsed = _global.com.mosesSupposes.fuse.Shortcuts.parseStringTypeCallback(o.cb);
            if(parsed.func != undefined)
            {
               this.fireEvents({s:parsed.scope,f:parsed.func,a:parsed.args});
            }
            else if(outputLevel > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("122");
            }
         }
         if(o.f == undefined)
         {
            return undefined;
         }
         var f = o.f;
         if(typeof o.f == "string" && s[o.f] == undefined)
         {
            if(_global[o.f] != undefined)
            {
               f = _global[o.f];
            }
            if(_level0[o.f] != undefined)
            {
               f = _level0[o.f];
            }
         }
         if(typeof f != "function")
         {
            if(typeof s[o.f] == "function")
            {
               f = s[o.f];
            }
            else
            {
               f = eval(o.f);
            }
         }
         if(f == undefined)
         {
            if(outputLevel > 0)
            {
               com.mosesSupposes.fuse.FuseKitCommon.error("123");
            }
         }
         else
         {
            var args = !(o.a instanceof Function) ? o.a : o.a.apply(s);
            if(args != undefined && !(args instanceof Array))
            {
               args = [args];
            }
            f.apply(s,args);
         }
      }
      else
      {
         var type = !(o.e instanceof Function) ? String(o.e) : String(o.e.apply(s));
         if(type != "undefined" && type.length > 0)
         {
            if("|onStart|onStop|onPause|onResume|onAdvance|onComplete|".indexOf("|" + type + "|") > -1)
            {
               if(outputLevel > 0)
               {
                  com.mosesSupposes.fuse.FuseKitCommon.error("124",type);
               }
            }
            else
            {
               var fuse = _global.com.mosesSupposes.fuse.Fuse.getInstance(this._nFuseID);
               var evObj = !(o.ep instanceof Function) ? o.ep : o.ep.apply(s);
               if(evObj == null || typeof evObj != "object")
               {
                  evObj = {};
               }
               evObj.target = fuse;
               evObj.type = type;
               fuse.dispatchEvent.call(fuse,evObj);
            }
         }
         else if(outputLevel > 0)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("125",this._sID());
         }
      }
   }
}
