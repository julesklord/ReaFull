--[[
Script Name: Toggle Bypass for ReaEQ FX
Date: 2023-05-17
Author: Bing
Prompt: Edu Serra www.amaudio.co
]]

-- Get the current project
local project = reaper.EnumProjects(-1)

-- Define the name of the FX you want to toggle
local fxName = "ReaEQ"

-- Iterate through all tracks in the project
for i = 0, reaper.CountTracks(project) - 1 do
  local track = reaper.GetTrack(project, i)

  -- Iterate through all FX on the track
  for j = 0, reaper.TrackFX_GetCount(track) - 1 do
    -- Get the FX name
    local _, fxNameFromAPI = reaper.TrackFX_GetFXName(track, j, "")

    -- Check if the FX name matches the desired name
    if fxNameFromAPI:find(fxName) then
      -- Toggle the bypass state
      local bypassState = reaper.TrackFX_GetEnabled(track, j)
      reaper.TrackFX_SetEnabled(track, j, not bypassState)
    end
  end
end

-- Update the UI to reflect the changes
reaper.UpdateArrange()
reaper.UpdateTimeline()

