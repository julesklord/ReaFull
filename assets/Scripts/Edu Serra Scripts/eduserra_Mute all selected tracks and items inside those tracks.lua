--[[
Script Name: Mute Selected Tracks and Items
Description: This script mutes all selected tracks and all items in selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

reaper.Undo_BeginBlock()

--Mute all selected tracks
for i = 0, reaper.CountSelectedTracks(0)-1 do
  local track = reaper.GetSelectedTrack(0,i)
  reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 1)
end

--Mute all items in selected tracks
for i = 0, reaper.CountSelectedTracks(0)-1 do
  local track = reaper.GetSelectedTrack(0,i)
  local numItems = reaper.CountTrackMediaItems(track)
  for j = 0, numItems-1 do
    local item = reaper.GetTrackMediaItem(track, j)
    reaper.SetMediaItemInfo_Value(item, "B_MUTE", 1)
  end
end

reaper.Undo_EndBlock("Mute Selected Tracks and Items", -1)

