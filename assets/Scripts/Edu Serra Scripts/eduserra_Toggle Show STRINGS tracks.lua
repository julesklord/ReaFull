--[[
Name: Toggle Show STRINGS Tracks
Date: 2021-12-01
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Set the symbol to look for in track names
local symbol = "~"

-- Define a function to check if all tracks without the specified symbol in their name are hidden
local function are_tracks_without_symbol_hidden()
    -- Get the number of tracks in the project
    local track_count = reaper.CountTracks(0)

    -- Loop through all tracks in the project
    for i = 0, track_count - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- Get the name of the current track
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

        -- Check if the track name does not contain the specified symbol
        if not string.find(track_name, symbol) then
            -- If it doesn't, check if the track is shown in the mixer or arrange view
            local shown_in_mixer = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINMIXER")
            local shown_in_tcp = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINTCP")

            -- If the track is shown in either view, return false
            if shown_in_mixer == 1 or shown_in_tcp == 1 then
                return false
            end
        end
    end

    -- If all tracks without the specified symbol in their name are hidden, return true
    return true
end

-- Check if all tracks without the specified symbol in their name are hidden
local tracks_without_symbol_hidden = are_tracks_without_symbol_hidden()

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
        -- If it does, show the track in both views regardless of the toggle state and select it if tracks without symbol are hidden.
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", 1)
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINTCP", 1)
        if tracks_without_symbol_hidden then 
            reaper.SetTrackSelected(track, false)
        else 
            reaper.SetTrackSelected(track,true)
        end 
    else 
        -- If it doesn't contain the symbol show or hide it depending on toggle state.
        if tracks_without_symbol_hidden then 
            reaper.SetMediaTrackInfo_Value(track,"B_SHOWINMIXER",1)
            reaper.SetMediaTrackInfo_Value(track,"B_SHOWINTCP",1)
        else 
            reaper.SetMediaTrackInfo_Value(track,"B_SHOWINMIXER",0)
            reaper.SetMediaTrackInfo_Value(track,"B_SHOWINTCP",0)
        end 
    end 
end 

-- Update arrange view and mixer to reflect changes.
reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()

