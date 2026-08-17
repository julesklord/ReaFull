-- Name: Set Master track height to ReArtist Default
-- Date: 24-10-2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the master track
    local master_track = reaper.GetMasterTrack(0)

    -- Set the height of the master track in TCP to 100
    reaper.SetMediaTrackInfo_Value(master_track, "I_HEIGHTOVERRIDE", 100)

    -- Force a screen update to reflect changes in track height
    reaper.TrackList_AdjustWindows(false)
end

main()

