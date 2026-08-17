-- Converted from a custom action "Custom: AM Insert PEAK Meter in FX 1 Stem Tracks"
-- Import into the Main / Main (alt recording) section of the Action list and run from Arrange.


local r = reaper

r.PreventUIRefresh(1)
r.Undo_BeginBlock();

r.Main_OnCommand(40769,0) -- Unselect (clear selection of) all tracks/items/envelope points
r.Main_OnCommand(r.NamedCommandLookup("_RSa3ad5fb3424ff56d876c4fb64ff5a3b934e71388"),0) -- Script: Lokasenna_Select tracks by name - Select STEMS.lua
r.Main_OnCommand(r.NamedCommandLookup("_RS4b8c069b8832f7c134540e87875da1947b1ea9b9"),0) -- Script: mpl_Remove vu from selected tracks.lua
r.Main_OnCommand(r.NamedCommandLookup("_FXfa15b02dd95c8817caa22f1ef2e813f6466a3d45"),0) -- Insert FX: PEAK (AM AUDIO)
r.Main_OnCommand(r.NamedCommandLookup("_S&M_WNCLS5"),0) -- SWS/S&M: Close all floating FX windows for selected tracks
r.Main_OnCommand(r.NamedCommandLookup("_S&M_SEL_LAST_FX"),0) -- SWS/S&M: Select last FX for selected tracks
r.Main_OnCommand(r.NamedCommandLookup("_RS49da091c010688ad631a2c2d41d280327e312eb3"),0) -- Script: Archie_FX; Move last FX in selected tracks to first position(`).lua
r.Main_OnCommand(r.NamedCommandLookup("_RSd2b463a6e6ecfac83a89bc2e20de02e5efbc4c0e"),0) -- Script: mpl_Show selected tracks first FX embedded UI in MCP.lua
r.Main_OnCommand(40769,0) -- Unselect (clear selection of) all tracks/items/envelope points

r.Undo_EndBlock("AM Insert PEAK Meter in FX 1 Stem Tracks",-1)
r.PreventUIRefresh(-1)


