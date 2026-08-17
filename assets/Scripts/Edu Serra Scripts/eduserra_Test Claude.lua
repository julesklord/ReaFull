-- Name: Toggle ReaEQ FX Bypass 
-- Date: May 30, 2021
-- Author: Claude
-- Prompt: Edu Serra www.amaudio.co
-- Description: This script will toggle the bypass state of all ReaEQ effects in the project.
-- Get all tracks in the project
tracks = reaper.CountTracks(0)
tracks = reaper.GetTrack(0,tracks-1)  
-- Function to toggle FX bypass on a single track
function ToggleFXBypass(track)
  -- Get all FX on the track
  fx = reaper.TrackFX_GetCount(track)
  for i=0,fx-1 do
    -- Get handle to each FX
    h, , = reaper.TrackFX_GetFX(track, i)    
    -- Check if FX name contains "ReaEQ"
    name = reaper.TrackFX_GetName(h)
    if string.match(name, "ReaEQ") then   
      -- Toggle bypass state
      bypass_state = reaper.TrackFX_GetBypass(h)  
      reaper.TrackFX_SetBypass(h, not bypass_state)
    end
  end 
end
-- Loop through each track and toggle ReaEQ FX bypass  
for i=0,tracks-1 do  
  ToggleFXBypass(tracks[i])
end 
-- Display message to user
reaper.MB("Bypass state of all ReaEQ effects has been toggled!", "Toggle ReaEQ FX Bypass", 0)
