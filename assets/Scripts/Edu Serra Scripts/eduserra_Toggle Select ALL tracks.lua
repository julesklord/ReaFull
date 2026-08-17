--[[
Name: Toggle Select Visible Tracks
Date: 2021-12-01
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Define a function to check if all visible tracks are selected
local function are_visible_tracks_selected()
    -- Get the number of tracks in the project
    local track_count = reaper.CountTracks(0)

    -- Loop through all tracks in the project
    for i = 0, track_count - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- Check if the track is visible in either the mixer or arrange view
        local shown_in_mixer = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINMIXER")
        local shown_in_tcp = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINTCP")

        if shown_in_mixer == 1 or shown_in_tcp == 1 then
            -- If it is visible, check if it is selected
            local is_selected = reaper.IsTrackSelected(track)

            -- If it is not selected, return false
            if not is_selected then
                return false
            end
        end
    end

    -- If all visible tracks are selected, return true
    return true
end

-- Check if all visible tracks are selected
local visible_tracks_selected = are_visible_tracks_selected()

-- Get the number of tracks in the project
local track_count = reaper.CountTracks(0)

-- Loop through all tracks in the project
for i = 0, track_count - 1 do
    -- Get the current track
    local track = reaper.GetTrack(0, i)

    -- Check if the track is visible in either the mixer or arrange view
    local shown_in_mixer = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINMIXER")
    local shown_in_tcp = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINTCP")

    if shown_in_mixer == 1 or shown_in_tcp == 1 then 
        -- If it is visible toggle its selection state depending on whether or not all visible tracks are currently selected.
        reaper.SetTrackSelected(track, not visible_tracks_selected)
    end 
end 

