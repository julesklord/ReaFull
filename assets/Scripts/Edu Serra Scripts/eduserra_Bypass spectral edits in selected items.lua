--[[
Script Name: Bypass Spectral Edits in Selected Items
Description: This script bypasses all spectral edits in selected items in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

-- Get the number of selected items
local num_selected_items = reaper.CountSelectedMediaItems(0)

-- Loop through each selected item
for i = 0, num_selected_items - 1 do
  -- Get the current selected item
  local item = reaper.GetSelectedMediaItem(0, i)

  -- Get the number of takes in the item
  local num_takes = reaper.CountTakes(item)

  -- Loop through each take
  for j = 0, num_takes - 1 do
    -- Get the current take
    local take = reaper.GetTake(item, j)

    -- Check if the take has spectral edits
    local spectral_power = reaper.GetMediaItemTakeInfo_Value(take, "I_SPECTRAL_POWER")
    if spectral_power > 0 then
        reaper.SetMediaItemTakeInfo_Value(take, "I_SPECTRAL_POWER", 0)
    end
  end
end

-- Update the Reaper project
reaper.UpdateArrange()

