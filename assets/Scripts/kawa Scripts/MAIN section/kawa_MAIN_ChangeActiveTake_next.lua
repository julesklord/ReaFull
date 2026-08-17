--[[ 
* ReaScript Name: kawa_MAIN_ChangeActiveTake_next. 
* Version: 2017/06/29 
* Author: kawa_ 
* link: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
local function e(e)if(e==nil)then reaper.ShowConsoleMsg("nil".."\n");else reaper.ShowConsoleMsg(tostring(e).."\n");end end local o=1;local l=0;local a=reaper.CountSelectedMediaItems(l);local e=0;while(e<a)do local l=reaper.GetSelectedMediaItem(l,e);local a=reaper.GetMediaItemInfo_Value(l,"I_CURTAKE");local r=reaper.GetMediaItemNumTakes(l);local a=math.abs((a+o)%r);local l=reaper.SetMediaItemInfo_Value(l,"I_CURTAKE",a);e=e+1;end reaper.UpdateArrange();