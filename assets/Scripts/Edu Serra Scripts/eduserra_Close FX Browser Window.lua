--[[
Name: Close FX Browser Window
Date: 05/26/2023
Author: Bing
Prompt: Edu Serra www.amaudio.co
]]

-- This function checks if the FX Browser is open and closes it if it is
local function closeFXBrowser()
    local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
    if ShowFXBrowser == 1 then;
        reaper.Main_OnCommand(40271,0);
    end;
end

-- Call the closeFXBrowser function to close the FX Browser if it is open
closeFXBrowser()

-- Avoid creating an undo point
reaper.defer(function() end)
