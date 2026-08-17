-- Name: Select all tracks in group when selecting any track that belongs to the same group
-- Date: 10th November, 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of selected tracks
    local numSelTracks = reaper.CountSelectedTracks(0)

    -- If there are no selected tracks, do nothing
    if numSelTracks == 0 then return end

    -- Get the first selected track
    local selTrack = reaper.GetSelectedTrack(0, 0)

    -- Get the group membership of the selected track
    local selTrackGroup = nil
    local categories = {"VOLUME", "PAN", "MUTE", "SOLO", "RECARM", "POLARITY", "AUTOMODE"}
    for i = 0, 31 do
        for _, category in ipairs(categories) do
            if reaper.GetSetTrackGroupMembership(selTrack, i, category) then
                selTrackGroup = i
                break
            end
        end
        if selTrackGroup ~= nil then break end
    end

    -- If the selected track is not in a group, do nothing
    if selTrackGroup == nil then return end

    -- Get the number of tracks in the project
    local numTracks = reaper.CountTracks(0)

    -- Loop through all tracks
    for i = 0, numTracks - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- If the track shares the same group membership with the selected track, select it
        for _, category in ipairs(categories) do
            if reaper.GetSetTrackGroupMembership(track, selTrackGroup, category) then
                reaper.SetTrackSelected(track, true)
                break
            end
        end
    end
end

-- Run the main function
main()

