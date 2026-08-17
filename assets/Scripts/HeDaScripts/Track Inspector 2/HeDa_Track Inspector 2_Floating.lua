--[[
   * ReaScript Name: Track Inspector
   * Author: Hector Corcin (HeDa)
   * Author URI: http://reaper.hector-corcin.com
   * Licence: Copyright © 2016-2024, Hector Corcin
]]


instance = 3  -- change to another number in a copy of this file to allow another instance
master_track = false -- (true or false) change to true to always start with master track
sectionname="HeDaTrackInspectorFloating"
open_at_mouse=true
open_at_mouse_position="_BR_MOVE_WINDOW_TO_MOUSE_H_R_V_M"

-----------------------------------------------------------------
OS = reaper.GetOS()
local mode="x64"
if OS == "Win32" or OS == "OSX32" then mode="x32" end
local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
script_path2 = script_path:match("(.*) settings")
if script_path2 then 
	custom_instance=instance
	script_path=script_path2 .. "/"
end
resourcepath=reaper.GetResourcePath()
scripts_path=resourcepath.."/Scripts/"
hedascripts_path=scripts_path.."HeDaScripts/"
REAPERv = tonumber(reaper.GetAppVersion():match("^(%d+)%..*"))
local v7=""
if REAPERv then 
   if REAPERv>=7 then 
      v7="_7"
   end
end
dofile(script_path .. "HTI" .. mode .. v7 .. ".dat")