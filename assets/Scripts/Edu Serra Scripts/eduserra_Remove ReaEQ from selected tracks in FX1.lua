-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Get the current project
local project = reaper.EnumProjects(-1)

-- Define the name of the FX you want to remove
local fxName = "ReaEQ"

-- Check if any tracks are selected
if reaper.CountSelectedTracks(project) == 0 then
    reaper.ShowMessageBox("No tracks selected. Please select at least one track and try again.", "Error", 0)
    return
end

-- Iterate through all selected tracks in the project
for i = 0, reaper.CountSelectedTracks(project) - 1 do
    local track = reaper.GetSelectedTrack(project, i)

    -- Get the name of the first FX in the FX chain
    local retval, firstFxName = reaper.TrackFX_GetFXName(track, 0, "")

    -- Check if the first FX is named "ReaEQ"
    if firstFxName == fxName then
        -- If it is, remove it
        reaper.TrackFX_Delete(track, 0)
    end
end

-- Update the UI to reflect the changes
reaper.UpdateArrange()
reaper.UpdateTimeline()
