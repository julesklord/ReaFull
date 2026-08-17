-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

--Description: Set Pan Value of Selected Tracks

pan = 30
num_selected_tracks  = reaper.CountSelectedTracks(0)
for i = 1,num_selected_tracks,1 do
  track = reaper.GetSelectedTrack(0, i-1)
  reaper.SetMediaTrackInfo_Value(track, "D_PAN", 0.01*pan)
end
