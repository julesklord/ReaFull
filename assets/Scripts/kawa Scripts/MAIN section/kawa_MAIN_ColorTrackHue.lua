--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_ColorTrackHue. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local i=0 local p=10 local T=.68 local d=1 local s="kawa MAIN Track Colorize Clear";function HSVToRGB(c,h,d)local r,a,o,f,i,e,l,t,n local c=c local h=h if(c>360)then c=c-360;elseif(c<0)then c=c+360;end if(h>1)then h=1;elseif(h<0)then h=0;end e=math.floor(255*d)if(e>255)then e=255;elseif(e<0)then e=0;end if(h==0)then r=e;a=e;o=e;else f=math.floor(c/60)i=c/60-f l=math.floor(e*(1-h))if(l<0)then l=0;elseif(l>255)then l=255;end t=math.floor(e*(1-i*h))if(t<0)then t=0;elseif(t>255)then t=255;end n=math.floor(e*(1-(1-i)*h))if(n<0)then n=0;elseif(n>255)then n=255;end if(f==0)then r=e;a=n;o=l;elseif(f==1)then r=t;a=e;o=l;elseif(f==2)then r=l;a=e;o=n;elseif(f==3)then r=l;a=t;o=e;elseif(f==4)then r=n;a=l;o=e;elseif(f==5)then r=e;a=l;o=t;else r=e;a=n;o=l;end end return r,a,o end function ColorTrackHueGrad(a,r,l)local e=reaper.CountTracks(i);if(e<1)then return end local o=reaper.CountSelectedTracks(i)local a=a or 60 local r=r or 1 local l=l or 1 reaper.Undo_BeginBlock();if(o>0)then local n=math.floor(360*math.random());local a=a;for e=0,o-1 do local o=reaper.GetSelectedTrack(i,e)local e=reaper.ColorToNative(HSVToRGB(n+a*e,r,l));reaper.SetTrackColor(o,e)end else if(e<=0)then return end;local o=math.floor(360*math.random());local a=a;for e=0,e-1 do local n=reaper.GetTrack(i,e);local e=reaper.ColorToNative(HSVToRGB(o+a*e,r,l));reaper.SetTrackColor(n,e)end end reaper.Undo_EndBlock(s,-1);reaper.UpdateArrange();end ColorTrackHueGrad(p,T,d)