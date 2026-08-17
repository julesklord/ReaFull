--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_SelectedTrackHideTCP_Type2. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local a=0 function SetSelectionTrackHideWithChild()local c=reaper.CountSelectedTracks(a)reaper.Undo_BeginBlock();local function r(e)if(e==nil)then return end local e=reaper.GetMediaTrackInfo_Value(e,"I_FOLDERDEPTH")return(e>0)end local function t(e)if(e==nil)then return end local r=reaper.GetMediaTrackInfo_Value(e,"IP_TRACKNUMBER")local e=0 for r=0,r-1 do local a=reaper.GetTrack(a,r)local a=reaper.GetMediaTrackInfo_Value(a,"I_FOLDERDEPTH")e=e+a end return e;end local function l(e)if(e==nil)then return end reaper.SetMediaTrackInfo_Value(e,"B_SHOWINTCP",0)local c=t(e)local r=r(e)if(r==true)then local e=reaper.GetMediaTrackInfo_Value(e,"IP_TRACKNUMBER")local r=e;local n=false;local e=0 while(n==false)do local e=reaper.GetTrack(a,r)if(e==nil)then break end l(e)local e=t(e)n=(e<c)r=r+1;end end end if(c>0)then for e=0,c-1 do local e=reaper.GetSelectedTrack(a,e)l(e)end end reaper.Undo_EndBlock("kawa MAIN Track Selection Track Hide With Child",-1);reaper.UpdateArrange();reaper.TrackList_AdjustWindows(true);reaper.TrackList_UpdateAllExternalSurfaces();reaper.UpdateTimeline()end SetSelectionTrackHideWithChild()