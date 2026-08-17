--[[
 * ReaScript Name: AM Stereo Maker Full
 * Author: Edu SErra
 * Version: 1.0
]]--

local function main()
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()

  reaper.Main_OnCommand(40062, 0)
  reaper.Main_OnCommand(54011, 0)
  reaper.Main_OnCommand(41275, 0)
  reaper.Main_OnCommand(67166, 0)
  reaper.Main_OnCommand(40206, 0)
  reaper.Main_OnCommand(53682, 0)
  reaper.Main_OnCommand(54011, 0)
  reaper.Main_OnCommand(67091, 0)
  reaper.Main_OnCommand(42432, 0)
  reaper.Main_OnCommand(56579, 0)
  reaper.Main_OnCommand(56580, 0)
  reaper.Main_OnCommand(53679, 0)
  reaper.Main_OnCommand(40005, 0)

  reaper.Undo_EndBlock('AM Stereo Maker Full', 0)
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.UpdateTimeline()
end

main()