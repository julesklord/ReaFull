--[[
Name: Toggle Select MIDI tracks
Date: 2021-12-01
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Set the symbol to look for in track names
local symbol = "*"

-- Define a function to check if all tracks with the specified symbol in their name are selected
local function are_tracks_with_symbol_selected()
    -- Get the number of tracks in the project
    local track_count = reaper.CountTracks(0)

    -- Loop through all tracks in the project
    for i = 0, track_count - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- Get the name of the current track
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

        -- Check if the track name contains the specified symbol
        if string.find(track_name, symbol) then
            -- If it does, check if the track is selected
            local is_selected = reaper.IsTrackSelected(track)

            -- If the track is not selected, return false
            if not is_selected then
                return false
            end
        end
    end

    -- If all tracks with the specified symbol in their name are selected, return true
    return true
end

-- Check if all tracks with the specified symbol in their name are selected
local tracks_with_symbol_selected = are_tracks_with_symbol_selected()

-- Get the number of tracks in the project
local track_count = reaper.CountTracks(0)

-- Loop through all tracks in the project
for i = 0, track_count - 1 do
    -- Get the current track
    local track = reaper.GetTrack(0, i)

    -- Get the name of the current track
    local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

    -- Check if the track name contains the specified symbol
    if string.find(track_name, symbol) then
        -- If it does, toggle its selection state depending on whether or not all tracks with the symbol are currently selected.
        reaper.SetTrackSelected(track, not tracks_with_symbol_selected)
    end 
end 

