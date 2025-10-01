class com.mosesSupposes.fuse.FuseKitCommon
{
   static var logOutput;
   static var VERSION = "Fuse Kit 2.0 Copyright (c) 2006 Moses Gunesch, MosesSupposes.com under MIT Open Source License";
   static var VERBOSE = true;
   static var ALL = "ALL";
   static var ALLCOLOR = "ALLCOLOR";
   function FuseKitCommon()
   {
   }
   static function _cts()
   {
      return "|_tint|_tintPercent|_brightness|_brightOffset|_contrast|_invertColor|_colorReset|_colorTransform|";
   }
   static function _underscoreable()
   {
      return com.mosesSupposes.fuse.FuseKitCommon._cts() + "_frame|_x|_y|_xscale|_yscale|_scale|_width|_height|_size|_rotation|_alpha|_visible|";
   }
   static function _cbprops()
   {
      return "|skipLevel|cycles|easyfunc|func|scope|args|startfunc|startscope|startargs|updfunc|updscope|updargs|extra1|extra2|";
   }
   static function _fuseprops()
   {
      return "|command|label|delay|event|eventparams|target|addTarget|trigger|startAt|ease|easing|seconds|duration|time|";
   }
   static function output(s)
   {
      if(typeof com.mosesSupposes.fuse.FuseKitCommon.logOutput == "function")
      {
         com.mosesSupposes.fuse.FuseKitCommon.logOutput(s);
      }
      else
      {
         trace(s);
      }
   }
   static function error(errorCode)
   {
      var _loc3_ = arguments[1];
      var _loc5_ = arguments[2];
      var _loc6_ = arguments[3];
      if(com.mosesSupposes.fuse.FuseKitCommon.VERBOSE != true)
      {
         com.mosesSupposes.fuse.FuseKitCommon.output("[FuseKitCommon#" + errorCode + "]");
         return undefined;
      }
      var _loc2_ = "";
      var _loc4_ = "\n";
      switch(errorCode)
      {
         case "001":
            _loc2_ += "** ERROR: When using simpleSetup to extend prototypes, you must pass the Shortcuts class. **";
            _loc2_ += _loc4_ + " import com.mosesSupposes.fuse.*;";
            _loc2_ += _loc4_ + " ZigoEngine.simpleSetup(Shortcuts);" + _loc4_;
            break;
         case "002":
            _loc2_ += "** ZigoEngine.doShortcut: shortcuts missing. Use the setup commands: import com.mosesSupposes.fuse.*; ZigoEngine.register(Shortcuts); **";
            break;
         case "003":
            _loc2_ += _loc4_ + "*** Error: DO NOT use #include \"lmc_tween.as\" with this version of ZigoEngine! ***" + _loc4_;
            break;
         case "004":
            _loc2_ += "** ZigoEngine.doTween - too few arguments [" + _loc3_ + "]. If you are trying to use Object Syntax without Fuse, pass FuseItem in your register() or simpleSetup() call. **";
            break;
         case "005":
            _loc2_ += "** ZigoEngine.doTween - missing targets[" + _loc3_ + "] and/or props[" + _loc5_ + "] **";
            break;
         case "006":
            _loc2_ += "** Error: easing shortcut string not recognized (\"" + _loc3_ + "\"). You may need to pass the in PennerEasing class during register or simpleSetup. **";
            break;
         case "007":
            _loc2_ += "- ZigoEngine: Target locked [" + _loc3_ + "], ignoring tween call [" + _loc5_ + "]";
            break;
         case "008":
            _loc2_ += "** ZigoEngine: You must register the Shortcuts class in order to use easy string-type callback parsing. **";
            break;
         case "009":
            _loc2_ += "-ZigoEngine: A callback parameter \"" + _loc3_ + "\" was not recognized.";
            break;
         case "010":
            _loc2_ += "-Engine unable to parse " + (_loc3_ != 1 ? String(_loc3_) + " callbacks[" : "callback[") + _loc5_ + "]. Try using the syntax {scope:this, func:\"myFunction\"}";
            break;
         case "011":
            _loc2_ += "-ZigoEngine: Callbacks discarded via skipLevel 2 option [" + _loc3_ + "|" + _loc5_ + "].";
            break;
         case "012":
            _loc2_ += "-Engine set props or ignored no-change tween on: " + _loc3_ + ", props passed:[" + _loc5_ + "], endvals passed:[" + _loc6_ + "]";
            break;
         case "013":
            _loc2_ += "-Engine added tween on:\n\ttargets:[" + _loc3_ + "]\n\tprops:[" + _loc5_ + "]\n\tendvals:[" + _loc6_ + "]";
            break;
         case "014":
            _loc2_ += "** Error: easing function passed is not usable with this engine. Functions need to follow the Robert Penner model. **";
            break;
         case "101":
            _loc2_ += "** ERROR: Fuse simpleSetup was removed in version 2.0! **";
            _loc2_ += _loc4_ + " You must now use the following commands:";
            _loc2_ += _loc4_ + _loc4_ + "\timport com.mosesSupposes.fuse.*;";
            _loc2_ += _loc4_ + "\tZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);";
            _loc2_ += _loc4_ + "Note that PennerEasing is optional, and FuseFMP is also accepted. (FuseFMP.simpleSetup is run automatically if included.)" + _loc4_;
            break;
         case "102":
            _loc2_ += "** Fuse skipTo label not found: \"" + _loc3_ + "\" **";
            break;
         case "103":
            _loc2_ += "** Fuse skipTo failed (" + _loc3_ + ") **";
            break;
         case "104":
            _loc2_ += "** Fuse command skipTo (" + _loc3_ + ")  ignored - targets the current index (" + _loc5_ + "). **";
            break;
         case "105":
            _loc2_ += "** An unsupported Array method was called on Fuse. **";
            break;
         case "106":
            _loc2_ += "** ERROR: You have not set up Fuse correctly. **";
            _loc2_ += _loc4_ + "You must now use the following commands (PennerEasing is optional).";
            _loc2_ += _loc4_ + "\timport com.mosesSupposes.fuse.*;";
            _loc2_ += _loc4_ + "\tZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);" + _loc4_;
            break;
         case "107":
            _loc2_ += "** Fuse :: id not found - Aborting open(). **";
            break;
         case "108":
            _loc2_ += "** Fuse.startRecent: No recent Fuse found to start! **";
            break;
         case "109":
            _loc2_ += "** Commands other than \"delay\" are not allowed within groups. Command discarded (\"" + _loc3_ + "\")";
            break;
         case "110":
            _loc2_ += "** A Fuse.addCommand parameter (\"" + _loc3_ + "\") is not valid and was discarded. If you are trying to add a function-call try the syntax Fuse.addCommand(this,\"myCallback\",param1,param2); **";
            break;
         case "111":
            _loc2_ += "** A Fuse command parameter failed. (\"" + _loc3_ + "\") **";
            break;
         case "112":
            _loc2_ += "** Fuse: missing com.mosesSupposes.fuse.ZigoEngine! Cannot tween. **";
            break;
         case "113":
            _loc2_ += "** FuseItem: A callback has been discarded. Actions with a command may only contain: label, delay, scope, args. **";
            break;
         case "114":
            _loc2_ += "** FuseItem: command (\"" + _loc3_ + "\") discarded. Commands may not appear within action groups (arrays). **";
            break;
         case "115":
            _loc2_ += _loc3_ + " overlapping prop discarded: " + _loc5_;
            break;
         case "116":
            _loc2_ += "** FuseItem Error: Delays within groups (arrays) and start/update callbacks are not supported when using Fuse without ZigoEngine. Although you need to restructure your Fuse, it should be possible to achieve the same results. **" + _loc4_;
            break;
         case "117":
            _loc2_ += "** " + _loc3_ + ": infinite cycles are not allowed within Fuses - discarded. **";
            break;
         case "118":
            _loc2_ += "** Fuse Error: No targets in " + _loc3_ + (_loc5_ != true ? "  [Skipping this action] **" : "  [Unable to set start props] **");
            break;
         case "119":
            _loc2_ += "** Fuse warning: " + _loc5_ + (_loc5_ != 1 ? " targets missing in " : " target missing in ") + _loc6_ + (_loc3_ != true ? " **" : " during setStartProps **");
            break;
         case "120":
            _loc2_ += "** " + _loc3_ + ": conflict with \"" + _loc5_ + "\". Property might be doubled within a grouped-action array. **";
            break;
         case "121":
            _loc2_ += "** Timecode formatting requires \"00:\" formatting (example:\"01:01:33\" yields 61.33 seconds.) **";
            break;
         case "122":
            _loc2_ += "** FuseItem: You must register the Shortcuts class in order to use easy string-type callback parsing. **";
            break;
         case "123":
            _loc2_ += "** FuseItem unable to target callback. Try using the syntax {scope:this, func:\"myFunction\"} **";
            break;
         case "124":
            _loc2_ += "** Event \"" + _loc3_ + "\" reserved by Fuse. **";
            break;
         case "125":
            _loc2_ += "** A Fuse event parameter failed in " + _loc3_ + " **";
            break;
         case "126":
            _loc2_ += "** " + _loc3_ + ": trigger:" + _loc5_ + " ignored - only one trigger is allowed per action **";
            break;
         case "201":
            _loc2_ += "**** FuseFMP cannot initialize argument " + _loc3_ + " (BitmapFilters cannot be applied to this object type) ****";
            break;
         case "301":
            _loc2_ += "** The shortcuts fadeIn or fadeOut only accept 3 arguments: seconds, ease, and delay. **";
      }
      com.mosesSupposes.fuse.FuseKitCommon.output(_loc2_);
   }
}
