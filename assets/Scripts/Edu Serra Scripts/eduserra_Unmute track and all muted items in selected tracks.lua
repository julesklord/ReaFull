-- Author: Bing Chat
-- Prompt: Edu Serra www.eduserra.net

-- Unmute all muted items in selected tracks
local trackCount = reaper.CountSelectedTracks(0)
for i = 0, trackCount - 1 do
  local track = reaper.GetSelectedTrack(0, i)
  local itemCount = reaper.CountTrackMediaItems(track)
  for j = 0, itemCount - 1 do
    local item = reaper.GetTrackMediaItem(track, j)
    if reaper.GetMediaItemInfo_Value(item, "B_MUTE") == 1 then
      reaper.SetMediaItemInfo_Value(item, "B_MUTE", 0)
    end
  end
end
reaper.UpdateArrange()

-- Unmute all selected tracks
selected_tracks = reaper.CountSelectedTracks(0)
for i = 0, selected_tracks - 1 do
  track = reaper.GetSelectedTrack(0, i)
  reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
end

