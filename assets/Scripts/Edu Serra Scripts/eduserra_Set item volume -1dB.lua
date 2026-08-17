-- Name: Lower 1 dB volume down for selected items
-- Date: 30-10-2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

function main()
    -- Get the number of selected media items
    local count = reaper.CountSelectedMediaItems(0)

    -- If no items are selected, show an error message and exit
    if count == 0 then
        reaper.ShowMessageBox("There are no selected items. Please select items and run the action again.", "Error", 0)
        return
    end

    -- Iterate over each selected media item
    for i = 0, count - 1 do
        -- Get the media item
        local item = reaper.GetSelectedMediaItem(0, i)

        -- Get the current volume (in dB)
        local vol = reaper.GetMediaItemInfo_Value(item, "D_VOL")

        -- Convert volume from amplitude to dB, subtract 1 dB, and convert back to amplitude
        local newVol = 10 ^ ((20 * math.log(vol, 10) - 1) / 20)

        -- Set the new volume
        reaper.SetMediaItemInfo_Value(item, "D_VOL", newVol)
    end

    -- Update the arrangement (so changes are visible)
    reaper.UpdateArrange()
end

-- Call the main function
main()

