--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_IncreaseLength. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local i=0;local d=reaper.CountSelectedMediaItems(i);local e="kawa Main Decrease Length"local t=200;local function l(e)local a=true;local t=reaper.CountSelectedMediaItems(i);if(t>e)then reaper.ShowMessageBox("over "..tostring(e).." clip num .\nstop process","stop.",0)a=false;end return a end if(l(t)==false)then return end local function c(e)local t=reaper.CountSelectedMediaItems(e);local d=reaper.GetProjectLength(e);local n={}local a={}local r=0;while(r<t)do local l=reaper.GetSelectedMediaItem(e,r);local t=reaper.GetMediaItemTrack(l);local e=reaper.GetMediaTrackInfo_Value(t,"IP_TRACKNUMBER");if(a[e]==nil)then a[e]={}local l=reaper.CountTrackMediaItems(t);local r=0;while(r<l)do local l=reaper.GetTrackMediaItem(t,r)local i=reaper.GetMediaItemInfo_Value(l,"D_POSITION")local n=reaper.GetMediaItemInfo_Value(l,"D_LENGTH")local t={mediaItem=l,startTime=i,length=n,endTime=i+n,mediaItemIdx=reaper.GetMediaItemInfo_Value(l,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t};table.insert(a[e],t);r=r+1;end table.sort(a[e],function(e,a)return(e.startTime>a.startTime);end);end local i=reaper.GetMediaItemInfo_Value(l,"D_POSITION")local o=reaper.GetMediaItemInfo_Value(l,"D_LENGTH")local t={mediaItem=l,startTime=i,length=o,endTime=i+o,mediaItemIdx=reaper.GetMediaItemInfo_Value(l,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t,nextItemStartTime=nil,nextMediaItem=nil};local l=d;local i=nil for a,e in ipairs(a[e])do if(e.mediaItemIdx==t.mediaItemIdx)then t.nextItemStartTime=l;t.nextMediaItem=i;end l=e.startTime;i=e;end if(n[e]==nil)then n[e]={}end table.insert(n[e],t);r=r+1;end return a,n end if(d>0)then local a,e=c(i)local a=1.1;for t,e in pairs(e)do for t,e in ipairs(e)do local t=e.mediaItem local a=e.length*a reaper.SetMediaItemInfo_Value(e.mediaItem,"D_LENGTH",a)end end end
