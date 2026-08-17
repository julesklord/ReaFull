-- Get the number of selected tracks
num_selected_tracks = reaper.CountSelectedTracks(0)

-- Loop through all of the selected tracks
for i = 0, num_selected_tracks - 1 do
  -- Get the selected track
  selected_track = reaper.GetSelectedTrack(0, i)

  -- Insert the ReaEQ FX in the selected track
  reaper.TrackFX_AddByName(selected_track, "-", false, -1)
end

