-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Script: Close Mixer, FX Browser, Media Explorer, and Track Manager Windows, Show Grid Lines and Show Master Tempo Envelope

-- Check if the Mixer Window is open
isMixerOpen = reaper.GetToggleCommandState(40078)

-- If the Mixer Window is open, close it
if isMixerOpen == 1 then
    reaper.Main_OnCommand(40078, 0)
end

-- Check if the FX Browser Window is open
isFXBrowserOpen = reaper.GetToggleCommandState(40271)

-- If the FX Browser Window is open, close it
if isFXBrowserOpen == 1 then
    reaper.Main_OnCommand(40271, 0)
end

-- Check if the Media Explorer Window is open
isMediaExplorerOpen = reaper.GetToggleCommandState(50124)

-- If the Media Explorer Window is open, close it
if isMediaExplorerOpen == 1 then
    reaper.Main_OnCommand(50124, 0)
end

-- Check if the Track Manager Window is open
isTrackManagerOpen = reaper.GetToggleCommandState(40906)

-- If the Track Manager Window is open, close it
if isTrackManagerOpen == 1 then
    reaper.Main_OnCommand(40906, 0)
end

-- Check if grid lines are shown
areGridLinesShown = reaper.GetToggleCommandState(40145)

-- If grid lines are not shown, show them
if areGridLinesShown == 0 then
    reaper.Main_OnCommand(40145, 0)
end

-- Check if Master Tempo Envelope is shown
isMasterTempoEnvelopeShown = reaper.GetToggleCommandState(41046)

-- If Master Tempo Envelope is not shown, show it
if isMasterTempoEnvelopeShown == 0 then
    reaper.Main_OnCommand(41046, 0)
end
-- Define a no_undo function to prevent the script from being undone
local function no_undo()reaper.defer(function()end)end;

-- Define a table that maps toolbar numbers to their corresponding command IDs
local Toolbar_T = {[0]=41651, [1]=41679, [2]=41680, [3]=41681, [4]=41682, [5]=41683, [6]=41684, [7]=41685,
                   [8]=41686, [9]=41936, [15]=41942, [16]=41943, [17]=42713, [20]=42716, [21]=42717} -- Corrected the index for toolbar 20


-- Check if the top docker is visible and hide it if it is
local stateTopDock = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;


-- Check if the top docker's visibility has changed and restore it to its original state if it has
local stateTopDock_End = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock_End ~= stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;

-- Iterate over the specified toolbar numbers and close each toolbar if it is visible
for _, numbToolbar in ipairs({1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 17, 20, 21}) do
    local state = reaper.GetToggleCommandState(Toolbar_T[numbToolbar]);
    if state == 1 then;
        reaper.Main_OnCommand(Toolbar_T[numbToolbar],0);
        reaper.defer(function() end) -- Add a short delay
    end;
end


-- Disable UI refresh prevention
reaper.PreventUIRefresh(-1);

-- Call the no_undo function to prevent the action from being undone
no_undo();
