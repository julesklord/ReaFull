--[[
Script Name: Remove FX from Selected Tracks
Description: This script removes all FX from all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

reaper.Undo_BeginBlock()

-- Get the number of selected tracks
num_selected_tracks = reaper.CountSelectedTracks(0)

-- Loop through all of the selected tracks
for i = 0, num_selected_tracks - 1 do
  -- Get the selected track
  selected_track = reaper.GetSelectedTrack(0, i)

  -- Get the number of FX in the selected track
  num_fx = reaper.TrackFX_GetCount(selected_track)

  -- Loop through all of the FX in the selected track
  for j = num_fx - 1, 0, -1 do
    -- Remove the FX
    reaper.TrackFX_Delete(selected_track, j)
  end
end

reaper.Undo_EndBlock("Remove FX from Selected Tracks", -1)


