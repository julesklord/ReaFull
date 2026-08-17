-- @noindex
reaper.SNM_SetDoubleConfigVar("defsendvol", 0.0)
package.path = debug.getinfo(1,"S").source:match[[^@?(.*[\/])[^\/]-$]] .."?.lua;".. package.path
require 'sr_Send selected track(s) to FX track function'

local send_fx_prefix = "Room FX" -- send FX2

SendTrackToFX(send_fx_prefix) -- call function

local send_fx_prefix = "Plate FX" -- send FX2

SendTrackToFX(send_fx_prefix) -- call function
