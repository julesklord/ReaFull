-- Insert suffix "FX" in the label of selected tracks
local reaper = reaper

-- Get selected tracks
selected_tracks = reaper.CountSelectedTracks(0)

if selected_tracks ~= nil then
  for i = 0, selected_tracks-1 do
    -- Get track
    track = reaper.GetSelectedTrack(0, i)
    
    -- Get track name
    retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    
    -- Append suffix
    track_name = track_name .. " FX"
    
    -- Set new track name
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name, true)
  end
end
