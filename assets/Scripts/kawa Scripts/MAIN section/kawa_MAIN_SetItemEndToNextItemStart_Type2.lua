--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_SetItemEndToNextItemStart_Type2. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local e=0;local o=reaper.CountSelectedMediaItems(e);local n=reaper.GetProjectLength(e);local l={}local a={}local r=200;local function d(t)local a=true;local e=reaper.CountSelectedMediaItems(e);if(e>t)then reaper.ShowMessageBox("over "..tostring(t).." clip num .\nstop process","stop.",0)a=false;end return a end if(d(r)==false)then return end if(o>0)then reaper.Undo_BeginBlock();local r=0;while(r<o)do local t=reaper.GetSelectedMediaItem(e,r);local o=reaper.GetMediaItemTrack(t);local e=reaper.GetMediaTrackInfo_Value(o,"IP_TRACKNUMBER");if(a[e]==nil)then a[e]={}local r=reaper.CountTrackMediaItems(o);local t=0;while(t<r)do local r=reaper.GetTrackMediaItem(o,t)local r={mediaItem=r,startPos=reaper.GetMediaItemInfo_Value(r,"D_POSITION"),length=reaper.GetMediaItemInfo_Value(r,"D_LENGTH"),mediaItemIdx=reaper.GetMediaItemInfo_Value(r,"IP_ITEMNUMBER"),trackId=e};table.insert(a[e],r);t=t+1;end table.sort(a[e],function(a,e)return(a.startPos>e.startPos);end);end local t={mediaItem=t,startPos=reaper.GetMediaItemInfo_Value(t,"D_POSITION"),length=reaper.GetMediaItemInfo_Value(t,"D_LENGTH"),mediaItemIdx=reaper.GetMediaItemInfo_Value(t,"IP_ITEMNUMBER"),trackId=e,targetEndPos=nil};local o=n;for a,e in ipairs(a[e])do if(e.mediaItemIdx==t.mediaItemIdx)then t.targetEndPos=o;end o=e.startPos end if(l[e]==nil)then l[e]={}end table.insert(l[e],t);r=r+1;end for a,e in pairs(l)do for a,e in ipairs(e)do local a=e.mediaItem;local t=e.startPos;e.length=e.targetEndPos-t;reaper.SetMediaItemInfo_Value(a,"D_LENGTH",e.length);end end reaper.Undo_EndBlock("",-1);reaper.UpdateArrange();end
