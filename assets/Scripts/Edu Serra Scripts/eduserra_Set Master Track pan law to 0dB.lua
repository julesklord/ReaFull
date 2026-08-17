--[[
Name: Set Master Track Pan Law to 0dB
Date: 26 Jul 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Function to set Master Track Pan Law to 0dB
function setMasterTrackPanLawToZero()
    -- Get the master track
    local master_track = reaper.GetMasterTrack(0)
    -- Set the pan law of the master track to 0dB
    reaper.SetMediaTrackInfo_Value(master_track, "D_PANLAW", 1)
end

-- Call the function to set Master Track Pan Law to 0dB
setMasterTrackPanLawToZero()

