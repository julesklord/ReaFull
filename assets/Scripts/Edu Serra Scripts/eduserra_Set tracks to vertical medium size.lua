--[[
Name: Set vertical zoom size of all tracks (except locked height tracks) to 64 pixels
Date: August 5, 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Set the desired track height in pixels
local track_height = 64

-- Get the number of tracks in the project
local num_tracks = reaper.CountTracks(0)

-- Loop through all tracks and set their height (if not locked)
for i = 0, num_tracks - 1 do
    local track = reaper.GetTrack(0, i)
    local height_lock = reaper.GetMediaTrackInfo_Value(track, "B_HEIGHTLOCK")
    if height_lock == 0 then
        reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", track_height)
    end
end

-- Update the arrange view to reflect the changes
reaper.UpdateArrange()

-- Force Reaper to redraw the track list
reaper.TrackList_AdjustWindows(false)

