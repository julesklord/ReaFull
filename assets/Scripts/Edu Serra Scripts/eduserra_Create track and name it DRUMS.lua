--[[
Script Name: Create Track and Add ReaEQ
Description: This script creates a new track with a specified name and inserts the ReaEQ FX in the first FX slot.
Author: Edu Serra
]]

local track_name = "DRUMS"

-- Create the track
reaper.Main_OnCommand(40001, 0) -- Track: Add new track

-- Get the track that was just created
local track = reaper.GetSelectedTrack(0, 0)

-- Set the track name
reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name, true)

-- Insert the ReaEQ FX in the first FX slot
reaper.TrackFX_AddByName(track, "ReaEQ", 0, 1)

-- Add an undo point
reaper.Undo_OnStateChange("Create Track and Add ReaEQ")

