--[[
Name: Show Grid
Date: 01 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Script: Show Grid

-- Begin undo block
reaper.Undo_BeginBlock()

-- Check if the grid is currently hidden
local grid_state = reaper.GetToggleCommandState(40145)

-- If the grid is hidden, show it
if grid_state == 0 then
  reaper.Main_OnCommand(40145, 0)
end

-- End undo block
reaper.Undo_EndBlock("Show Grid", -1)

