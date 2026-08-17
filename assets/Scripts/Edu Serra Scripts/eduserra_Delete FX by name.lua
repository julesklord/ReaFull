-- @author MPL
-- Mod by Edu Serra

function main()
fxname='PEAK'

  for i =1, reaper.CountSelectedTracks(0) do 
      local track = reaper.GetSelectedTrack(0,i-1)
      for fx = reaper.TrackFX_GetCount( track ), 1, -1 do
        local retval, buf = reaper.TrackFX_GetFXName( track, fx )
        match  = buf:lower():match(fxname:lower())
        if match then reaper.TrackFX_Delete(track, fx-1) end
      end
    end
end    

main()
