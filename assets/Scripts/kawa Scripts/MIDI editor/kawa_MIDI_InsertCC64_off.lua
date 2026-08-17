--[[ 
* ReaScript Name: kawa_MIDI_InsertCC64_off. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local r=reaper.MIDIEditor_GetActive();local e=reaper.MIDIEditor_GetTake(r);if(e==nil)then return end reaper.Undo_BeginBlock();local I=false local l=false local a=reaper.GetCursorPositionEx(0)local o=reaper.MIDI_GetPPQPosFromProjTime(e,a)local r=reaper.MIDIEditor_GetSetting_int(r,"default_note_chan");local a=176;local t=64;local n=math.floor(0);reaper.MIDI_InsertCC(e,I,l,o,a,r,t,n,true)reaper.MIDI_Sort(e);reaper.Undo_EndBlock("kawa MIDI Insert CC64 Off",-1);reaper.UpdateArrange();