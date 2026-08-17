--[[
Script Name: Insert ReaEQ as first FX in chain in all selected tracks
Date: 2023-05-17
Author: Bing
Prompt: Edu Serra www.amaudio.co
]]

-- Get the current project
local project = reaper.EnumProjects(-1)

-- Define the name of the FX you want to insert
local fxName = "ReaEQ"

-- Check if any tracks are selected
if reaper.CountSelectedTracks(project) == 0 then
  reaper.ShowMessageBox("No tracks selected. Please select at least one track and try again.", "Error", 0)
  return
end

-- Iterate through all selected tracks in the project
for i = 0, reaper.CountSelectedTracks(project) - 1 do
  local track = reaper.GetSelectedTrack(project, i)

  -- Insert the FX as the last FX in the chain
  local result = reaper.TrackFX_AddByName(track, fxName, false, -1)

  -- Check if the FX was inserted successfully
  if result == -1 then
    reaper.ShowMessageBox("Failed to insert FX. Please make sure that the ReaEQ effect is installed and available in your Reaper installation.", "Error", 0)
    return
  end

  -- Move the FX to the first position in the chain
  reaper.TrackFX_CopyToTrack(track, result, track, 0, true)
end

-- Update the UI to reflect the changes
reaper.UpdateArrange()
reaper.UpdateTimeline()

