--[[
Script Name: Disable SOLO state for selected tracks
Description: This script disables the solo state for all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

-- Get the number of selected tracks
numSelectedTracks = reaper.CountSelectedTracks(0)

-- Iterate through each selected track
for i = 0, numSelectedTracks-1 do
    -- Get the track
    track = reaper.GetSelectedTrack(0, i)
    -- Set the solo state to disabled
    reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
end
