-- Start script: Lil Chordbox
local chord_box_cmd_name = '_RSff0957acd908ac1a809c8b9aa70a0aa73d2ce162'
reaper.Main_OnCommand(reaper.NamedCommandLookup(chord_box_cmd_name), 0)

-- Start script: Adaptive grid (background process)
local adaptive_grid_cmd = '_RS6a4ecd962e6101f6f55408dd535c25addd8de2e0'
reaper.Main_OnCommand(reaper.NamedCommandLookup(adaptive_grid_cmd), 0)

-- Start script: Gridbox
local grid_box_cmd_name = '_RS02de4a63cf12c72510b6da7254c3f3df05dba45c'
reaper.Main_OnCommand(reaper.NamedCommandLookup(grid_box_cmd_name), 0)

