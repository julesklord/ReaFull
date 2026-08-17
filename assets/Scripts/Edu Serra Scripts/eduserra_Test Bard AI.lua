--[[
Name: Toggle FX Bypass for all selected tracks
Description: This script will toggle the FX bypass for all selected tracks in REAPER.
Author: Microsoft Bing
Prompt by: EDU SERRA
]]

-- Function to toggle FX bypass for all selected tracks
function main()
  -- Loop through all selected tracks
  for i = 0, reaper.CountSelectedTracks(0) - 1 do
    -- Get the current selected track
    local track = reaper.GetSelectedTrack(0, i)
    -- Get the current FX bypass value (0 = off, 1 = on)
    local fx_bypass = reaper.GetMediaTrackInfo_Value(track, "I_FXEN")
    -- If FX bypass is on, turn it off
    if fx_bypass == 1 then
      reaper.SetMediaTrackInfo_Value(track, "I_FXEN", 0)
    else
      -- If FX bypass is off, turn it on
      reaper.SetMediaTrackInfo_Value(track, "I_FXEN", 1)
    end
  end
end

-- Begin undo block
reaper.Undo_BeginBlock()
-- Run the main function
main()
-- End undo block and give it a name for the undo history
reaper.Undo_EndBlock("Toggle FX Bypass for all selected tracks", -1)
