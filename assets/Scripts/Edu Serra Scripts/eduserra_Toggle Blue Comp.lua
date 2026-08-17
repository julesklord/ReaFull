-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Count the number of selected tracks
local sel_track_count = reaper.CountSelectedTracks(0)

-- Iterate over each selected track
for i = 0, sel_track_count-1 do
  -- Get the current selected track
  local track = reaper.GetSelectedTrack(0, i)
  
  -- Count the number of FX on the current track
  local fx_count = reaper.TrackFX_GetCount(track)
  
  -- Iterate over each FX on the current track
  for fx = 0, fx_count-1 do
    -- Get the name of the current FX
    local retval, fxname = reaper.TrackFX_GetFXName(track, fx, "")
    
    -- Check if the current FX is Re-EQ
    if fxname:find("D-Comp") then
      -- Get the bypass state of the current FX
      local bypass = reaper.TrackFX_GetEnabled(track, fx)
      
      -- Toggle the bypass state of the current FX
      reaper.TrackFX_SetEnabled(track, fx, not bypass)
      
      -- Update the track list window
      reaper.TrackList_AdjustWindows(false)
    end
  end
end

