--[[
Name: Close lateral toolbars
Date: 24-10-2023
Author: Bing
Prompt: Edu Serra www.amaudio.co
--]]

-- Define a no_undo function to prevent the script from being undone
local function no_undo() reaper.defer(function() end) end

-- Define a table that maps toolbar numbers to their corresponding command IDs
local Toolbar_T = {[0]=41651, [1]=41679, [2]=41680, [3]=41681, [4]=41682, [5]=41683, [6]=41684, [7]=41685,
                   [8]=41686, [9]=41936, [15]=41942, [16]=41943, [17]=42713, [20]=42716, [21]=42717, [22]=42718, [23]=42719, [24]=42720} -- Corrected the index for toolbar 20

-- Check if the top docker is visible and hide it if it is
local stateTopDock = (reaper.GetToggleCommandState(41297) == 1)
if stateTopDock then
    reaper.Main_OnCommand(41297, 0)
end

-- Iterate over the specified toolbar numbers and close each toolbar if it is visible
for _, numbToolbar in ipairs({1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 17, 20, 21, 22, 23, 24}) do
    local commandId = Toolbar_T[numbToolbar]
    if commandId then
        local state = reaper.GetToggleCommandState(commandId)
        if state == 1 then
            reaper.Main_OnCommand(commandId, 0)
        end
    else
        reaper.ShowConsoleMsg("Error: Command ID for toolbar " .. numbToolbar .. " not found.\n")
    end
end

-- Disable UI refresh prevention
reaper.PreventUIRefresh(-1)

-- Call the no_undo function to prevent the action from being undone
no_undo()

