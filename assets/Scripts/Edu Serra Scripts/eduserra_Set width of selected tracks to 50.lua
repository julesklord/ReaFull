-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

--Description: Set Stereo Width Value of Selected Tracks

width = 50
num_selected_tracks  = reaper.CountSelectedTracks(0)
for i = 1,num_selected_tracks,1 do
  track = reaper.GetSelectedTrack(0, i-1)
  reaper.SetMediaTrackInfo_Value(track, "D_WIDTH", 0.01*width)
end
