--[[
Name: Insert 4 bar empty MIDI item at cursor on selected tracks
Date: 05 Jul 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Get the current position of the edit cursor
local cursor_pos = reaper.GetCursorPosition()

-- Get the number of selected tracks
local num_selected_tracks = reaper.CountSelectedTracks(0)

-- Loop through all selected tracks
for i = 0, num_selected_tracks - 1 do
    -- Get the current selected track
    local track = reaper.GetSelectedTrack(0, i)
    
    -- Insert a new MIDI item at the cursor position with a length of 4 bars (4 * quarter notes per bar * seconds per quarter note)
    local item = reaper.CreateNewMIDIItemInProj(track, cursor_pos, cursor_pos + 4 * 4 * reaper.TimeMap2_QNToTime(0, 1))
    
    -- Select the new item
    reaper.SetMediaItemSelected(item, true)
    
    -- Open the MIDI editor for the new item
    local editor = reaper.MIDIEditor_GetActive()
    if not editor then
        editor = reaper.MIDIEditor_OnCommand(reaper.MIDIEditor_GetActive(), 40153) -- Open in built-in MIDI editor
    end
    
    -- Set the MIDI editor to the new item
    reaper.MIDIEditor_OnCommand(editor, 40850) -- Set active MIDI item from arrange view
    
end

-- Update the arrange view to show the new items
reaper.UpdateArrange()

