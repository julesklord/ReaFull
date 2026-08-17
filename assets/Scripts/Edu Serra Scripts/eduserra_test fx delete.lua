function main()
  local fxname = "PEAK"
  if fxname == '' then return end
  reaper.Undo_BeginBlock()
  for i =1, reaper.CountSelectedTracks(0) do 
      local track = reaper.GetSelectedTrack(0,i-1)
      for fx = reaper.TrackFX_GetCount( track ), 1, -1 do
        local retval, buf = reaper.TrackFX_GetFXName( track, fx-1 )
        match  = buf:lower():match(fxname:lower())
        if match then reaper.TrackFX_Delete(track, fx-1) end
      end
      local fxIndex = reaper.TrackFX_AddByName(track, "VU", false, 1)
      reaper.TrackFX_CopyToTrack(track, fxIndex, track, 0, true)
      reaper.TrackFX_Show(track, 0, 2)
    end
  reaper.Undo_EndBlock("Remove FX by Name from Selected Tracks", -1)
end    

main()

