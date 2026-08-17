-- ReaScript Name: Remove Missing FX from Project
-- Author: ChatGPT
-- Version: 1.0
-- Description: Removes all missing FX from the project

function remove_missing_fx()
  -- Get the number of tracks in the project
  local track_count = reaper.CountTracks(0)

  -- Loop through all tracks
  for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local fx_count = reaper.TrackFX_GetCount(track)
    local fx_index = 0

    -- Loop through all FX on the track
    while fx_index < fx_count do
      local retval, fx_name = reaper.TrackFX_GetFXName(track, fx_index, "")

      -- Check if the FX name contains the string indicating it's missing
      if string.find(fx_name, "FX: (Unavailable") then
        -- Remove the missing FX
        reaper.TrackFX_Delete(track, fx_index)
        -- Decrement the FX count because we just removed one
        fx_count = fx_count - 1
      else
        -- Only increment the index if we didn't remove an FX,
        -- because removing shifts all later FX one slot up
        fx_index = fx_index + 1
      end
    end
  end
end

-- Start undo block
reaper.Undo_BeginBlock()

-- Call the function to remove missing FX
remove_missing_fx()

-- End undo block
reaper.Undo_EndBlock("Remove Missing FX from Project", -1)

-- Update the arrange view to reflect changes
reaper.UpdateArrange()

