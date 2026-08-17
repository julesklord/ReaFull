--[[
  Script: Duplicar tracks seleccionados con contenido y mutear duplicados
  Descripción: 
    - Solicita al usuario el número de duplicaciones.
    - Por cada track seleccionado se duplica (con items, FX, etc.) ese track
      la cantidad de veces indicada.
    - Cada track duplicado se pone en MUTE.
--]]

-- Solicitar al usuario el número de duplicaciones
local ret, user_input = reaper.GetUserInputs("Duplicar Tracks", 1, "Número de duplicaciones:", "1")
if not ret then return end  -- Si se cancela el prompt, salir

local num_dup = tonumber(user_input)
if not num_dup or num_dup < 1 then
  reaper.ShowMessageBox("El número de duplicaciones debe ser un entero mayor o igual a 1.", "Error", 0)
  return
end

-- Iniciar el bloque de Undo
reaper.Undo_BeginBlock()

-- Guardar en una tabla todos los tracks originalmente seleccionados
local original_tracks = {}
local num_sel_tracks = reaper.CountSelectedTracks(0)
if num_sel_tracks == 0 then
  reaper.ShowMessageBox("No hay tracks seleccionados.", "Error", 0)
  return
end

for i = 0, num_sel_tracks - 1 do
  local track = reaper.GetSelectedTrack(0, i)
  table.insert(original_tracks, track)
end

-- Función para deseleccionar todos los tracks
local function DeselectAllTracks()
  local count_tracks = reaper.CountTracks(0)
  for j = 0, count_tracks - 1 do
    local t = reaper.GetTrack(0, j)
    reaper.SetTrackSelected(t, false)
  end
end

-- Para cada track original, hacer las duplicaciones solicitadas
for _, track in ipairs(original_tracks) do
  for i = 1, num_dup do
    -- Deseleccionar todos los tracks y seleccionar solo el track original
    DeselectAllTracks()
    reaper.SetTrackSelected(track, true)
    
    -- Obtener el índice del track original (0-based)
    local track_index = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1

    -- Ejecutar el comando de duplicar track (ID 40062: "Track: Duplicate tracks")
    reaper.Main_OnCommand(40062, 0)

    -- El track duplicado se inserta inmediatamente después del original,
    -- por lo que lo obtenemos con index = track_index + 1
    local dup_track = reaper.GetTrack(0, track_index + 1)
    if dup_track then
      -- Poner en MUTE el track duplicado
      reaper.SetMediaTrackInfo_Value(dup_track, "B_MUTE", 1)
    end

    -- Reseleccionar el track original para poder duplicarlo nuevamente
    reaper.SetTrackSelected(track, true)
  end
end

-- Finalizar el bloque de Undo y actualizar la vista
reaper.Undo_EndBlock("Duplicar tracks seleccionados y mutear duplicados", -1)
reaper.UpdateArrange()

