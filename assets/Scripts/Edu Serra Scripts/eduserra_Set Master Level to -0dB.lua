-- ReaScript Name: Set Master Volume to 0dB
-- Description: Sets the master fader to 0 dB (unity gain)
-- Author: YourName
-- Version: 1.0

function SetMasterFaderZeroDB()
  -- Get master track (index 0)
  local masterTrack = reaper.GetMasterTrack(0)
  
  -- Calculate linear gain for 0 dB
  local linearGain = 10 ^ (0 / 20)  -- which is 1.0

  -- Set master track volume
  reaper.SetMediaTrackInfo_Value(masterTrack, "D_VOL", linearGain)
  
  -- Optional message box feedback
  reaper.ShowMessageBox("Master fader set to 0 dB (unity)", "ReaScript", 0)
end

-- Execute the function
SetMasterFaderZeroDB()

--[[
Usage:
1. Open Reaper’s Action List (Actions > Show Action List).
2. Click 'New Action...' > 'Load ReaScript...'.
3. Select this file, load it, and then run it.
]]--

