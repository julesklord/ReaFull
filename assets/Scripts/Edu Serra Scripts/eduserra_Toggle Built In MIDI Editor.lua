--[[
Name: Toggle built-in MIDI editor
Date: 2022-11-15
Author: Microsoft Bing
Prompt: Edu Serra www.amaudio.co
]]

-- Get active MIDI editor
local hwnd = reaper.MIDIEditor_GetActive()

if hwnd then
    -- Close MIDI editor if it's open
    reaper.MIDIEditor_OnCommand(hwnd, 2) -- File: Close window
else
    -- Open MIDI editor if it's not open
    reaper.Main_OnCommand(40153, 0) -- View: Open MIDI editor
end

