--[[
* ReaScript Name: Start and End Markers
* Author: tonalstates
* Version: 1.0
* Mod by Edu Serra
]]--

local function main()
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

reaper.Main_OnCommand(41173, 0)
reaper.Main_OnCommand(40290, 0)
reaper.Main_OnCommand(57195, 0)
reaper.Main_OnCommand(41173, 0)
reaper.Main_OnCommand(69983, 0)
reaper.Main_OnCommand(40898, 0)
reaper.Main_OnCommand(66738, 0)

reaper.Undo_EndBlock('Start and End Markers', 0)
reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()
reaper.UpdateTimeline()
end

main()

