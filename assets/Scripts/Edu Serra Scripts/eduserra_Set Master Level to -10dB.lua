-- ReaScript Name: Set Master Volume to -10dB
-- Description: Sets the master fader to -10 dB
-- Author: YourName (replace with your name if you want)
-- Version: 1.0

function SetMasterFaderMinus10dB()
  -- Get master track (index 0)
  local masterTrack = reaper.GetMasterTrack(0)
  
  -- Calculate linear gain for -10 dB
  local linearGain = 10 ^ (-10 / 20)  -- about 0.316227766

  -- Set master track volume (D_VOL takes linear volume values)
  reaper.SetMediaTrackInfo_Value(masterTrack, "D_VOL", linearGain)
  
  -- Just for feedback in Reaper’s console (optional)
  reaper.ShowMessageBox("Master fader set to -10 dB", "ReaScript", 0)
end

-- Execute the function
SetMasterFaderMinus10dB()

--[[
  Installation/Usage:
  1. Open the Actions List in Reaper (Actions > Show Action List).
  2. Click 'New Action...' > 'Load ReaScript...'.
  3. Browse to this file, select it, and click 'Open'.
  4. You’ll see it appear as a new action.
  5. Run it by selecting it in the Actions List and clicking 'Run'.
]]--

