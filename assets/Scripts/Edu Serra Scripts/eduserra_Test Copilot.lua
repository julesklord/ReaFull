--[[
Name:
Date:
Author:
Prompt: Edu Serra www.amaudio.co
]]

-- This script toggles the bypass state of all FX with the name "ReaEQ" in the selected tracks.

-- Get the number of selected tracks
local num_tracks = reaper.CountSelectedTracks(0)

-- Loop through all selected tracks
for i = 0, num_tracks - 1 do
  -- Get the current track
  local track = reaper.GetSelectedTrack(0, i)
  
  -- Get the number of FX in the current track
  local num_fx = reaper.TrackFX_GetCount(track)
  
  -- Loop through all FX in the current track
  for j = 0, num_fx - 1 do
    -- Get the name of the current FX
    local _, fx_name = reaper.TrackFX_GetFXName(track, j, "")
    
    -- Check if the FX name is "ReaEQ"
    if fx_name:find("ReaEQ") then
      -- Get the current bypass state of the FX (0 = not bypassed, 1 = bypassed)
      local bypass_state = reaper.TrackFX_GetEnabled(track, j)
      
      -- Toggle the bypass state of the FX
      reaper.TrackFX_SetEnabled(track, j, not bypass_state)
    end
  end
end

-- Update the UI to reflect any changes made by the script
reaper.UpdateArrange()

