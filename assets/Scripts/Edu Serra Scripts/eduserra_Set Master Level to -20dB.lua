-- ReaScript Name: Set Master Volume to -20dB
-- Description: Sets the master fader to -20 dB
-- Author: YourName
-- Version: 1.0

function SetMasterFaderMinus20dB()
  -- Get master track (index 0)
  local masterTrack = reaper.GetMasterTrack(0)
  
  -- Calculate linear gain for -20 dB
  local linearGain = 10 ^ (-20 / 20)  -- which is 0.1

  -- Set master track volume
  reaper.SetMediaTrackInfo_Value(masterTrack, "D_VOL", linearGain)
  
  -- Optional feedback message
  reaper.ShowMessageBox("Master fader set to -20 dB", "ReaScript", 0)
end

-- Execute the function
SetMasterFaderMinus20dB()

--[[
  How to Install and Use in Reaper:
  1. Go to Actions > Show Action List
  2. Click 'New Action...' > 'Load ReaScript...'
  3. Pick this file and click 'Open'
  4. Select it in the Actions List and click 'Run'
]]--

