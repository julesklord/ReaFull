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

        -- Check if the track is selected
        if reaper.IsTrackSelected(track) == false then
            -- If not selected, hide it from TCP and MCP
            reaper.SetMediaTrackInfo_Value(track, "B_SHOWINTCP", 0)
            reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", 0)
        end
    end

    -- Force a screen update to reflect changes in track visibility
    reaper.TrackList_AdjustWindows(false)

    -- Apply action with command ID 40913 to move selected tracks to top of TCP
    reaper.Main_OnCommand(40913, 0)
end

main()


