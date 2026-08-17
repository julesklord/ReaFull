-- Name: <put here the name of the script>
-- Date: <put here todays date>
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of tracks in the project
    local count = reaper.CountTracks(0)

    -- Iterate over each track
    for i = 0, count - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- Show track icon in TCP
        reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", 1)
    end

    -- Force a screen update to reflect changes in track visibility
    reaper.TrackList_AdjustWindows(false)
end

main()


