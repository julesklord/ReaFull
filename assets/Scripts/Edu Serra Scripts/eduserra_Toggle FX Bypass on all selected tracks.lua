-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Toggle FX Bypass for all selected tracks

function main()
  for i = 0, reaper.CountSelectedTracks(0) - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local fx_bypass = reaper.GetMediaTrackInfo_Value(track, "I_FXEN")
    if fx_bypass == 1 then
      reaper.SetMediaTrackInfo_Value(track, "I_FXEN", 0)
    else
      reaper.SetMediaTrackInfo_Value(track, "I_FXEN", 1)
    end
  end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Toggle FX Bypass for all selected tracks", -1)
