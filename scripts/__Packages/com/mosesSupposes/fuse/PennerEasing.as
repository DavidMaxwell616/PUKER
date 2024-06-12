class com.mosesSupposes.fuse.PennerEasing
{
   static var registryKey = "pennerEasing";
   function PennerEasing()
   {
   }
   static function linear(t, b, c, d)
   {
      return c * t / d + b;
   }
   static function easeInQuad(t, b, c, d)
   {
      return c * (t /= d) * t + b;
   }
   static function easeOutQuad(t, b, c, d)
   {
      return (- c) * (t /= d) * (t - 2) + b;
   }
   static function easeInOutQuad(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * t * t + b;
      }
      return (- c) / 2 * ((t = t - 1) * (t - 2) - 1) + b;
   }
   static function easeInExpo(t, b, c, d)
   {
      return t != 0 ? c * Math.pow(2,10 * (t / d - 1)) + b : b;
   }
   static function easeOutExpo(t, b, c, d)
   {
      return t != d ? c * (- Math.pow(2,-10 * t / d) + 1) + b : b + c;
   }
   static function easeInOutExpo(t, b, c, d)
   {
      if(t == 0)
      {
         return b;
      }
      if(t == d)
      {
         return b + c;
      }
      if((t /= d / 2) < 1)
      {
         return c / 2 * Math.pow(2,10 * (t - 1)) + b;
      }
      return c / 2 * (- Math.pow(2,-10 * (t = t - 1)) + 2) + b;
   }
   static function easeOutInExpo(t, b, c, d)
   {
      if(t == 0)
      {
         return b;
      }
      if(t == d)
      {
         return b + c;
      }
      if((t /= d / 2) < 1)
      {
         return c / 2 * (- Math.pow(2,-10 * t) + 1) + b;
      }
      return c / 2 * (Math.pow(2,10 * (t - 2)) + 1) + b;
   }
   static function easeInElastic(t, b, c, d, a, p)
   {
      var _loc5_ = undefined;
      if(t == 0)
      {
         return b;
      }
      if((t /= d) == 1)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.3;
      }
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / 6.283185307179586 * Math.asin(c / a);
      }
      return - a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p) + b;
   }
   static function easeOutElastic(t, b, c, d, a, p)
   {
      var _loc5_ = undefined;
      if(t == 0)
      {
         return b;
      }
      if((t /= d) == 1)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.3;
      }
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / 6.283185307179586 * Math.asin(c / a);
      }
      return a * Math.pow(2,-10 * t) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p) + c + b;
   }
   static function easeInOutElastic(t, b, c, d, a, p)
   {
      var _loc5_ = undefined;
      if(t == 0)
      {
         return b;
      }
      if((t /= d / 2) == 2)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.44999999999999996;
      }
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / 6.283185307179586 * Math.asin(c / a);
      }
      if(t < 1)
      {
         return -0.5 * (a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p)) + b;
      }
      return a * Math.pow(2,-10 * (t -= 1)) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p) * 0.5 + c + b;
   }
   static function easeOutInElastic(t, b, c, d, a, p)
   {
      var _loc5_ = undefined;
      if(t == 0)
      {
         return b;
      }
      if((t /= d / 2) == 2)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.44999999999999996;
      }
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / 6.283185307179586 * Math.asin(c / a);
      }
      if(t < 1)
      {
         return 0.5 * (a * Math.pow(2,-10 * t) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p)) + c / 2 + b;
      }
      return c / 2 + 0.5 * (a * Math.pow(2,10 * (t - 2)) * Math.sin((t * d - _loc5_) * 6.283185307179586 / p)) + b;
   }
   static function easeInBack(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      return c * (t /= d) * t * ((s + 1) * t - s) + b;
   }
   static function easeOutBack(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
   }
   static function easeInOutBack(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      if((t /= d / 2) < 1)
      {
         return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
      }
      return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
   }
   static function easeOutInBack(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      if((t /= d / 2) < 1)
      {
         return c / 2 * ((t = t - 1) * t * (((s *= 1.525) + 1) * t + s) + 1) + b;
      }
      return c / 2 * ((t = t - 1) * t * (((s *= 1.525) + 1) * t - s) + 1) + b;
   }
   static function easeOutBounce(t, b, c, d)
   {
      if((t /= d) < 0.36363636363636365)
      {
         return c * (7.5625 * t * t) + b;
      }
      if(t < 0.7272727272727273)
      {
         return c * (7.5625 * (t -= 0.5454545454545454) * t + 0.75) + b;
      }
      if(t < 0.9090909090909091)
      {
         return c * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375) + b;
      }
      return c * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375) + b;
   }
   static function easeInBounce(t, b, c, d)
   {
      return c - com.mosesSupposes.fuse.PennerEasing.easeOutBounce(d - t,0,c,d) + b;
   }
   static function easeInOutBounce(t, b, c, d)
   {
      if(t < d / 2)
      {
         return com.mosesSupposes.fuse.PennerEasing.easeInBounce(t * 2,0,c,d) * 0.5 + b;
      }
      return com.mosesSupposes.fuse.PennerEasing.easeOutBounce(t * 2 - d,0,c,d) * 0.5 + c * 0.5 + b;
   }
   static function easeOutInBounce(t, b, c, d)
   {
      if(t < d / 2)
      {
         return com.mosesSupposes.fuse.PennerEasing.easeOutBounce(t * 2,0,c,d) * 0.5 + b;
      }
      return com.mosesSupposes.fuse.PennerEasing.easeInBounce(t * 2 - d,0,c,d) * 0.5 + c * 0.5 + b;
   }
   static function easeInCubic(t, b, c, d)
   {
      return c * (t /= d) * t * t + b;
   }
   static function easeOutCubic(t, b, c, d)
   {
      return c * ((t = t / d - 1) * t * t + 1) + b;
   }
   static function easeInOutCubic(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * t * t * t + b;
      }
      return c / 2 * ((t -= 2) * t * t + 2) + b;
   }
   static function easeOutInCubic(t, b, c, d)
   {
      t /= d / 2;
      return c / 2 * ((t = t - 1) * t * t + 1) + b;
   }
   static function easeInQuart(t, b, c, d)
   {
      return c * (t /= d) * t * t * t + b;
   }
   static function easeOutQuart(t, b, c, d)
   {
      return (- c) * ((t = t / d - 1) * t * t * t - 1) + b;
   }
   static function easeInOutQuart(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * t * t * t * t + b;
      }
      return (- c) / 2 * ((t -= 2) * t * t * t - 2) + b;
   }
   static function easeOutInQuart(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return (- c) / 2 * ((t = t - 1) * t * t * t - 1) + b;
      }
      return c / 2 * ((t = t - 1) * t * t * t + 1) + b;
   }
   static function easeInQuint(t, b, c, d)
   {
      return c * (t /= d) * t * t * t * t + b;
   }
   static function easeOutQuint(t, b, c, d)
   {
      return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
   }
   static function easeInOutQuint(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * t * t * t * t * t + b;
      }
      return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
   }
   static function easeOutInQuint(t, b, c, d)
   {
      t /= d / 2;
      return c / 2 * ((t = t - 1) * t * t * t * t + 1) + b;
   }
   static function easeInSine(t, b, c, d)
   {
      return (- c) * Math.cos(t / d * 1.5707963267948966) + c + b;
   }
   static function easeOutSine(t, b, c, d)
   {
      return c * Math.sin(t / d * 1.5707963267948966) + b;
   }
   static function easeInOutSine(t, b, c, d)
   {
      return (- c) / 2 * (Math.cos(3.141592653589793 * t / d) - 1) + b;
   }
   static function easeOutInSine(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * Math.sin(3.141592653589793 * t / 2) + b;
      }
      return (- c) / 2 * (Math.cos(3.141592653589793 * (t = t - 1) / 2) - 2) + b;
   }
   static function easeInCirc(t, b, c, d)
   {
      return (- c) * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
   }
   static function easeOutCirc(t, b, c, d)
   {
      return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
   }
   static function easeInOutCirc(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return (- c) / 2 * (Math.sqrt(1 - t * t) - 1) + b;
      }
      return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
   }
   static function easeOutInCirc(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * Math.sqrt(1 - (t = t - 1) * t) + b;
      }
      return c / 2 * (2 - Math.sqrt(1 - (t = t - 1) * t)) + b;
   }
}
