--[[
Script Name: Replace FX in Selected Tracks
Description: This script replaces all instances of a specified FX with a new FX in all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

function main()
  local fxname = "PEAK"
  local newFxName = "VU"

  for i = 1, reaper.CountSelectedTracks(0) do
    local track = reaper.GetSelectedTrack(0, i - 1)
    for fx = reaper.TrackFX_GetCount(track), 1, -1 do
      local retval, fxName = reaper.TrackFX_GetFXName(track, fx - 1, "")
      local match = string.lower(fxName):match(string.lower(fxname)) ~= nil
      if match then
        reaper.TrackFX_Delete(track, fx - 1)
      end
    end
    
    -- Add the new FX without floating it
    local fxIndex = reaper.TrackFX_AddByName(track, newFxName, false, -1)
    reaper.TrackFX_Show(track, fxIndex, 2)
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Replace FX in Selected Tracks", -1)



