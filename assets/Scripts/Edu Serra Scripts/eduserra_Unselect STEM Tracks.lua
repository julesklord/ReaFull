--[[
Name: Unselect Tracks with STEM in Name
Date: 26 Jul 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Function to unselect all tracks with the word "STEM" in their name
function unselectTracksWithSTEM()
    -- Get the number of tracks
    local num_tracks = reaper.CountTracks(0)
    -- Loop through all tracks
    for i = 0, num_tracks - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)
        -- Get the track name
        local retval, track_name = reaper.GetTrackName(track)
        -- Check if the track name contains the word "STEM"
        if string.find(track_name, "STEM") then
            -- Unselect the track
            reaper.SetTrackSelected(track, false)
        end
    end
end

-- Call the function to unselect all tracks with the word "STEM" in their name
unselectTracksWithSTEM()


