-- Name: Sort tracks by color
-- Date: 20 Jun 2023
-- Author: Bing Chat
-- Prompt: Edu Serra www.amaudio.co

-- This script sorts tracks in the Reaper DAW by their color.

-- Begin undo block
reaper.Undo_BeginBlock()

-- Prevent UI refresh
reaper.PreventUIRefresh(1)

-- Get the number of tracks
local num_tracks = reaper.CountTracks(0)

-- Create a table to store track and color information
local tracks = {}

-- Iterate over all tracks
for i = 0, num_tracks - 1 do
  -- Get the track
  local track = reaper.GetTrack(0, i)
  
  -- Get the track color
  local color = reaper.GetMediaTrackInfo_Value(track, "I_CUSTOMCOLOR")
  
  -- Store the track and color information in the table
  table.insert(tracks, {track = track, color = color})
end

-- Sort the table by color
table.sort(tracks, function(a, b) return a.color < b.color end)

-- Reorder the tracks based on their sorted colors
for i, track_info in ipairs(tracks) do
  reaper.SetTrackSelected(track_info.track, true)
  reaper.ReorderSelectedTracks(num_tracks - i + 1, 2)
  reaper.SetTrackSelected(track_info.track, false)
end

-- Allow UI refresh
reaper.PreventUIRefresh(-1)

-- End undo block
reaper.Undo_EndBlock("Sort tracks by color", -1)

