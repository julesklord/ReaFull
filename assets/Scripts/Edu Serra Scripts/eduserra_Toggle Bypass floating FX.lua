-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

local track_n = reaper.CountTracks( 0 )

for i = 0, track_n-1 do
  local mediatrack = reaper.GetTrack(0, i)
  local fx_count =reaper.TrackFX_GetCount( mediatrack )
    for c = 0, fx_count-1 do
      local window = reaper.TrackFX_GetFloatingWindow( mediatrack, c )
      if window ~= nil then 
        local FXstate = reaper.TrackFX_GetEnabled( mediatrack, c )
        if FXstate then
          reaper.TrackFX_SetEnabled( mediatrack, c, false )
        else 
          reaper.TrackFX_SetEnabled( mediatrack, c, true )
        end
      end
    end
  
end
