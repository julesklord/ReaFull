--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_CreateSamplOMatic5000. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
function CreateSampleOmatic5000()local e=0;local l="ReaSamplOmatic5000 (Cockos)"local t="ReaSamplOmatic"local c="ReaSamplOmatic"local r=reaper.GetSelectedTrack2(e,0,false)local a=0 if(r~=nil)then a=reaper.GetMediaTrackInfo_Value(r,"IP_TRACKNUMBER")end local a=a reaper.InsertTrackAtIndex(a,true)local e=reaper.GetTrack(e,a)if(e)then reaper.TrackFX_AddByName(e,l,false,-1)reaper.GetSetMediaTrackInfo_String(e,"P_NAME",c,true)local r=reaper.TrackFX_GetCount(e)local a=0 for r=0,r-1 do local l,e=reaper.TrackFX_GetFXName(e,r,"")if(string.find(e,t)~=nil)then a=r break;end end reaper.TrackFX_Show(e,a,1)end reaper.TrackList_UpdateAllExternalSurfaces()reaper.UpdateTimeline();reaper.UpdateArrange();end CreateSampleOmatic5000();