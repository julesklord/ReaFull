--[[ 
* ReaScript Name: kawa_MIDI_VerticalZoom_Out_5. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local e=40112 local r=40111 local r=reaper.MIDIEditor_GetActive();local a=e;local e=5;if(reaper.MIDIEditor_GetMode(r)==2)then e=1;end reaper.PreventUIRefresh(e);for e=1,e do reaper.MIDIEditor_OnCommand(r,a);end reaper.PreventUIRefresh(-1);reaper.UpdateArrange();