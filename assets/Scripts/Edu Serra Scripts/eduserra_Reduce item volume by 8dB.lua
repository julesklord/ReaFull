-- Name: Reduce item volume by -8dB
-- Date: 20 Jun 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.amaudio.co

-- This script reduces the volume of selected items in the Reaper DAW by -8dB.

-- Set the volume reduction in dB
local vol_reduction_db = -7

-- Convert the volume reduction from dB to a linear scale factor
local vol_reduction = 10^(vol_reduction_db/20)

-- Get the number of selected items
local num_items = reaper.CountSelectedMediaItems(0)

-- Iterate over all selected items
for i = 0, num_items - 1 do
  -- Get the item
  local item = reaper.GetSelectedMediaItem(0, i)
  
  -- Get the item's current volume
  local vol = reaper.GetMediaItemInfo_Value(item, "D_VOL")
  
  -- Calculate the new volume
  local new_vol = vol * vol_reduction
  
  -- Set the item's new volume
  reaper.SetMediaItemInfo_Value(item, "D_VOL", new_vol)
end

-- Update the arrange view
reaper.UpdateArrange()

