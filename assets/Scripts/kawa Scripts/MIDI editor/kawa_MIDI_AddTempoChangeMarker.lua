--[[ 
* ReaScript Name: kawa_MIDI_AddTempoChangeMarker. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local e=0;local s="kawa MIDI addBPMMarker "local function m()local e=120;local n=reaper.GetCursorPosition();local r=0;local e=reaper.CountTempoTimeSigMarkers(r)+1;local i,l,e=reaper.TimeMap_GetTimeSigAtTime(r,n);local o,e=reaper.GetUserInputs("Add BPM Marker",7,"BPM( 60 ~ 300 ),Time Sig , / Time Sig Denom",tostring(e)..","..tostring(i)..","..tostring(l)..",".."--,--,--,--")if(o==nil or o==false)then return end local p=tonumber(e:split(",")[1]or"120")or 120 local a=0 local t=0 if(e:split(",")[2]~=nil and e:split(",")[3]~=nil and e:split(",")[2]~=""and e:split(",")[3]~=""and(i~=tonumber(e:split(",")[2])or l~=tonumber(e:split(",")[3])))then a=math.floor(tonumber(e:split(",")[2]or"4"))or 4 t=math.floor(tonumber(e:split(",")[3]or"4"))or 4 end reaper.Undo_BeginBlock();o=reaper.SetTempoTimeSigMarker(r,-1,n,-1,-1,p,a,t,false)reaper.Undo_EndBlock(s,-1);reaper.UpdateArrange();end m();