-- [ [ 
-- * ReaScript Name: Insert selected FX on new tracks
-- * About: This script inserts each selected FX from the FX Browser on a new track.
-- * Instructions: Select FX in the FX Browser. Execute the script.
-- * Author: Bing
-- * Version: 1.0
-- ]]

function main()
  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

  -- Get the number of selected FX in the FX Browser
  local num_fx = reaper.CountSelectedMediaItems(0)

  -- Create new tracks and insert one FX on each track
  for i = 1, num_fx do
    local fx = reaper.GetSelectedMediaItem(0, i-1)
    local fx_name = reaper.GetTakeName(fx)
    reaper.InsertTrackAtIndex(i-1, true)
    local track = reaper.GetTrack(0, i-1)
    reaper.TrackFX_AddByName(track, fx_name, false, -1)
  end

  reaper.Undo_EndBlock("Insert selected FX on new tracks", -1) -- End of the undo block. Leave it at the bottom of your main function.
end

main() -- Execute your main function

