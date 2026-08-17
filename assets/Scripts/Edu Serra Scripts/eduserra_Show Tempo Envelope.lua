--[[
Name: Show Master Tempo Envelope
Date: 01 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Script: Show Master Tempo Envelope

-- Begin undo block
reaper.Undo_BeginBlock()

-- Check if the master tempo envelope is currently hidden
local envelope_state = reaper.GetToggleCommandState(41046)

-- If the master tempo envelope is hidden, show it
if envelope_state == 0 then
  reaper.Main_OnCommand(41046, 0)
end

-- End undo block
reaper.Undo_EndBlock("Show Master Tempo Envelope", -1)

