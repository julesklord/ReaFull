-- Remove ReaEQ and insert ReaComp in selected tracks

function main()
  local fxname = "ReaEQ"
  local newFxName = "ReaComp"

  for i = 1, reaper.CountSelectedTracks(0) do
    local track = reaper.GetSelectedTrack(0, i - 1)
    for fx = reaper.TrackFX_GetCount(track), 1, -1 do
      local retval, fxName = reaper.TrackFX_GetFXName(track, fx - 1, "")
      local match = string.lower(fxName):match(string.lower(fxname)) ~= nil
      if match then
        reaper.TrackFX_Delete(track, fx - 1)
      end
    end
    
    -- insert ReaComp after deleting ReaEQ
    local fxIndex = reaper.TrackFX_AddByName(track, newFxName, false, -1)
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Remove ReaEQ and insert ReaComp in selected tracks", 2)

