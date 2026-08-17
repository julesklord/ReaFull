-- Name: Normalize selected items to -8dBFS peak level
-- Date: 20 Jun 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- This script normalizes selected items in the Reaper DAW to -8dBFS peak level.

-- Check if the SWS/S&M extension is installed
if not reaper.NF_AnalyzeTakeLoudness then
  reaper.ShowMessageBox("This script requires the SWS/S&M extension.", "Error", 0)
  return
end

-- Set the target peak level
local target_peak = -8

-- Get the number of selected items
local num_items = reaper.CountSelectedMediaItems(0)

-- Iterate over all selected items
for i = 0, num_items - 1 do
  -- Get the item
  local item = reaper.GetSelectedMediaItem(0, i)
  
  -- Get the item's take
  local take = reaper.GetActiveTake(item)
  
  -- Check if the take is valid
  if take ~= nil then
    -- Analyze the take's loudness
    local analyze = reaper.NF_AnalyzeTakeLoudness(take)
    
    -- Check if the analysis was successful
    if analyze then
      -- Get the take's peak level
      local peak = reaper.NF_GetMediaItemMaxPeak(take)
      
      -- Calculate the necessary gain adjustment
      local gain = target_peak - (20 * math.log(peak, 10))
      
      -- Apply the gain adjustment to the take
      reaper.SetMediaItemTakeInfo_Value(take, "D_VOL", math.exp(gain * 0.11512925464970228420089957273422))
    end
  end
end

-- Update the arrange view
reaper.UpdateArrange()

