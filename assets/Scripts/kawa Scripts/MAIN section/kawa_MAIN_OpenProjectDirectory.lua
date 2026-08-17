--====================================================================== 
--[[ 
* ReaScript Name: kawa_MAIN_OpenProjectDirectory. 
* Version: 2017/01/16 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* Repository: BitBucket - kawaCat - ReaScript-M2B 
* Repository URI: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
--====================================================================== 
local function n()local e="";local l=reaper.GetOS();if(l=="Win32"or l=="Win64")then e=" explorer "elseif(l=="OSX32"or l=="OSX64")then e=" open "elseif(l=="Other")then end local l=reaper.GetProjectPath("");e=e..'"'..l..'"'.." \n pause";os.execute(e);end n()