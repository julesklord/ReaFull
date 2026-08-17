--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_NextFolderCompactSetting. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local e="kawa MAIN NextFolder Setting"local function o()local a=0 local l=reaper.CountSelectedTracks(a)local function n(r)local e=reaper.GetMediaTrackInfo_Value(r,"I_FOLDERDEPTH")if(e~=0)then local a=reaper.GetMediaTrackInfo_Value(r,"I_FOLDERCOMPACT")local e=0;if(a==0)then e=1;elseif(a==1)then e=2;elseif(a==2)then e=0;else e=1 end;reaper.SetMediaTrackInfo_Value(r,"I_FOLDERCOMPACT",e)end end if(l>0)then for e=0,l-1 do local e=reaper.GetSelectedTrack(a,e)n(e);end else local e=reaper.CountTracks(a);if(e<=0)then return end;for e=0,e-1 do local e=reaper.GetTrack(a,e);n(e);end end reaper.UpdateArrange();end reaper.Undo_BeginBlock();o();reaper.Undo_EndBlock("kawa MAIN NextFolder Setting",-1);reaper.UpdateArrange();