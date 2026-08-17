--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_SetItemEndToNextItemStart_Type1. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local a=0;local l=reaper.CountSelectedMediaItems(a);local t={}local r=200;local function n(t)local e=true;local a=reaper.CountSelectedMediaItems(a);if(a>t)then reaper.ShowMessageBox("over "..tostring(t).." clip num .\nstop process","stop.",0)e=false;end return e end if(n(r)==false)then return end if(l>1)then reaper.Undo_BeginBlock();local e=0;while(e<l)do local a=reaper.GetSelectedMediaItem(a,e);local l=reaper.GetMediaItemTrack(a);local l=reaper.GetMediaTrackInfo_Value(l,"IP_TRACKNUMBER");local a={mediaItem=a,startPos=reaper.GetMediaItemInfo_Value(a,"D_POSITION"),length=reaper.GetMediaItemInfo_Value(a,"D_LENGTH"),trackId=l};if(t[l]==nil)then t[l]={}end table.insert(t[l],a);e=e+1;end for a,e in pairs(t)do table.sort(e,function(a,e)return(a.startPos>e.startPos);end);local a=nil;for t,e in ipairs(e)do local l=e.mediaItem;local t=e.startPos;if(a~=nil)then e.length=a-t;reaper.SetMediaItemInfo_Value(l,"D_LENGTH",e.length);end a=t;end end reaper.Undo_EndBlock("",-1);reaper.UpdateArrange();end
