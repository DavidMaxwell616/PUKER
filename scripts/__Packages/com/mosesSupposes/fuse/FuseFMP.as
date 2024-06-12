class com.mosesSupposes.fuse.FuseFMP
{
   static var $fclasses;
   static var $shortcuts;
   static var $gro;
   static var $sro;
   static var registryKey = "fuseFMP";
   static var VERSION = com.mosesSupposes.fuse.FuseKitCommon.VERSION;
   function FuseFMP()
   {
   }
   static function simpleSetup()
   {
      com.mosesSupposes.fuse.FuseFMP.initialize(MovieClip.prototype,Button.prototype,TextField.prototype);
      _global.FuseFMP = com.mosesSupposes.fuse.FuseFMP;
      for(var _loc2_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
      {
         _global[_loc2_] = com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc2_];
      }
   }
   static function initialize(target)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.$shortcuts = {getFilterName:function(f)
         {
            return com.mosesSupposes.fuse.FuseFMP.getFilterName(f);
         },getFilterIndex:function(f)
         {
            return com.mosesSupposes.fuse.FuseFMP.getFilterIndex(this,f);
         },getFilter:function(f, createNew)
         {
            return com.mosesSupposes.fuse.FuseFMP.getFilter(this,f,createNew);
         },writeFilter:function(f, pObj)
         {
            return com.mosesSupposes.fuse.FuseFMP.writeFilter(this,f,pObj);
         },removeFilter:function(f)
         {
            return com.mosesSupposes.fuse.FuseFMP.removeFilter(this,f);
         },getFilterProp:function(prop, createNew)
         {
            return com.mosesSupposes.fuse.FuseFMP.getFilterProp(this,prop,createNew);
         },setFilterProp:function(prop, v)
         {
            com.mosesSupposes.fuse.FuseFMP.setFilterProp(this,prop,v);
         },setFilterProps:function(fOrPObj, pObj)
         {
            com.mosesSupposes.fuse.FuseFMP.setFilterProps(this,fOrPObj,pObj);
         },traceAllFilters:function()
         {
            com.mosesSupposes.fuse.FuseFMP.traceAllFilters();
         }};
         com.mosesSupposes.fuse.FuseFMP.$fclasses = {BevelFilter:flash.filters.BevelFilter,BlurFilter:flash.filters.BlurFilter,ColorMatrixFilter:flash.filters.ColorMatrixFilter,ConvolutionFilter:flash.filters.ConvolutionFilter,DisplacementMapFilter:flash.filters.DisplacementMapFilter,DropShadowFilter:flash.filters.DropShadowFilter,GlowFilter:flash.filters.GlowFilter,GradientBevelFilter:flash.filters.GradientBevelFilter,GradientGlowFilter:flash.filters.GradientGlowFilter};
         com.mosesSupposes.fuse.FuseFMP.$gro = {__resolve:function(name)
         {
            var _loc4_ = function()
            {
               var _loc3_ = this;
               if(_loc3_.filters != undefined)
               {
                  var _loc2_ = name.split("_");
                  if(_loc2_[1] == "blur")
                  {
                     _loc2_[1] = "blurX";
                  }
                  return com.mosesSupposes.fuse.FuseFMP.getFilter(this,_loc2_[0] + "Filter",false)[_loc2_[1]];
               }
            };
            return _loc4_;
         }};
         com.mosesSupposes.fuse.FuseFMP.$sro = {__resolve:function(name)
         {
            var _loc3_ = function(val)
            {
               var _loc2_ = this;
               if(_loc2_.filters != undefined)
               {
                  com.mosesSupposes.fuse.FuseFMP.setFilterProp(this,name,val);
               }
            };
            return _loc3_;
         }};
      }
      if(arguments[0] == null)
      {
         return undefined;
      }
      var _loc6_ = [MovieClip,Button,TextField];
      for(var _loc13_ in arguments)
      {
         var _loc7_ = false;
         for(var _loc10_ in _loc6_)
         {
            if(arguments[_loc13_] instanceof _loc6_[_loc10_] || arguments[_loc13_] == Function(_loc6_[_loc10_]).prototype)
            {
               _loc7_ = true;
               break;
            }
         }
         if(!_loc7_)
         {
            com.mosesSupposes.fuse.FuseKitCommon.error("201",_loc13_);
         }
         else
         {
            for(var _loc11_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
            {
               var _loc5_ = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc11_]();
               for(var _loc8_ in _loc5_)
               {
                  if(typeof _loc5_[_loc8_] != "function")
                  {
                     var _loc4_ = _loc11_.substr(0,-6) + "_" + _loc8_;
                     arguments[_loc13_].addProperty(_loc4_,com.mosesSupposes.fuse.FuseFMP.$gro[_loc4_],com.mosesSupposes.fuse.FuseFMP.$sro[_loc4_]);
                     _global.ASSetPropFlags(arguments[_loc13_],_loc4_,3,1);
                     if(_loc8_ == "blurX")
                     {
                        _loc4_ = _loc4_.slice(0,-1);
                        arguments[_loc13_].addProperty(_loc4_,com.mosesSupposes.fuse.FuseFMP.$gro[_loc4_],com.mosesSupposes.fuse.FuseFMP.$sro[_loc4_]);
                        _global.ASSetPropFlags(arguments[_loc13_],_loc4_,3,1);
                     }
                  }
               }
            }
            for(var _loc9_ in com.mosesSupposes.fuse.FuseFMP.$shortcuts)
            {
               arguments[_loc13_][_loc9_] = com.mosesSupposes.fuse.FuseFMP.$shortcuts[_loc9_];
               _global.ASSetPropFlags(arguments[_loc13_],_loc9_,7,1);
            }
         }
      }
   }
   static function deinitialize()
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         return undefined;
      }
      if(arguments.length == 0)
      {
         arguments.push(MovieClip.prototype,Button.prototype,TextField.prototype);
      }
      for(var _loc8_ in arguments)
      {
         for(var _loc7_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
         {
            var _loc4_ = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc7_]();
            for(var _loc5_ in _loc4_)
            {
               if(typeof _loc4_[_loc5_] != "function")
               {
                  var _loc3_ = _loc7_.substr(0,-6) + "_" + _loc5_;
                  _global.ASSetPropFlags(arguments[_loc8_],_loc3_,0,2);
                  arguments[_loc8_].addProperty(_loc3_,null,null);
                  delete arguments[_loc8_][_loc3_];
               }
            }
         }
         for(var _loc6_ in com.mosesSupposes.fuse.FuseFMP.$shortcuts)
         {
            _global.ASSetPropFlags(arguments[_loc8_],_loc6_,0,2);
            delete arguments[_loc8_][_loc6_];
         }
      }
   }
   static function getFilterName($myFilter)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      for(var _loc1_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
      {
         if($myFilter.__proto__ == Function(com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc1_]).prototype)
         {
            return _loc1_;
         }
      }
      return null;
   }
   static function getFilterIndex($obj, $myFilter)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
      if($myFilter === null)
      {
         return -1;
      }
      var _loc2_ = $obj.filters;
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         if(_loc2_[_loc1_].__proto__ == $myFilter.__proto__)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ + 1;
      }
      return -1;
   }
   static function getFilter($obj, $myFilter, $createNew)
   {
      var _loc1_ = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj,$myFilter);
      if(_loc1_ == -1)
      {
         if($createNew != true)
         {
            return null;
         }
         _loc1_ = com.mosesSupposes.fuse.FuseFMP.writeFilter($obj,$myFilter);
         if(_loc1_ == -1)
         {
            return null;
         }
      }
      return $obj.filters[_loc1_];
   }
   static function writeFilter($obj, $myFilter, $propsObj)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
      if($myFilter === null)
      {
         return -1;
      }
      var _loc4_ = $obj.filters;
      var _loc2_ = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj,$myFilter);
      if(_loc2_ == -1)
      {
         _loc4_.push($myFilter);
      }
      else
      {
         _loc4_[_loc2_] = $myFilter;
      }
      $obj.filters = _loc4_;
      if(typeof $propsObj == "object")
      {
         com.mosesSupposes.fuse.FuseFMP.setFilterProps($obj,$myFilter,$propsObj);
      }
      _loc2_ = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj,$myFilter);
      return _loc2_;
   }
   static function removeFilter($obj, $myFilter)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
      var _loc2_ = $obj.filters;
      var _loc1_ = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj,$myFilter);
      if(_loc1_ == -1)
      {
         return false;
      }
      _loc2_.splice(_loc1_,1);
      $obj.filters = _loc2_;
      return true;
   }
   static function getFilterProp($obj, $filtername, $createNew)
   {
      var _loc1_ = $filtername.split("_");
      if(_loc1_[1] == "blur")
      {
         _loc1_[1] = "blurX";
      }
      return com.mosesSupposes.fuse.FuseFMP.getFilter($obj,_loc1_[0] + "Filter",$createNew)[_loc1_[1]];
   }
   static function setFilterProp($obj, $propname, $val)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      var _loc7_ = $propname.split("_");
      var _loc8_ = _loc7_[0] + "Filter";
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc8_] == undefined)
      {
         return undefined;
      }
      var _loc2_ = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc8_]();
      var _loc6_ = _loc7_[1];
      var _loc3_ = $obj.filters.length || 0;
      while((_loc3_ = _loc3_ - 1) > -1)
      {
         var _loc1_ = $obj.filters[_loc3_];
         if(_loc1_.__proto__ == _loc2_.__proto__)
         {
            _loc2_ = _loc1_;
            break;
         }
      }
      if(_loc6_ == "blur")
      {
         _loc2_.blurX = $val;
         _loc2_.blurY = $val;
      }
      else
      {
         if(_loc6_.indexOf("lor") > -1)
         {
            if(typeof $val == "string" && _loc6_.charAt(2) != "l")
            {
               if($val.charAt(0) == "#")
               {
                  $val = $val.slice(1);
               }
               $val = $val.charAt(1).toLowerCase() == "x" ? Number($val) : Number("0x" + $val);
            }
         }
         _loc2_[_loc6_] = $val;
      }
      if(_loc3_ == -1)
      {
         $obj.filters = [_loc2_];
      }
      else
      {
         var _loc9_ = $obj.filters;
         _loc9_[_loc3_] = _loc2_;
         $obj.filters = _loc9_;
      }
   }
   static function setFilterProps($obj, $filterOrPropsObj, $propsObj)
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      if(!($obj instanceof Array))
      {
         $obj = [$obj];
      }
      var _loc4_ = new Object();
      var _loc3_ = undefined;
      var _loc2_ = undefined;
      if(arguments.length == 3)
      {
         for(var _loc12_ in $obj)
         {
            var _loc5_ = com.mosesSupposes.fuse.FuseFMP.getFilter($obj[_loc12_],$filterOrPropsObj,true);
            if(_loc5_ != null)
            {
               var _loc8_ = com.mosesSupposes.fuse.FuseFMP.getFilterName(_loc5_).substr(0,-6) + "_";
               for(_loc3_ in $propsObj)
               {
                  _loc4_[_loc3_] = $propsObj[_loc3_];
               }
               for(_loc3_ in _loc4_)
               {
                  _loc2_ = _loc4_[_loc3_];
                  if(_loc3_.indexOf(_loc8_) == 0)
                  {
                     _loc3_ = _loc3_.slice(_loc8_.length);
                  }
                  if(_loc3_ == "blur")
                  {
                     flash.filters.BlurFilter(_loc5_).blurX = Number(_loc2_);
                     flash.filters.BlurFilter(_loc5_).blurY = Number(_loc2_);
                  }
                  else if(_loc3_.indexOf("lor") > -1 && _loc3_.charAt(2) != "l" && typeof _loc2_ == "string")
                  {
                     if(_loc2_.charAt(0) == "#")
                     {
                        _loc2_ = _loc2_.slice(1);
                     }
                     _loc2_ = _loc2_.charAt(1).toLowerCase() == "x" ? Number(_loc2_) : Number("0x" + _loc2_);
                  }
                  else
                  {
                     _loc5_[_loc3_] = _loc2_;
                  }
               }
               com.mosesSupposes.fuse.FuseFMP.writeFilter($obj[_loc12_],_loc5_);
            }
         }
      }
      else if(typeof $filterOrPropsObj == "object")
      {
         $propsObj = $filterOrPropsObj;
         for(_loc3_ in $propsObj)
         {
            var _loc9_ = _loc3_.split("_");
            var _loc10_ = _loc9_[0] + "Filter";
            if(com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc10_] != undefined)
            {
               if(_loc4_[_loc10_] == undefined)
               {
                  _loc4_[_loc10_] = {};
               }
               if(_loc9_[1] == "blur")
               {
                  flash.filters.BlurFilter(_loc4_[_loc10_]).blurX = $propsObj[_loc3_];
                  flash.filters.BlurFilter(_loc4_[_loc10_]).blurY = $propsObj[_loc3_];
               }
               else
               {
                  _loc4_[_loc10_][_loc9_[1]] = $propsObj[_loc3_];
               }
            }
         }
         for(_loc12_ in $obj)
         {
            for(_loc10_ in _loc4_)
            {
               _loc5_ = com.mosesSupposes.fuse.FuseFMP.getFilter($obj[_loc12_],_loc10_,true);
               if(_loc5_ != null)
               {
                  for(_loc3_ in _loc4_[_loc10_])
                  {
                     _loc2_ = _loc4_[_loc10_][_loc3_];
                     if(_loc3_.indexOf("lor") > -1 && _loc3_.charAt(2) != "l" && typeof _loc2_ == "string")
                     {
                        if(_loc2_.charAt(0) == "#")
                        {
                           _loc2_ = _loc2_.slice(1);
                        }
                        _loc2_ = _loc2_.charAt(1).toLowerCase() == "x" ? Number(_loc2_) : Number("0x" + _loc2_);
                     }
                     _loc5_[_loc3_] = _loc2_;
                  }
                  com.mosesSupposes.fuse.FuseFMP.writeFilter($obj[_loc12_],_loc5_);
               }
            }
         }
      }
   }
   static function getAllShortcuts()
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      var _loc2_ = [];
      for(var _loc4_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
      {
         var _loc1_ = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc4_]();
         for(var _loc3_ in _loc1_)
         {
            if(typeof _loc1_[_loc3_] != "function")
            {
               _loc2_.push(_loc4_.substr(0,-6) + "_" + _loc3_);
               if(_loc3_ == "blurX")
               {
                  _loc2_.push(_loc4_.substr(0,-6) + "_blur");
               }
            }
         }
      }
      return _loc2_;
   }
   static function traceAllFilters()
   {
      if(com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
      {
         com.mosesSupposes.fuse.FuseFMP.initialize(null);
      }
      var _loc1_ = "------ FuseFMP filter properties ------\n";
      for(var _loc4_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
      {
         _loc1_ += _loc4_;
         var _loc2_ = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc4_]();
         for(var _loc3_ in _loc2_)
         {
            if(typeof _loc2_[_loc3_] != "function")
            {
               _loc1_ += "\t- " + _loc4_.substr(0,-6) + "_" + _loc3_;
               if(_loc3_ == "blurX")
               {
                  _loc1_ += "\t- " + _loc4_.substr(0,-6) + "_blur";
               }
            }
         }
         _loc1_ += "\n";
      }
      com.mosesSupposes.fuse.FuseKitCommon.output(_loc1_);
   }
   static function $getInstance($myFilter)
   {
      if($myFilter instanceof flash.filters.BitmapFilter)
      {
         return flash.filters.BitmapFilter($myFilter);
      }
      if(typeof $myFilter == "function")
      {
         for(var _loc3_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
         {
            if($myFilter == com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3_])
            {
               return new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3_]();
            }
         }
      }
      if(typeof $myFilter == "string")
      {
         var _loc2_ = String($myFilter);
         if(_loc2_.substr(-6) != "Filter")
         {
            _loc2_ += "Filter";
         }
         for(_loc3_ in com.mosesSupposes.fuse.FuseFMP.$fclasses)
         {
            if(_loc3_ == _loc2_)
            {
               return new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3_]();
            }
         }
      }
      return null;
   }
}
