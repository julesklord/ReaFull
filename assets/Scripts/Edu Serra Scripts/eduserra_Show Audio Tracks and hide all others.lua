--[[
Name: Show only tracks with ª in the title
Date: 2021-12-01
Author: Edu Serra
Prompt: Edu Serra www.amaudio.co
]]

-- Get the number of tracks in the project
local track_count = reaper.CountTracks(0)

-- Loop through all tracks in the project
for i = 0, track_count - 1 do
    -- Get the current track
    local track = reaper.GetTrack(0, i)
    
    -- Get the name of the current track
    local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    
    -- Check if the track name contains the symbol ª
    if string.find(track_name, "ª") then
        -- If it does, show the track
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", 1)
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINTCP", 1)
    else
        -- If it doesn't, hide the track
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", 0)
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINTCP", 0)
    end
end

-- Update the arrange view and mixer to reflect the changes
reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()
reaper.UpdateArrange()
