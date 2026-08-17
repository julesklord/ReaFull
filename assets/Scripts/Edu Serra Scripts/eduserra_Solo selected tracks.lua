-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

--Solo selected tracks
local numTracks = reaper.CountSelectedTracks(0)

for i = 0, numTracks - 1 do
   local track = reaper.GetSelectedTrack(0, i)
   reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 2) 
end
