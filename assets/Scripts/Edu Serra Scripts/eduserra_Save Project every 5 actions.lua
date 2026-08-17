--[[
Name: Save project every 5 actions executed
Date: 08 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]

-- Set the number of actions to execute before saving the project
local actionsBeforeSave = 5

-- Initialize the undo counter
local undoCounter = reaper.GetProjectStateChangeCount(0)

-- Function to check the undo counter and save the project if necessary
function saveProject()
    -- Get the current undo counter
    local currentUndoCounter = reaper.GetProjectStateChangeCount(0)

    -- Check if the undo counter has increased by the specified number of actions
    if currentUndoCounter - undoCounter >= actionsBeforeSave then
        -- Save the project
        reaper.Main_SaveProject(0, false)

        -- Update the undo counter
        undoCounter = currentUndoCounter

        -- Show a message box with an OK button
        reaper.ShowMessageBox("Current project was saved", "Project Saved", 0)
    end

    -- Call this function again after a short delay
    reaper.defer(saveProject)
end

-- Call the function for the first time
saveProject()

