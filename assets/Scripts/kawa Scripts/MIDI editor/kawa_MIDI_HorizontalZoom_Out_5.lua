--[[ 
* ReaScript Name: kawa_MIDI_HorizontalZoom_Out_5. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local e=1011 local r=1012 local r=reaper.MIDIEditor_GetActive();local a=e;local e=5;if(reaper.MIDIEditor_GetMode(r)==2)then e=1;end reaper.PreventUIRefresh(e);for e=1,e do reaper.MIDIEditor_OnCommand(r,a);end reaper.PreventUIRefresh(-1);reaper.UpdateArrange();