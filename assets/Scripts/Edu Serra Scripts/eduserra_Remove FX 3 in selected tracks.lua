-- Name: Remove FX 3 from selected tracks
-- Date: 02 Nov 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of selected tracks
    local count = reaper.CountSelectedTracks(0)

    -- Iterate over each selected track
    for i = 0, count - 1 do
        -- Get the current selected track
        local track = reaper.GetSelectedTrack(0, i)

        -- Check if the track has at least one FX
        if reaper.TrackFX_GetCount(track) > 0 then
            -- Remove FX 3
            reaper.TrackFX_Delete(track, 2)
        end
    end

    -- Create an undo point so that this action can be undone
    reaper.Undo_OnStateChange("Remove FX 3 from selected tracks")
end

-- Call the main function
main()
