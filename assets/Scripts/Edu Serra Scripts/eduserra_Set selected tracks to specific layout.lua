-- ReaScript Name: Apply 'A Meter Bridge' Layout to BUS Tracks
-- Author: ChatGPT
-- Version: 1.0
-- Description: Applies the 'A Meter Bridge' layout to tracks containing 'BUS' in their names

function apply_layout_to_bus_tracks()
  -- Define the custom layout name
  local custom_layout = "A Meter Bridge"

  -- Get the number of tracks in the project
  local track_count = reaper.CountTracks(0)

  -- Loop through all tracks
  for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

    -- Check if the track name contains the word "BUS"
    if retval and track_name:find("BUS") then
      -- Get the state chunk of the track
      local retval, track_chunk = reaper.GetTrackStateChunk(track, "", false)

      if not retval then
        reaper.ShowMessageBox("Failed to get track state chunk for track: " .. track_name, "Error", 0)
        return
      end

      -- Find or add the layout line in the chunk
      local layout_line_pattern = "\nLAYOUT MAINSIZE .-\n"
      local new_layout_line = "\nLAYOUT MAINSIZE " .. custom_layout .. "\n"
      local modified_chunk = track_chunk:gsub(layout_line_pattern, new_layout_line)

      -- If no layout line was found, add the custom layout to the chunk
      if track_chunk == modified_chunk then
        modified_chunk = track_chunk .. new_layout_line
      end

      -- Set the modified chunk back to the track
      retval = reaper.SetTrackStateChunk(track, modified_chunk, false)

      if not retval then
        reaper.ShowMessageBox("Failed to set track state chunk for track: " .. track_name, "Error", 0)
        return
      end
    end
  end

  -- Update the arrange view to reflect changes
  reaper.UpdateArrange()
end

-- Start undo block
reaper.Undo_BeginBlock()

-- Call the function to apply custom layout to BUS tracks
apply_layout_to_bus_tracks()

-- End undo block
reaper.Undo_EndBlock("Apply 'A Meter Bridge' Layout to BUS Tracks", -1)

