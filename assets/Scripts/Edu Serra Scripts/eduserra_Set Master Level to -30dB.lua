-- ReaScript Name: Set Master Volume to -30dB
-- Description: Sets the master fader to -30 dB
-- Author: YourName
-- Version: 1.0

function SetMasterFaderMinus30dB()
  -- Get master track (index 0)
  local masterTrack = reaper.GetMasterTrack(0)
  
  -- Calculate linear gain for -30 dB
  local linearGain = 10 ^ (-30 / 20)  -- ~0.0316227766

  -- Set master track volume
  reaper.SetMediaTrackInfo_Value(masterTrack, "D_VOL", linearGain)
  
  -- Optional message box feedback
  reaper.ShowMessageBox("Master fader set to -30 dB", "ReaScript", 0)
end

-- Execute the function
SetMasterFaderMinus30dB()

--[[
Usage in Reaper:
1. Go to Actions > Show Action List
2. Click 'New Action...' > 'Load ReaScript...'
3. Choose this file
4. Run it from the Actions List
]]--

