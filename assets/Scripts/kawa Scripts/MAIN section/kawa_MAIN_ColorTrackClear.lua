--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_ColorTrackClear. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local e=0 local o="kawa MAIN Track Colorize Clear";function ColorTrackHue_Clear()local r=reaper.CountTracks(e);if(r<1)then return end local a=reaper.CountSelectedTracks(e)reaper.Undo_BeginBlock();if(a>0)then for r=0,a-1 do local e=reaper.GetSelectedTrack(e,r)reaper.SetTrackColor(e,reaper.ColorToNative(145,145,145))end else if(r<=0)then return end;for r=0,r-1 do local e=reaper.GetTrack(e,r);reaper.SetTrackColor(e,reaper.ColorToNative(145,145,145))end end reaper.Undo_EndBlock(o,-1);reaper.UpdateArrange();end ColorTrackHue_Clear()