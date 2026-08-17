--[[
  ReaFull: Global Startup Script for Cockos REAPER
  Author: Jules Martins / ReaFull Team
  Description: Configurable startup actions and background workflow helpers.
]]

-- Configuration: Set to true/false to enable or disable specific startup tools
local ENABLE_ADAPTIVE_GRID = true  -- Automatically adjust grid density based on zoom
local ENABLE_LIL_CHORDBOX   = false -- MIDI Chord display overlay
local ENABLE_GRIDBOX       = false -- Floating Grid selection box

local function run_action(cmd_name)
    local cmd_id = reaper.NamedCommandLookup(cmd_name)
    if cmd_id and cmd_id ~= 0 then
        reaper.Main_OnCommand(cmd_id, 0)
    end
end

-- 1. Adaptive Grid (Background helper)
if ENABLE_ADAPTIVE_GRID then
    run_action('_RS6a4ecd962e6101f6f55408dd535c25addd8de2e0')
end

-- 2. Lil Chordbox
if ENABLE_LIL_CHORDBOX then
    run_action('_RSff0957acd908ac1a809c8b9aa70a0aa73d2ce162')
end

-- 3. Gridbox
if ENABLE_GRIDBOX then
    run_action('_RS02de4a63cf12c72510b6da7254c3f3df05dba45c')
end