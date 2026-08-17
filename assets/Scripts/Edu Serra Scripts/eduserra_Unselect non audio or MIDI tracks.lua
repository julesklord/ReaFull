--[[
Name: Unselect Tracks with Specified Words in Name
Date: 26 Jul 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Function to unselect all tracks with any of the specified words in their name
function unselectTracksWithSpecifiedWords()
    -- Define the list of words to check for
    local words = {"MASTER", "MIX", "STEM", "FOL", "AUX", "BUS", "FX", "PHONES", "VIDEO"}
    -- Get the number of tracks
    local num_tracks = reaper.CountTracks(0)
    -- Loop through all tracks
    for i = 0, num_tracks - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)
        -- Get the track name
        local retval, track_name = reaper.GetTrackName(track)
        -- Loop through all words in the list
        for _, word in ipairs(words) do
            -- Check if the track name contains the current word
            if string.find(track_name, word) then
                -- Unselect the track
                reaper.SetTrackSelected(track, false)
                -- Break out of the inner loop (no need to check for other words)
                break
            end
        end
    end
end

-- Call the function to unselect all tracks with any of the specified words in their name
unselectTracksWithSpecifiedWords()

