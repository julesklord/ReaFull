--[[
Name: Remove all FX with the specified name in selected tracks
Date: 01 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Set the FX name to search for
local FXName = "Tape"

-- Begin an undo block
reaper.Undo_BeginBlock()

-- Count the number of selected tracks
local trackCount = reaper.CountSelectedTracks(0)

-- Iterate over each selected track
for i = 0, trackCount - 1 do
    -- Get the current track
    local track = reaper.GetSelectedTrack(0, i)
    
    -- Count the number of FX on the current track
    local fxCount = reaper.TrackFX_GetCount(track)
    
    -- Iterate over each FX on the current track in reverse order
    for j = fxCount - 1, 0, -1 do
        -- Get the name of the current FX
        local retval, fxName = reaper.TrackFX_GetFXName(track, j, "")
        
        -- Check if the FX name contains the specified FX name
        if string.find(fxName, FXName) then
            -- Remove the FX from the track
            reaper.TrackFX_Delete(track, j)
        end
    end
end

-- Update the UI to reflect changes
reaper.UpdateTimeline()

-- End the undo block and add it to Reaper's undo history
reaper.Undo_EndBlock("Remove " .. FXName .. " in selected tracks", -1)

