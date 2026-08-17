--[[
Name: Rename Selected Track to GUIDE
Date: 29 October 2023
Author: Bing Chat
Prompt: Edu Serra www.eduserra.net
]]

-- Function to rename selected track
function renameSelectedTrack()
    -- Get the number of selected tracks
    local count = reaper.CountSelectedTracks(0)

    -- If there is at least one track selected
    if count > 0 then
        -- Get the first selected track (index is 0-based)
        local track = reaper.GetSelectedTrack(0, 0)

        -- Rename the track to "GUIDE"
        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "GUIDE", true)
    else
        -- Display a message if no track is selected
        reaper.ShowMessageBox("No track selected. Please select a track.", "Error", 0)
    end
end

-- Call the function to rename selected track
renameSelectedTrack()

