--[[
Script Name: Hide MCP Sends Area of Selected Tracks
Description: This script hides the MCP sends area of all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

local sel_track_count = reaper.CountSelectedTracks()
if sel_track_count > 0 then
  reaper.Undo_BeginBlock()
  for i=0, sel_track_count-1 do
    local sel_tr = reaper.GetSelectedTrack(0,i)
    reaper.SetMediaTrackInfo_Value(sel_tr, 'F_MCP_SENDRGN_SCALE', 0)
  end
  reaper.Undo_EndBlock('Hide MCP Sends Area of Selected Tracks', -1)
else
  reaper.defer(function () end)
end

