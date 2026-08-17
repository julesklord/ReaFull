--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_ScreenSet_Prev. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local t="kawa_MainClip"local o="last_window_set"local e=40454 local l=40455 local l=40456 local l=40457 local l=40458 local l=40459 local l=40460 local l=40461 local l=40462 local a=40463 local l=0 function StepWindowSet(n)local l=reaper.GetExtState(t,o);if(l==""or l==nil)then l=a else l=tonumber(l)or a end local l=l+n;if(l>a)then l=e end if(l<e)then l=a end reaper.Main_OnCommand(l,0)reaper.SetExtState(t,o,tostring(l),false);end local l=-1 StepWindowSet(l)