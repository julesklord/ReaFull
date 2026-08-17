--[[
Script Name: Prepend "STEM" Prefix to Selected Track Names
Description: This script prepends the "STEM" prefix to the names of all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

local reaper = reaper

-- Get selected tracks
selected_tracks = reaper.CountSelectedTracks(0)

if selected_tracks ~= nil then
  reaper.Undo_BeginBlock()
  for i = 0, selected_tracks-1 do
    -- Get track
    track = reaper.GetSelectedTrack(0, i)
    
    -- Get track name
    retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    
    -- Prepend prefix
    track_name = "STEM " .. track_name
    
    -- Set new track name
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name, true)
  end
  reaper.Undo_EndBlock("Prepend STEM Prefix to Selected Track Names", -1)
end


