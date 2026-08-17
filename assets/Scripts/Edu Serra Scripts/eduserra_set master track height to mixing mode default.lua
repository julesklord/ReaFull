-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net


-- Set the desired track height in pixels
local track_height = 64

-- Get the master track
local track = reaper.GetMasterTrack(0)

-- Check if the height is locked
local height_lock = reaper.GetMediaTrackInfo_Value(track, "B_HEIGHTLOCK")

-- If not locked, set the height
if height_lock == 0 then
    reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", track_height)
end

-- Update the arrange view to reflect the changes
reaper.UpdateArrange()

-- Force Reaper to redraw the track list
reaper.TrackList_AdjustWindows(false)

