--[[
Script Name: Append "OFF" Suffix to Selected Track Names
Description: This script appends the "OFF" suffix to the names of all selected tracks in the project.
Author: Edu Serra
Version: ReArtist 1.2
]]

-- Insert suffix "OFF" in the label of selected tracks
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
    
    -- Append suffix
    track_name = track_name .. " OFF"
    
    -- Set new track name
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name, true)
  end
  reaper.Undo_EndBlock("Append OFF Suffix to Selected Track Names", -1)
end

