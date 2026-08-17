--[[
Name: Swap VU with PEAK
Date: 01 Jun 2023
Author: Bing Chat
Prompt: Edu Serra www.amaudio.co
]]
-- This script removes all FX with a specified name from selected tracks and then adds a VU meter FX to the first FX slot of each selected track.

function main()
  -- Set the name of the FX to search for and remove
  local fxname = "VU"
  
  -- Check if fxname is an empty string and if so, end the script early
  if fxname == '' then return end
  
  -- Begin an undo block to allow undoing the changes made by this script
  reaper.Undo_BeginBlock()
  
  -- Iterate over each selected track
  for i =1, reaper.CountSelectedTracks(0) do 
      -- Get a reference to the current selected track
      local track = reaper.GetSelectedTrack(0,i-1)
      
      -- Iterate over each FX on the current track in reverse order
      for fx = reaper.TrackFX_GetCount( track ), 1, -1 do
        -- Get the name of the current FX
        local retval, buf = reaper.TrackFX_GetFXName( track, fx-1 )
        
        -- Check if the FX name matches the specified fxname (ignoring case)
        match  = buf:lower():match(fxname:lower())
        
        -- If there is a match, remove the FX from the track
        if match then reaper.TrackFX_Delete(track, fx-1) end
      end
      
      -- Add a PEAK meter FX to the first FX slot of the current track
      local fxIndex = reaper.TrackFX_AddByName(track, "PEAK", false, 1)
      
      -- Copy the PEAK meter FX to the first FX slot of the current track
      reaper.TrackFX_CopyToTrack(track, fxIndex, track, 0, true)
      
      -- Show the PEAK meter FX UI
      reaper.TrackFX_Show(track, 0, 2)
    end
    
    -- End the undo block and add it to Reaper's undo history with a description
    reaper.Undo_EndBlock("Replace VU FX with PEAK", -1)
end    

-- Run the main function to execute the script
main()

