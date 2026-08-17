--[[
Script Name: Remove "OFF" Suffix from Selected Track Names
Description: This script removes the "OFF" suffix from the names of all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

-- Get the number of selected tracks
num_sel_tracks = reaper.CountSelectedTracks(0)
 
-- Iterate through the selected tracks
for i=1, num_sel_tracks do
 
  -- Get the track
  track = reaper.GetSelectedTrack(0, i-1)
 
  -- Get the track name
  retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
 
  -- Delete the suffix "OFF"
  track_name = string.gsub(track_name, "OFF", "")
 
  -- Set the new track name
  reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name, true)
  
end

-- Add an undo point
reaper.Undo_OnStateChange("Remove OFF Suffix from Selected Track Names")

