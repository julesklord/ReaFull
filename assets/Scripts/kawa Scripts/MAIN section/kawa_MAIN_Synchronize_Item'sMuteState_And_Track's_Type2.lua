--[[ 
* ReaScript Name: kawa_MAIN_Synchronize_Item'sMuteState_And_Track's_Type2. 
* Version: 2017/02/03 
* Author: kawa_ 
* link: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local a=0 local l=reaper.CountSelectedMediaItems(a);local r="kawa MAIN Selected Item's Mute State Synchronize to Track's Mute state Type 2.";if(l>0)then reaper.Undo_BeginBlock();local t=reaper.AnyTrackSolo(a);local e=0;while(e<l)do local l=reaper.GetSelectedMediaItem(a,e);local a=reaper.GetMediaItemTrack(l);local r=reaper.GetMediaTrackInfo_Value(a,"IP_TRACKNUMBER");if(t)then local a=(reaper.GetMediaTrackInfo_Value(a,"I_SOLO"));local e;if(a>0)then e=0;else e=1;end reaper.SetMediaItemInfo_Value(l,"B_MUTE",e);else local e=reaper.GetMediaTrackInfo_Value(a,"B_MUTE");reaper.SetMediaItemInfo_Value(l,"B_MUTE",e);end e=e+1;end reaper.Undo_EndBlock(r,-1);reaper.UpdateArrange();end
