if(_url.indexOf("miniclip.com") == -1 && _url.indexOf("miniclip.net") == -1 && _url.indexOf("miniclip.co.uk") == -1 && _url.indexOf("miniclips.com"))
{
   gotoAndStop(_currentframe + 1);
}
else
{
   var noCache = getTimer() + random(100000);
   mcTarget.loadMovie("http://www.miniclip.com/swfcontent/highscore.swf?noCache=" + noCache);
   stop();
}
