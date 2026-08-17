--[[
Name: Unselect Tracks with Specific Words in Name
Date: 29 October 2023
Author: Bing Chat
Prompt: Edu Serra www.eduserra.net
]]

-- Function to unselect tracks with specific words in name
function unselectTracks()
    -- Get the number of tracks in the project
    local count = reaper.CountTracks(0)

    -- Loop through all tracks
    for i = 0, count - 1 do
        -- Get the track
        local track = reaper.GetTrack(0, i)

        -- Get the track name
        local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

        -- Check if the track name contains "MIX", "BUS", "STEM" or "FX"
        if string.find(name, "MIX") or string.find(name, "BUS") or string.find(name, "STEM") or string.find(name, "FX") then
            -- Unselect the track
            reaper.SetTrackSelected(track, false)
        end
    end
end

-- Call the function to unselect tracks
unselectTracks()

