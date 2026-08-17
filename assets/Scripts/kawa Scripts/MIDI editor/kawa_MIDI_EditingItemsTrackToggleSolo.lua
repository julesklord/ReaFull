--[[ 
* ReaScript Name: kawa_MIDI_EditingItemsTrackToggleSolo. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local o="kawa MIDI Editing Item's Track Toggle Solo"local e=reaper.MIDIEditor_GetActive();local e=targetTake_ or reaper.MIDIEditor_GetTake(e);if(e==nil)then return end local e=reaper.GetMediaItemTake_Item(e);local t=reaper.GetMediaItemTrack(e);reaper.Undo_BeginBlock();local function r(a)local l=reaper.GetMediaTrackInfo_Value(a,"I_SOLO");local e;if(l==0)then e=2;else e=0;end reaper.SetMediaTrackInfo_Value(a,"I_SOLO",e);end r(t)reaper.Undo_EndBlock(o,-1);reaper.UpdateArrange();