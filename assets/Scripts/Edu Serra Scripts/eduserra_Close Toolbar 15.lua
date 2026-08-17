--[[
Name: Close Toolbar 15
Date: 2021-12-01
Author: Edu Serra
Prompt: Edu Serra www.amaudio.co
]]

-- Define a no_undo function that defers an empty function to prevent the creation of undo points
local function no_undo()
    reaper.defer(function() end)
end

-- Define a table of command IDs for closing toolbars
local Toolbar_T = {
    [0] = 41651,
    41679,
    41680,
    41681,
    41682,
    41683,
    41684,
    41685,
    41686,
    41936,
    41937,
    41938,
    41939,
    41940,
    41941,
    41942,
    41943
}

-- Prevent UI refresh to avoid flickering while closing the toolbar
reaper.PreventUIRefresh(1)

-- Check the state of the top dock and close it if it is open
local stateTopDock = (reaper.GetToggleCommandState(41297) == 1)
if stateTopDock then
    reaper.Main_OnCommand(41297, 0)
end

-- Close toolbar number 15 using the command ID from the Toolbar_T table
local state = reaper.GetToggleCommandState(Toolbar_T[15])
if state == 1 then
    reaper.Main_OnCommand(Toolbar_T[15], 0)
end

-- Check the state of the top dock again and restore it to its original state if it has changed
local stateTopDock_End = (reaper.GetToggleCommandState(41297) == 1)
if stateTopDock_End ~= stateTopDock then
    reaper.Main_OnCommand(41297, 0)
end

-- Restore UI refresh
reaper.PreventUIRefresh(-1)

-- Create an undo point with a description that includes the toolbar number
reaper.Undo_BeginBlock()
reaper.Undo_EndBlock("Close toolbar" .. "15", 0)
