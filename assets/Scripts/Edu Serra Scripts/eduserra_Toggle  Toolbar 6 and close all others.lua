--[[
-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net
--]]

-- Define a no_undo function to prevent the script from being undone
local function no_undo()reaper.defer(function()end)end;

-- Define a table that maps toolbar numbers to their corresponding command IDs
local Toolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685,
                  41686,41936,41937,41938,41939,41940,41941,41942,41943};

-- Enable UI refresh prevention to prevent the screen from flickering while the script is running
reaper.PreventUIRefresh(1);

-- Check if the top docker is visible and hide it if it is
local stateTopDock = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;

-- Iterate over the specified toolbar numbers and close each toolbar if it is visible
for _, numbToolbar in ipairs({8, 16}) do
    local state = reaper.GetToggleCommandState(Toolbar_T[numbToolbar]);
    if state == 1 then;
        reaper.Main_OnCommand(Toolbar_T[numbToolbar],0);
    end;
end

-- Toggle the visibility of toolbar 6
reaper.Main_OnCommand(Toolbar_T[6],0);

-- Check if the top docker's visibility has changed and restore it to its original state if it has
local stateTopDock_End = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock_End ~= stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;

-- Disable UI refresh prevention
reaper.PreventUIRefresh(-1);

-- Call the no_undo function to prevent the action from being undone
no_undo();
