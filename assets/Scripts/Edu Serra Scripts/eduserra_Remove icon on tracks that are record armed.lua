-- Name: Delete track icon from tracks that are record armed
-- Date: 07 Nov 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of tracks in the project
    local count = reaper.CountTracks(0)

    -- Iterate over each track
    for i = 0, count - 1 do
        -- Get the current track
        local track = reaper.GetTrack(0, i)

        -- Check if the track is record armed
        local recArm = reaper.GetMediaTrackInfo_Value(track, "I_RECARM")

        -- If the track is record armed
        if recArm == 1.0 then
            -- Check if the track has an icon
            local _, icon = reaper.GetSetMediaTrackInfo_String(track, "P_ICON", "", false)

            -- If the track has an icon
            if icon ~= "" then
                -- Remove the icon
                reaper.GetSetMediaTrackInfo_String(track, "P_ICON", "", true)
            end
        end
    end
end

-- Call the main function
main()

