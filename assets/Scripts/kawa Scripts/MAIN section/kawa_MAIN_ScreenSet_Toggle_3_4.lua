--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_ScreenSet_Toggle_3_4. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local t="kawa_MainClip"local c="last_window_set"local a=40454 local l=40455 local l=40456 local l=40457 local l=40458 local l=40459 local l=40460 local l=40461 local l=40462 local e=40463 local l=0 function ToggleScreenSetAB(o,n)local l=reaper.GetExtState(t,c);if(l==""or l==nil)then l=e else l=tonumber(l)or e end local e;if(l~=a+o)then e=a+o else e=a+n end reaper.Main_OnCommand(e,0)reaper.SetExtState(t,c,tostring(e),false);end ToggleScreenSetAB(2,3)