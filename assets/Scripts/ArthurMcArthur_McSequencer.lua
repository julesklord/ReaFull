-- @description McSequencer
-- @author Arthur McArthur
-- @license GPL v3
-- @version 1.0

local reaper = reaper

local function checkDependencies()
    local missingDeps = {}

    -- Check for ReaImGui
    if not reaper.ImGui_GetVersion or reaper.ImGui_GetVersion() < "0.8.7.5" then
        missingDeps[#missingDeps + 1] = '"Dear ImGui"'
    end

    -- Check for SWS extension
    if not reaper.CF_GetSWSVersion or reaper.CF_GetSWSVersion() < "2.12.1" then
        missingDeps[#missingDeps + 1] = '"SWS extension"'
    end

    if #missingDeps > 0 then
        local missingDepsStr = table.concat(missingDeps, " and ")
        reaper.ShowMessageBox(
        "This script requires " .. missingDepsStr .. ".\nPlease install them using ReaPack or visit the REAPER website.",
            "Missing Dependencies", 0)
        reaper.ReaPack_BrowsePackages(missingDepsStr)
        return true
    end

    return false
end

if checkDependencies() then return end

local function print(v) reaper.ShowConsoleMsg("\n" .. v) end

local function print2(v)
    ; reaper.ShowConsoleMsg('\n' .. type(v) .. '\n' .. tostring(v));
end

local function printTable(t, indent, parentKey)
    if not indent then indent = 0 end
    if not parentKey then parentKey = "" end

    local function buildString(t, indent, parentKey)
        local toprint = string.rep(" ", indent) .. "{\n"
        indent = indent + 2
        for k, v in pairs(t) do
            local keyString = parentKey .. "[" .. tostring(k) .. "]"
            toprint = toprint .. string.rep(" ", indent) .. keyString .. " = "
            if (type(v) == "number") then
                toprint = toprint .. v .. ",\n"
            elseif (type(v) == "string") then
                toprint = toprint .. "\"" .. v .. "\",\n"
            elseif (type(v) == "table") then
                toprint = toprint .. buildString(v, indent + 2, keyString)
                toprint = toprint .. string.rep(" ", indent) -- To format closing brace of nested table
            else
                toprint = toprint .. "\"" .. tostring(v) .. "\",\n"
            end
        end
        toprint = toprint .. string.rep(" ", indent - 2) .. "}"
        return toprint
    end

    local tableString = buildString(t, indent, parentKey)
    reaper.ShowConsoleMsg(tableString) -- Display table in REAPER console
end

local function printHere()

end

-- Set ToolBar Button State
local function SetButtonState(set)
    local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
    reaper.SetToggleCommandState(sec, cmd, set or 0)
    reaper.RefreshToolbar2(sec, cmd)
end

local function Exit()
    SetButtonState()
end

------------------]]
local script_path = debug.getinfo(1, "S").source:match [[^@?(.*[\/])[^\/]-$]]
local resources_path = script_path .. "Resources/"
local themes_path = script_path .. "Themes/"
package.path = package.path .. ";" .. resources_path .. "?.lua"
info = debug.getinfo(1, 'S')
------------------------------
local themeEditor = dofile(script_path .. '/Modules/Theme Editor.lua')
local colors = themeEditor(script_path, resources_path, themes_path)
local serpent = require("serpent")

local CONFIG = {
    int_mousewheel_sensitivity = 1,
    int_mousewheel_sensitivity_fine = 1,
    double_mousewheel_sensitivity = 0.1,
    double_mousewheel_sensitivity_fine = 0.01,
}

local reset = {}
local size_modifier = 1
-- local obj_x, obj_y = 20 * size_modifier, 34 * size_modifier
local patternSlider = 1
local lengthSlider = 16
local buttonName = " "
local buttonStates = {}
local track_suffix = " SEQ"
local target_track_name = "Patterns" .. track_suffix
local child_track_names = { "1" .. track_suffix, "2" .. track_suffix, "3" .. track_suffix, "4" .. track_suffix,
    "5" .. track_suffix, "6" .. track_suffix, "7" .. track_suffix, "8" .. track_suffix, "9" .. track_suffix, "10" ..
track_suffix,
    "11" .. track_suffix, "12" .. track_suffix, "13" .. track_suffix }
local patternLengths = {}
local snapToEnabled = snapToEnabled or false
local snapAmount = snapAmount or 8
local selectedChannelButton = 0
local mainChildX = tonumber(reaper.GetExtState("PreferencesChildWindowSettings", "mainChildX")) or 1200
local clipboardButtonStates = nil
local clipboard = {} -- To hold the clipboard data for copy and cut actions
local hoveredControlInfo = { id = "", value = 0 }
local buttonStatesCache = {}
local show_VelocitySliders = show_VelocitySliders or false
local show_OffsetSliders = show_OffsetSliders or false
local snapToEnabled = snapToEnabled or false
local snapAmount = snapAmount or 8
local drag_start_x = nil
local drag_start_y = nil
local wasMouseDownL = false
local wasMouseDownR = false
local processedButtons = processedButtons or {}
local showColorPicker = false
local showFPS = true
local showPreferencesPopup = false
local patternItemsCache = {} -- Cache for memoization
-- local patternItems = {}
local buttonCoordinates = {}
local drag_started = false
local controlSidebarWidth = 206
local time_resolution = 4
local update_required = true
local top_row_x = 34
local rv_vol = false
local findTempoMarker = false
local value
local valueSnap
local sliderTriggered = false
local triggerTime = 0
local triggerDuration = 0.1 -- duration in seconds for which the slider stays on
local originalSizeModifier, originalObjX, originalObjY
local patternItemsCache = patternItemsCache or {}
local showPopup = false
local copiedValue
-- menu_open = nil
local numberOfSliders = 64 -- Define how many sliders you want
local sliderWidth = 20
local sliderHeight = 269
local x_padding = 1
local right_drag_start_x = nil
local right_drag_start_y = nil
local tension = 0 -- Initial tension level, can be adjusted with the mouse wheel
local fontSize = 12
local fontSidebarButtonsSize = 11
local slider = {}

for i = 0, numberOfSliders - 1 do
    local value = 0 -- Default value for each slider
    table.insert(slider, { value = value })
end


local channel = {
    channel_amount = {},
    GUID = {
        name = {},
        file_path = {},
        types = {},
        droppedFile = {},
        volume = {},
        pan = {},
        mute = {},
        solo = {},
        plugins = {},
        trackIndex = {},
        selected = {},
        pattern_number = {
            button_states = {},
            item_present = {},
            velocity = {},
            pan = {},
            swing = {},
            offset = {},
            pitch = {},
            pitch_fine = {},
        },
    },
}

local parent = {
    channel_amount = {},
    GUID = {
        name = {},
        volume = {},
        pan = {},
        mute = {},
        solo = {},
        trackIndex = {},
        selected = {}

    },
}

local lastState = {
    volume = {},
    pan = {},
    mute = {},
    solo = {}
}

------------------------------------------------------ FUNCTIONS ----------------------------------------------

---- DATA MANAGEMENT  ---------------------------------

local function save_channel_data()
    local data_to_save = {
        file_path = channel.GUID.file_path,
    }

    local serialized_data = serpent.dump(data_to_save)
    reaper.SetExtState("McSequencer", "channelData", serialized_data, true)
end

local function load_channel_data()
    local serialized_data = reaper.GetExtState("McSequencer", "channelData")
    if serialized_data and serialized_data ~= "" then
        local ok, data_to_load = serpent.load(serialized_data)
        if ok then
            channel.GUID.file_path = data_to_load.file_path
        else
        end
    end
end

local function clear_extstate_channel_data()
    -- Set the file_path table to an empty table
    channel.GUID.file_path = {}

    -- Save the cleared data using the save_channel_data function
    save_channel_data()
end

local function update_channel_data_from_reaper(track_suffix, track_count)
    if not track_suffix then
        return
    end
    if not track_count then
        track_count = reaper.CountTracks(0)
    end
    local count = 0

    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track, "")

        -- Exclude tracks starting with "Patterns" and ending with " SEQ"
        if string.match(track_name, "^Patterns.*" .. track_suffix .. "$") then
            parent.GUID.trackIndex[0] = i
            parent.GUID[0] = track
            parent.GUID.name[0] = track_name
            local volume = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
            parent.GUID.volume[0] = volume
            local pan = reaper.GetMediaTrackInfo_Value(track, "D_PAN")
            parent.GUID.pan[0] = pan
            local mute = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
            parent.GUID.mute[0] = mute
            local solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
            parent.GUID.solo[0] = solo
            goto continue
        end

        -- Include tracks ending with " SEQ" (as defined by track_suffix)
        if string.sub(track_name, -string.len(track_suffix)) == track_suffix then
            count = count + 1
            channel.GUID.trackIndex[count] = i
            channel.GUID.name[count] = track_name
            local volume = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
            channel.GUID.volume[count] = volume
            local pan = reaper.GetMediaTrackInfo_Value(track, "D_PAN")
            channel.GUID.pan[count] = pan
            local mute = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
            channel.GUID.mute[count] = mute
            local solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
            channel.GUID.solo[count] = solo
        end

        ::continue::
    end

    channel.channel_amount = count

    return channel
end

local function apply_channel_data_to_reaper(track_suffix, track_count)
    local count = 0

    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        if not track then return end
        local _, track_name = reaper.GetTrackName(track, "")

        if string.match(track_name, "^Patterns.*" .. track_suffix .. "$") then
            if parent.GUID.volume[0] and parent.GUID.volume[0] ~= lastState.volume[0] then
                reaper.SetMediaTrackInfo_Value(track, "D_VOL", parent.GUID.volume[0])
                lastState.volume[0] = parent.GUID.volume[0]
            end

            -- Apply pan
            if parent.GUID.pan[0] and parent.GUID.pan[0] ~= lastState.pan[0] then
                reaper.SetMediaTrackInfo_Value(track, "D_PAN", parent.GUID.pan[0])
                lastState.pan[0] = parent.GUID.pan[0]
            end

            -- Apply mute
            if parent.GUID.mute[0] ~= nil and parent.GUID.mute[0] ~= lastState.mute[0] then
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", parent.GUID.mute[0])
                lastState.mute[0] = parent.GUID.mute[0]
            end

            -- Apply solo
            if parent.GUID.solo[0] ~= nil and parent.GUID.solo[0] ~= lastState.solo[0] then
                reaper.SetMediaTrackInfo_Value(track, "I_SOLO", parent.GUID.solo[0])
                lastState.solo[0] = parent.GUID.solo[0]
            end
        end

        if
            string.sub(track_name, -string.len(track_suffix)) == track_suffix
            and not string.match(track_name, "^Patterns")
        then
            count = count + 1

            -- Apply volume
            if channel.GUID.volume[count] and channel.GUID.volume[count] ~= lastState.volume[count] then
                reaper.SetMediaTrackInfo_Value(track, "D_VOL", channel.GUID.volume[count])
                lastState.volume[count] = channel.GUID.volume[count]
            end

            -- Apply pan
            if channel.GUID.pan[count] and channel.GUID.pan[count] ~= lastState.pan[count] then
                reaper.SetMediaTrackInfo_Value(track, "D_PAN", channel.GUID.pan[count])
                lastState.pan[count] = channel.GUID.pan[count]
            end

            -- Apply mute
            if channel.GUID.mute[count] ~= nil and channel.GUID.mute[count] ~= lastState.mute[count] then
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", channel.GUID.mute[count])
                lastState.mute[count] = channel.GUID.mute[count]
            end

            -- Apply solo
            if channel.GUID.solo[count] ~= nil and channel.GUID.solo[count] ~= lastState.solo[count] then
                reaper.SetMediaTrackInfo_Value(track, "I_SOLO", channel.GUID.solo[count])
                lastState.solo[count] = channel.GUID.solo[count]
            end
        end
    end
end

local function update(ctx, track_count, track_suffix, channel)
    if reaper.ImGui_IsAnyItemActive(ctx) or reaper.ImGui_IsAnyItemHovered(ctx) then
        apply_channel_data_to_reaper(track_suffix, track_count);
        if update_required then
            channel = update_channel_data_from_reaper(track_suffix, track_count);
            update_required = false;
        end;
    else
        update_channel_data_from_reaper(track_suffix, track_count);
    end;
    return channel
end


local function retrieveExtState()
    -- Retrieve the last selected pattern
    local lastSelectedPattern = tonumber(reaper.GetExtState("PatternController", "lastSelectedPattern"))
    if lastSelectedPattern then
        patternSlider = lastSelectedPattern
    else
        patternSlider = 1
    end
end

---- UTILITY  ---------------------------------

local function toboolean(str)
    return str == "true"
end

local function shorten_name(name, track_suffix)
    -- Remove the track_suffix from the name
    local cleaned_name = name:gsub(track_suffix, "")

    -- Shorten long names by displaying the beginning and end of the name
    if #cleaned_name > 10 then
        cleaned_name = cleaned_name:sub(1, 9) .. ".." .. cleaned_name:sub(-2)
    end

    return cleaned_name
end

local function rectsIntersect(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
    return ax1 <= bx2 and ax2 >= bx1 and ay1 <= by2 and ay2 >= by1
end

local function goToLoopStart()
    reaper.PreventUIRefresh(1)
    -- Save current view and time selection
    local view_start, view_end = reaper.BR_GetArrangeView(0) -- Requires SWS Extension
    local startTime, endTime = reaper.GetSet_LoopTimeRange(false, true, 0, 0, false)
    -- Handling time navigation
    if startTime ~= endTime then
        -- Go to start of loop
        reaper.SetEditCurPos(startTime, true, true)
    else
        -- Go to start of project
        reaper.SetEditCurPos(0, true, true)
    end
    -- Restore view
    reaper.BR_SetArrangeView(0, view_start, view_end) -- Requires SWS Extension
    -- Focusing MIDI Editor (if required)
    -- This might still need Main_OnCommand, especially if it's a specific custom action or script
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR"), 0)
    reaper.PreventUIRefresh(-1)
end

----- GENERIC GUI OBJECT CLASS -----

local function obj_Button(ctx, id, is_active, color_active, color_inactive, color_border, border_size, button_width,
                          button_height, hoveredinfo)
    local button_color = is_active and color_active or color_inactive
    local hovered_color = button_color -- Hovered color is the same as button color
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), button_color)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), hovered_color)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), color_border)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), color_active)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), border_size) -- Border size
    local rv = reaper.ImGui_Button(ctx, id, button_width, button_height)                 -- Adjust button size (width, height) as needed
    reaper.ImGui_PopStyleColor(ctx, 4)                                                   -- Pop all three colors
    reaper.ImGui_PopStyleVar(ctx)                                                        -- Pop border size

    if hoveredinfo then
        if reaper.ImGui_IsItemHovered(ctx) then
            hoveredControlInfo.id = hoveredinfo
        end
    else
        if reaper.ImGui_IsItemHovered(ctx) or is_active then
            hoveredControlInfo.id = id
            hoveredControlInfo.value = is_active
        end
    end
    return rv -- Return whether the button was clicked
end

-- Custom mapping function for knob value
local function mapKnobValue(value, min, max)
    local normalizedValue = (value - min) / (max - min)
    local skewedValue = normalizedValue ^ 0.4 -- Skew the curve to give more resolution at lower values
    return skewedValue
end

local function inverseMapKnobValue(skewedValue, min, max)
    local linearValue = skewedValue ^ 2.5 -- Inverse of the mapKnobValue function
    return linearValue * (max - min) + min
end

local function obj_Knob_Menu(ctx, value_knob)
    if reaper.ImGui_MenuItem(ctx, "Copy") then
        copiedValue = value_knob
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end
    if reaper.ImGui_MenuItem(ctx, "Paste") then
        if value_knob and copiedValue then
            value_knob = copiedValue
            isChanged = true
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
    end

    -- Intercept key presses
    if reaper.ImGui_IsWindowFocused(ctx) then
        local is_key_c_pressed = reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_C())
        local is_key_v_pressed = reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_V())
        if is_key_c_pressed then
            copiedValue = value_knob
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        elseif is_key_v_pressed then
            if value_knob then
                value_knob = copiedValue
                isChanged = true
                reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
            end
        end
    end


    reaper.ImGui_EndPopup(ctx)


    return value_knob, isChanged
end

local function obj_VolKnob(ctx, id, size, value_knob, min, max, default_value_knob, snapAmount, sensitivity,
                           fine_sensitivity,
                           color_bg, color_line, color_inner, showID, drag_sensitivity, fine_drag_sensitivity, applySnap,
                           vertical_offset, keys, mouse)
    local cursorPos = { reaper.ImGui_GetCursorScreenPos(ctx) }
    cursorPos[2] = cursorPos[2] + (vertical_offset or 0) -- Consolidated vertical_offset check
    local center = { cursorPos[1] + size, cursorPos[2] + size }
    local lineHeight = reaper.ImGui_GetTextLineHeight(ctx)
    -- local drawList = reaper.ImGui_GetWindowDrawList(ctx)
    local _, innerSpacingY = reaper.ImGui_GetStyleVar(ctx, reaper.ImGui_StyleVar_ItemInnerSpacing())
    local mouseMoveX, mouseMoveY = reaper.ImGui_GetMouseDelta(ctx)
    reaper.ImGui_InvisibleButton(ctx, id, size * 2, size * 1.2 + lineHeight + innerSpacingY)
    local isActive = reaper.ImGui_IsItemActive(ctx)
    local isChanged = false

    -- Determine the sensitivity based on key modifiers
    local actual_sensitivity = sensitivity
    local actual_drag_sensitivity = drag_sensitivity

    if keys.ctrlDown then
        actual_sensitivity = fine_sensitivity * 0.5
        actual_drag_sensitivity = fine_drag_sensitivity * 0.5
    end

    if keys.ctrlShiftDown then
        actual_sensitivity = fine_sensitivity * 0.25
        actual_drag_sensitivity = fine_drag_sensitivity * 0.25
    end

    if keys.shiftDown then
        actual_sensitivity = fine_sensitivity
        actual_drag_sensitivity = fine_drag_sensitivity
    end

    -- Mouse drag logic
    if isActive and (mouseMoveY ~= 0.0 or mouseMoveX ~= 0.0) then
        local delta = -(mouseMoveY - mouseMoveX)
        local factor = isWheel and 30 or 300 -- Consider increasing these factors for less sensitivity
        local sensitivityAdjustment = 0.25   -- Reduce this value to decrease overall sensitivity
        local change = delta * actual_drag_sensitivity * sensitivityAdjustment * (max - min) / factor
        local currentMappedValue = mapKnobValue(value_knob, min, max)
        local newMappedValue = math.max(math.min(currentMappedValue + change, 1), 0)
        value_knob = inverseMapKnobValue(newMappedValue, min, max)
        isChanged = true
    end

    -- Mouse wheel logic
    if reaper.ImGui_IsItemHovered(ctx) then
        local wheel = reaper.ImGui_GetMouseWheel(ctx)
        if wheel ~= 0 then
            local wheelFactor = 139 -- Adjust this factor for mouse wheel sensitivity
            local wheelChange = wheel * actual_sensitivity * (max - min) / wheelFactor
            local currentMappedValue = mapKnobValue(value_knob, min, max)
            local newMappedValue = math.max(math.min(currentMappedValue + wheelChange, 1), 0)
            value_knob = inverseMapKnobValue(newMappedValue, min, max)
            isChanged = true
        end
    end
    -- Reset on double-click
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsMouseDoubleClicked(ctx, 0) then
        value_knob = default_value_knob
        isChanged = true
    end

    -- Right-click menu
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, id)
    end

    if reaper.ImGui_BeginPopup(ctx, id, reaper.ImGui_WindowFlags_NoMove()) then
        value_knob, isChanged = obj_Knob_Menu(ctx, value_knob)
    end

    -- draw the knob
    local mappedValue = mapKnobValue(value_knob, min, max)
    local angle = 3.141592 * (0.75 + 1.5 * mappedValue)
    local inner_radius = size * 0.382
    reaper.ImGui_DrawList_AddCircleFilled(drawList, center[1], center[2], size, color_bg, 64)
    reaper.ImGui_DrawList_AddLine(drawList, center[1] + math.cos(angle) * inner_radius,
        center[2] + math.sin(angle) * inner_radius,
        center[1] + math.cos(angle) * (size - 2),
        center[2] + math.sin(angle) * (size - 2), color_line, 1.0)

    if showID then
        local textWidth = reaper.ImGui_CalcTextSize(ctx, id)
        reaper.ImGui_DrawList_AddText(drawList, cursorPos[1] + size - textWidth / 2,
            cursorPos[2] + size * 2 + innerSpacingY,
            reaper.ImGui_GetColor(ctx, reaper.ImGui_Col_Text()), id)
    end

    if reaper.ImGui_IsItemHovered(ctx) or isActive then
        hoveredControlInfo.id = id
        hoveredControlInfo.value = value_knob
    end

    return isChanged, value_knob
end

local function obj_Knob(ctx, id, size, value_knob, min, max, default_value_knob, snapAmount, sensitivity,
                        fine_sensitivity,
                        color_bg, color_line, color_inner, showID, drag_sensitivity, fine_drag_sensitivity, applySnap,
                        vertical_offset, keys)
    local cursorPos = { reaper.ImGui_GetCursorScreenPos(ctx) }
    cursorPos[2] = cursorPos[2] + (vertical_offset or 0) -- Consolidated vertical_offset check
    local center = { cursorPos[1] + size, cursorPos[2] + size }
    local lineHeight = reaper.ImGui_GetTextLineHeight(ctx)
    -- local drawList = reaper.ImGui_GetWindowDrawList(ctx)
    local _, innerSpacingY = reaper.ImGui_GetStyleVar(ctx, reaper.ImGui_StyleVar_ItemInnerSpacing())
    local mouseMoveX, mouseMoveY = reaper.ImGui_GetMouseDelta(ctx)
    reaper.ImGui_InvisibleButton(ctx, id, size * 2, size * 1.2 + lineHeight + innerSpacingY)
    local isActive = reaper.ImGui_IsItemActive(ctx)

    -- Determine the sensitivity based on key modifiers
    local actual_sensitivity = sensitivity
    local actual_drag_sensitivity = drag_sensitivity

    if keys.shiftDown then
        actual_sensitivity = fine_sensitivity
        actual_drag_sensitivity = fine_drag_sensitivity
    end

    if keys.ctrlDown then
        actual_sensitivity = fine_sensitivity * 0.5
        actual_drag_sensitivity = fine_drag_sensitivity * 0.5
    end

    if keys.ctrlShiftDown then
        actual_sensitivity = fine_sensitivity * 0.25
        actual_drag_sensitivity = fine_drag_sensitivity * 0.25
    end

    local isChanged = false


    local function applyChange(delta, speed, isWheel, snapEnabled)
        local factor = isWheel and 30 or 300
        local change = delta * speed * (max - min) / factor
        local newValue = value_knob + change

        if snapEnabled and applySnap and snapAmount and snapAmount > 0 then
            if snapAmount == 0.5 then
                newValue = math.floor(newValue / 0.5 + 0.5) * 0.5
            else
                newValue = snapAmount * math.floor(newValue / snapAmount + 0.5)
            end
        end

        return math.max(math.min(newValue, max), min)
    end


    -- Mouse drag logic
    if isActive and (mouseMoveY ~= 0.0 or mouseMoveX ~= 0.0) then
        local snapEnabled = not (keys.shiftDown or keys.ctrlDown or keys.ctrlShiftDown)
        value_knob = applyChange(-(mouseMoveY - mouseMoveX), actual_drag_sensitivity, false, snapEnabled)
        isChanged = true
    end

    -- Mouse wheel logic
    if reaper.ImGui_IsItemHovered(ctx) then
        local wheel = reaper.ImGui_GetMouseWheel(ctx)
        if wheel ~= 0 then
            local snapEnabled = not (keys.shiftDown or keys.ctrlDown or keys.ctrlShiftDown)
            value_knob = applyChange(wheel, actual_sensitivity, true, snapEnabled)
            isChanged = true
        end
    end

    -- Reset on double-click
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsMouseDoubleClicked(ctx, 0) then
        value_knob = default_value_knob
        isChanged = true
    end

    -- Right-click menu
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, id)
    end

    if reaper.ImGui_BeginPopup(ctx, id, reaper.ImGui_WindowFlags_NoMove()) then
        value_knob, isChanged = obj_Knob_Menu(ctx, value_knob)
    end

    if value_knob then
        -- draw the knob
        local angle = 3.141592 * (0.75 + 1.5 * (value_knob - min) / (max - min))
        local inner_radius = size * 0.382
        reaper.ImGui_DrawList_AddCircleFilled(drawList, center[1], center[2], size, color_bg, 64)
        reaper.ImGui_DrawList_AddLine(drawList, center[1] + math.cos(angle) * inner_radius,
            center[2] + math.sin(angle) * inner_radius,
            center[1] + math.cos(angle) * (size - 2),
            center[2] + math.sin(angle) * (size - 2), color_line, 1.0)
    end

    if showID then
        local textWidth = reaper.ImGui_CalcTextSize(ctx, id)
        reaper.ImGui_DrawList_AddText(drawList, cursorPos[1] + size - textWidth / 2,
            cursorPos[2] + size * 2 + innerSpacingY,
            reaper.ImGui_GetColor(ctx, reaper.ImGui_Col_Text()), id)
    end

    if reaper.ImGui_IsItemHovered(ctx) or isActive then
        hoveredControlInfo.id = id
        hoveredControlInfo.value = value_knob
    end

    return isChanged, value_knob
end

local function obj_Knob_Exp(ctx, id, size, value_knob, min, max, default_value_knob, SnapAmount, sensitivity,
                            fine_sensitivity, color_bg, color_line, color_inner, showID, drag_sensitivity,
                            fine_drag_sensitivity, curveExp, keys)
    local cursorPos = { reaper.ImGui_GetCursorScreenPos(ctx) }
    local center = { cursorPos[1] + size, cursorPos[2] + size }
    local lineHeight = reaper.ImGui_GetTextLineHeight(ctx)
    -- local drawList = reaper.ImGui_GetWindowDrawList(ctx)
    local innerSpacing = { reaper.ImGui_GetStyleVar(ctx, reaper.ImGui_StyleVar_ItemInnerSpacing()) }
    local mouseMove = { reaper.ImGui_GetMouseDelta(ctx) }
    reaper.ImGui_InvisibleButton(ctx, id, size * 2, size * 1.2 + lineHeight + innerSpacing[2])
    local isChanged = false
    local isActive = reaper.ImGui_IsItemActive(ctx)
    -- local shiftHeld = (reaper.ImGui_GetKeyMods(ctx)) ~= 0

    -- Normalize the value
    local normalized_value = (value_knob - min) / (max - min)

    -- Apply exponential curve to normalized value
    local curved_value = normalized_value ^ curveExp

    -- Define the actual sensitivity based on key modifiers
    local actual_drag_sensitivity = keys.ctrlShiftDown and fine_drag_sensitivity * 0.25 or
    (keys.ctrlDown and fine_drag_sensitivity * 0.5 or (keys.shiftDown and fine_drag_sensitivity or drag_sensitivity))
    local actual_sensitivity = keys.ctrlShiftDown and fine_sensitivity * 0.25 or
    (keys.ctrlDown and fine_sensitivity * 0.5 or (keys.shiftDown and fine_sensitivity or sensitivity))

    -- Mouse dragging section
    if isActive and (mouseMove[2] ~= 0.0 or mouseMove[1] ~= 0.0) then
        local value_change = -((mouseMove[2] - mouseMove[1]) * (max - min) / 300) * actual_drag_sensitivity
        -- Apply change to curved value
        curved_value = curved_value + value_change
        curved_value = math.max(math.min(curved_value, 1), 0)
        -- Reverse transformation
        normalized_value = curved_value ^ (1 / curveExp)
        value_knob = min + normalized_value * (max - min)
        isChanged = true
    end

    -- Apply mousewheel
    if reaper.ImGui_IsItemHovered(ctx) then
        local wheel, _ = reaper.ImGui_GetMouseWheel(ctx)
        if wheel ~= 0 then
            -- Apply change to curved value
            curved_value = curved_value + (wheel * actual_sensitivity)
            curved_value = math.max(math.min(curved_value, 1), 0)
            -- Reverse transformation
            normalized_value = curved_value ^ (1 / curveExp)
            value_knob = min + normalized_value * (max - min)
            isChanged = true
        end
    end


    local angle = 3.141592 * (0.75 + 1.5 * curved_value)
    local inner_radius = size * 0.382
    reaper.ImGui_DrawList_AddCircleFilled(drawList, center[1], center[2], size, color_bg, 64)
    reaper.ImGui_DrawList_AddLine(drawList, center[1] + math.cos(angle) * inner_radius,
        center[2] + math.sin(angle) * inner_radius, center[1] + math.cos(angle) * (size - 2),
        center[2] + math.sin(angle) * (size - 2), color_line, 1.0)
    reaper.ImGui_DrawList_AddCircleFilled(drawList, center[1], center[2], inner_radius, color_inner, 16)
    -- Only show ID text if showID is true
    if showID then
        reaper.ImGui_DrawList_AddText(drawList, cursorPos[1] + size - reaper.ImGui_CalcTextSize(ctx, id) / 2,
            cursorPos[2] + size * 2 + innerSpacing[2], reaper.ImGui_GetColor(ctx, reaper.ImGui_Col_Text()), id)
    end

    -- Reset on double-click
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsMouseDoubleClicked(ctx, 0) then
        value_knob = default_value_knob
    end

    -- Right-click menu
    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, id)
    end

    if reaper.ImGui_BeginPopup(ctx, id, reaper.ImGui_WindowFlags_NoMove()) then
        value_knob, isChanged = obj_Knob_Menu(ctx, value_knob)
    end

    -- Update the hoveredControlInfo with the current control's ID and value
    if reaper.ImGui_IsItemHovered(ctx) or reaper.ImGui_IsItemActive(ctx) then
        hoveredControlInfo.id = id
        hoveredControlInfo.value = value_knob
    end

    return isChanged, value_knob
end

---- TRACK RELATED  ---------------------------------

local function create_or_find_track(target_track_name, num_child_tracks, track_suffix)
    local num_tracks = reaper.CountTracks(0)
    -- Search for the target track
    for i = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if track_name == target_track_name then
            return track
        end
    end
    -- Create the target track if not found
    reaper.InsertTrackAtIndex(num_tracks, true)
    local target_track = reaper.GetTrack(0, num_tracks)
    reaper.GetSetMediaTrackInfo_String(target_track, "P_NAME", target_track_name, true)
    reaper.GetSetTrackGroupMembership(target_track, 'MEDIA_EDIT_LEAD', 1, 1)
    -- Create child tracks
    for i = 1, num_child_tracks do
        local child_track_name = tostring(i) .. track_suffix
        reaper.InsertTrackAtIndex(num_tracks + i, true)
        local child_track = reaper.GetTrack(0, num_tracks + i)
        reaper.GetSetMediaTrackInfo_String(child_track, "P_NAME", child_track_name, true)
        -- Set target track as the folder parent
        if i == 1 then
            reaper.SetMediaTrackInfo_Value(target_track, "I_FOLDERDEPTH", 1)
        end
        -- Close folder after the last child track
        if i == num_child_tracks then
            reaper.SetMediaTrackInfo_Value(child_track, "I_FOLDERDEPTH", -1)
        end
        reaper.GetSetTrackGroupMembership(child_track, 'MEDIA_EDIT_FOLLOW', 1, 1)
        -- Add Swing instance to the new track
        local fx_swing = reaper.TrackFX_AddByName(child_track, "Note Trigger", false, -1)
        local fx_swing = reaper.TrackFX_AddByName(child_track, "Swing", false, -1)
        reaper.TrackFX_Show(child_track, fx_swing, 2)
    end
    reaper.UpdateArrange()
    return target_track
end



local function findTrackByName(trackName)
    local numTracks = reaper.CountTracks(0)
    for i = 0, numTracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, currentName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if currentName == trackName then
            return track
        end
    end
    return nil
end

local function unselectNonSuffixedTracks()
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track, "")

        -- Unselect the track named "Patterns SEQ"
        if trackName == "Patterns SEQ" then
            reaper.SetTrackSelected(track, false)
            -- Select tracks that end with "SEQ" and are not named "Patterns SEQ"
        elseif trackName:sub(-3) == "SEQ" then
            -- reaper.SetTrackSelected(track, true)
            -- Unselect all other tracks
        else
            reaper.SetTrackSelected(track, false)
        end
    end
end

local function selectAllSuffixedTracks()
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track, "")

        -- Unselect the track named "Patterns SEQ"
        if trackName == "Patterns SEQ" then
            reaper.SetTrackSelected(track, false)
            -- Select tracks that end with "SEQ" and are not named "Patterns SEQ"
        elseif trackName:sub(-3) == "SEQ" then
            reaper.SetTrackSelected(track, true)
            -- Unselect all other tracks
        else
            reaper.SetTrackSelected(track, false)
        end
    end
end

local function toggleSelectTracksEndingWithSEQ()
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track, "")
        if trackName:sub(-3) == "SEQ" and trackName ~= "Patterns SEQ" then
            local isSelected = reaper.IsTrackSelected(track)
            reaper.SetTrackSelected(track, not isSelected)
        end
    end
end

local function track_name_exists(name)
    local num_tracks = reaper.CountTracks(0)
    for i = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track, "")
        if track_name == name then
            return true
        end
    end
    return false
end

local function unselectAllTracks()
    local track_count = reaper.CountTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        reaper.SetTrackSelected(track, false)
    end
end

local function selectOnlyTrack(track)
    unselectAllTracks()
    local track_to_select = reaper.GetTrack(0, track)
    if track_to_select ~= nil then
        reaper.SetTrackSelected(track_to_select, true)
    end
end

local function moveTracksUpWithinFolders()
    local countSelTracks = reaper.CountSelectedTracks(0)
    if countSelTracks == 0 then return end

    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    for i = 0, countSelTracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local trackNum = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")

        if trackNum > 1 then
            local prevTrack = reaper.GetTrack(0, trackNum - 2)

            local trackDepth = reaper.GetTrackDepth(track)
            local prevTrackDepth = reaper.GetTrackDepth(prevTrack)

            -- Check if the previous track is at the same depth or one level lower (indicating a parent folder)
            if prevTrackDepth == trackDepth or prevTrackDepth ~= trackDepth - 1 then
                reaper.ReorderSelectedTracks(trackNum - 2, 0)
            end
        end
    end

    reaper.Undo_EndBlock("Move selected tracks up within their folders", -1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
end

local function moveTracksDownWithinFolders()
    local countSelTracks = reaper.CountSelectedTracks(0)
    if countSelTracks == 0 then
        return
    end

    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    for i = 0, countSelTracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local trackNum = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")

        if trackNum > 1 then
            local nextTrack = reaper.GetTrack(0, trackNum + 1)
            if nextTrack then
                local trackDepth = reaper.GetTrackDepth(track)
                local nextTrackDepth = reaper.GetTrackDepth(nextTrack)
                -- Check if the previous track is at the same depth or one level lower (indicating a parent folder)
                if nextTrackDepth == trackDepth then
                    reaper.ReorderSelectedTracks(trackNum + 1, 0)
                end
                if nextTrackDepth == trackDepth - 1 then
                    reaper.ReorderSelectedTracks(trackNum + 1, 1)
                    local track = reaper.GetTrack(0, trackNum - 1)

                    if not track then
                        return
                    end

                    local prevTrack = reaper.GetTrack(0, trackNum - 2)
                    local nextTrack = reaper.GetTrack(0, trackNum)

                    if prevTrack then
                        local prevDepth = reaper.GetMediaTrackInfo_Value(prevTrack, "I_FOLDERDEPTH")
                        local currentDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
                        local nextDepth = nextTrack and reaper.GetMediaTrackInfo_Value(nextTrack, "I_FOLDERDEPTH") or 0

                        -- Adjust the track's depth to be at the same level as the previous track
                        reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", prevDepth > 0 and 0 or -prevDepth)

                        -- If the next track is a child, update its depth to maintain structure
                        if nextTrack and nextDepth < 0 then
                            reaper.SetMediaTrackInfo_Value(nextTrack, "I_FOLDERDEPTH", nextDepth - 1)
                        end
                    end
                end
            end
        end
    end

    reaper.Undo_EndBlock("Move selected tracks down within their folders", -1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
end

local function enumerateTrack(v)
    local track_count = reaper.CountTracks(0)
    local highest_suffix = 0

    -- Extract base name without the numeric suffix and SEQ, only if it follows an underscore
    local _, track_name = reaper.GetSetMediaTrackInfo_String(v, "P_NAME", "", false)
    local base_name, current_num_suffix = track_name:match("^(.-)_(%d+)%s?" .. track_suffix .. "$")
    base_name = base_name or track_name:match("^(.-)%s?" .. track_suffix .. "$") or track_name
    current_num_suffix = tonumber(current_num_suffix)

    -- Iterate through all tracks to find the highest suffix for the base name
    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local _, other_track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        local other_base_name, num_suffix = other_track_name:match("^(.-)_(%d+)%s?" .. track_suffix .. "$")
        other_base_name = other_base_name or other_track_name:match("^(.-)%s?" .. track_suffix .. "$")
        num_suffix = tonumber(num_suffix) or 0

        if other_base_name == base_name and (not current_num_suffix or num_suffix > 0) then
            highest_suffix = math.max(highest_suffix, num_suffix)
        end
    end

    -- Construct the new track name with enumeration before the suffix
    local new_track_name = base_name
    if highest_suffix >= 0 then
        new_track_name = new_track_name .. "_" .. tostring(highest_suffix + 1)
    end
    new_track_name = new_track_name .. "" .. track_suffix

    reaper.GetSetMediaTrackInfo_String(v, "P_NAME", new_track_name, true)
end

local function goToNextTrack()
    local countSelTracks = reaper.CountSelectedTracks(0)
    if countSelTracks == 0 then return end


    for i = 0, countSelTracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local trackNum = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1

        if trackNum > 1 then
            local prevTrack = reaper.GetTrack(0, trackNum - 1)

            local trackDepth = reaper.GetTrackDepth(track)
            local prevTrackDepth = reaper.GetTrackDepth(prevTrack)
            -- Check if the previous track is at the same depth or one level lower (indicating a parent folder)
            if prevTrackDepth == trackDepth or prevTrackDepth ~= trackDepth - 1 then
                unselectAllTracks()
                reaper.SetTrackSelected(prevTrack, true)
                -- reaper.ReorderSelectedTracks(trackNum - 1, 0)
            end
        end
    end
end

local function goToPreviousTrack()
    local countSelTracks = reaper.CountSelectedTracks(0)
    if countSelTracks == 0 then return end


    for i = 0, countSelTracks - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        local trackNum = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1

        if trackNum > 1 then
            local prevTrack = reaper.GetTrack(0, trackNum - 1)

            local trackDepth = reaper.GetTrackDepth(track)
            local prevTrackDepth = reaper.GetTrackDepth(prevTrack)
            -- Check if the previous track is at the same depth or one level lower (indicating a parent folder)
            if prevTrackDepth == trackDepth or prevTrackDepth ~= trackDepth - 1 then
                unselectAllTracks()
                reaper.SetTrackSelected(prevTrack, true)
                -- reaper.ReorderSelectedTracks(trackNum - 1, 0)
            end
        end
    end
end

---- ITEM  RELATED  ---------------------------------

local function unselectAllMediaItems()
    local itemCount = reaper.CountMediaItems(0)

    for i = 0, itemCount - 1 do
        local item = reaper.GetMediaItem(0, i)
        reaper.SetMediaItemSelected(item, false)
    end
end

local function findOrCreateMIDIItem(track, start_time, end_time)
    local itemCount = reaper.CountTrackMediaItems(track)
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if item_start == start_time and item_end == end_time then
            return item -- Return existing item
        end
    end
    -- Create new MIDI item if none found
    return reaper.CreateNewMIDIItemInProj(track, start_time, end_time, false)
end

local function findAndSelectLastItemOnTrack(trackName)
    local trackCount = reaper.CountTracks(0)
    local foundTrack = nil

    for i = 0, trackCount - 1 do
        local track = reaper.GetTrack(0, i)
        local _, currentTrackName = reaper.GetTrackName(track, "")
        if currentTrackName == trackName then
            foundTrack = track
            break
        end
    end

    if not foundTrack then
        return
    end

    local item_count = reaper.CountTrackMediaItems(foundTrack)
    local lastItem = nil
    local latestTime = -1

    for i = 0, item_count - 1 do
        local item = reaper.GetTrackMediaItem(foundTrack, i)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        if item_start > latestTime then
            latestTime = item_start
            lastItem = item
        end
    end

    if lastItem then
        unselectAllMediaItems()
        reaper.SetMediaItemSelected(lastItem, true)
        reaper.Main_OnCommand(40913, 0) -- Scroll view to selected items
    end
end

local function deleteUnwantedSelectedItems(exceptItem)
    -- Create a list of items to be deleted
    local itemsToDelete = {}
    for i = reaper.CountSelectedMediaItems(0) - 1, 0, -1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        if item ~= exceptItem then
            table.insert(itemsToDelete, item)
        end
    end

    -- Deselect all items
    reaper.Main_OnCommand(40289, 0) -- Unselect all items

    -- Select items to delete
    for _, item in ipairs(itemsToDelete) do
        reaper.SetMediaItemSelected(item, true)
    end

    -- Delete the selected items
    if #itemsToDelete > 0 then
        reaper.Main_OnCommand(40006, 0) -- Delete selected items
    end
end
---- PATTERN ITEMS  ---------------------------------

local function getPatternItems(track_count)
    --[[
    -- Check if result is already cached
    if patternItemsCache[track_suffix] then
        return patternItemsCache[track_suffix]
    end
    ]]


    local patternItems = {}
    -- local track_count = reaper.CountTracks(0)
    local trackNameToMatch = "Patterns" .. track_suffix
    local patternTrackIndex = nil -- Variable to store the name of the matched track
    local patternTrack = nil

    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track)

        -- Check if the track name matches "Patterns" followed by track_suffix
        if trackName == trackNameToMatch then
            patternTrackIndex = i -- Store the matched track name
            patternTrack = track
            local itemCount = reaper.CountTrackMediaItems(track)
            for j = 0, itemCount - 1 do
                local item = reaper.GetTrackMediaItem(track, j)
                local take = reaper.GetActiveTake(item)
                local _, itemName = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
                local patternNumber = tonumber(itemName:match("^Pattern (%d+)"))
                if patternNumber then
                    if not patternItems[patternNumber] then
                        patternItems[patternNumber] = {}
                    end
                    table.insert(patternItems[patternNumber], item)
                end
            end
        end
    end

    -- Store the result in the cache
    -- patternItemsCache[track_suffix] = patternItems
    return patternItems, patternTrackIndex, patternTrack
end
local function getSelectedPatternItemAndMidiItem(trackIndex, patternItems, patternSelectSlider)
    local selectedPatternData = patternItems[patternSelectSlider]
    if not (selectedPatternData and selectedPatternData[1]) then
        return
    end

    local pattern_item = selectedPatternData[1]
    local pattern_start = reaper.GetMediaItemInfo_Value(pattern_item, "D_POSITION")
    local pattern_length = reaper.GetMediaItemInfo_Value(pattern_item, "D_LENGTH")
    local pattern_end = pattern_start + pattern_length

    buttonStates[trackIndex] = {}
    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        return
    end

    local itemCount = reaper.CountTrackMediaItems(track)
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        -- If item starts after pattern ends, no need to continue checking further items
        if item_start > pattern_end then
            break
        end

        local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local item_end = item_start + item_length

        if item_start >= pattern_start and item_end <= pattern_end then
            local take = reaper.GetMediaItemTake(item, 0)
            if reaper.TakeIsMIDI(take) then
                return pattern_item, pattern_start, pattern_end, item, track
            end
        end
    end

    return pattern_item, pattern_start, pattern_end, nil, track
end


local function create_pattern_item_if_not_exist(track_suffix)
    local track_name = "Patterns" .. track_suffix
    local num_tracks = reaper.CountTracks(0)
    local patterns_track = nil

    -- Search for the track with the specified name
    for i = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, current_track_name = reaper.GetTrackName(track, "")
        if current_track_name == track_name then
            patterns_track = track
            break
        end
    end

    if not patterns_track then
        return
    end

    local item_found = false
    local num_items = reaper.CountTrackMediaItems(patterns_track)

    -- Check if there's any item starting with the word "Pattern"
    for i = 0, num_items - 1 do
        local item = reaper.GetTrackMediaItem(patterns_track, i)
        local take = reaper.GetMediaItemTake(item, 0)
        local _, item_name = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
        if item_name:match("^Pattern") then
            item_found = true
            break
        end
    end

    -- If no item found, create an empty MIDI item named "Patterns 1"
    if not item_found then
        local loop_start, loop_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        local item_length = loop_end - loop_start > 0 and loop_end - loop_start
            or 8 * reaper.TimeMap2_beatsToTime(0, 1)
        local new_item = reaper.CreateNewMIDIItemInProj(patterns_track, loop_start, loop_start + item_length, false)
        local new_take = reaper.GetMediaItemTake(new_item, 0)
        reaper.GetSetMediaItemTakeInfo_String(new_take, "P_NAME", "Pattern 1", true)
    end
end

local function getItemsByPattern(track)
    local track = parent.GUID[0]
    if not track or not reaper.ValidatePtr(track, "MediaTrack*") then
        return nil
    end
    if track then
        local numItems = reaper.CountTrackMediaItems(track)
        local itemsByPattern = {}

        for i = 0, numItems - 1 do
            local item = reaper.GetTrackMediaItem(track, i)
            if item then
                local take = reaper.GetActiveTake(item)
                if take then
                    local _, itemName = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
                    local patternNumber = itemName:match("^Pattern (%d+)")
                    if patternNumber then
                        patternNumber = tonumber(patternNumber)
                        if not itemsByPattern[patternNumber] then
                            itemsByPattern[patternNumber] = {}
                        end
                        itemsByPattern[patternNumber][#itemsByPattern[patternNumber] + 1] = item
                    end
                end
            end
        end
        return itemsByPattern
    end
end



local function getNextPatternNumber(track)
    local patternNumbers = {}
    local itemCount = reaper.CountTrackMediaItems(track)

    -- Gather all existing pattern numbers
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local take = reaper.GetActiveTake(item)
        if take then
            local _, name = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
            local number = name:match("Pattern (%d+)")
            if number then
                patternNumbers[tonumber(number)] = true
            end
        end
    end

    -- Find the next available highest number
    local nextNum = 1
    while patternNumbers[nextNum] do
        nextNum = nextNum + 1
    end

    return nextNum
end

local function newPatternItem(maxPatternNumber)
    reaper.PreventUIRefresh(1)
    local trackName = "Patterns SEQ"
    local patternsTrack = findTrackByName(trackName)

    if not patternsTrack then
        reaper.ShowMessageBox("Track '" .. trackName .. "' not found.", "Error", 0)
        return
    end

    reaper.Undo_BeginBlock()

    findAndSelectLastItemOnTrack("Patterns SEQ")

    local selectedItem = reaper.GetSelectedMediaItem(0, 0)
    if not selectedItem then
        reaper.ShowMessageBox("No item selected.", "Error", 0)
        return
    end

    local itemPosition = reaper.GetMediaItemInfo_Value(selectedItem, "D_POSITION")
    local itemLength = reaper.GetMediaItemInfo_Value(selectedItem, "D_LENGTH")

    -- Store the selected items (except the item to be duplicated)
    local selectedItems = {}
    for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        if item ~= selectedItem then
            table.insert(selectedItems, item)
        end
    end

    -- Duplicate the item
    reaper.Main_OnCommand(41295, 0) -- Duplicate items
    reaper.Main_OnCommand(41613, 0) -- remove pool

    -- Find the duplicate
    local newItem = nil
    local itemCount = reaper.CountTrackMediaItems(patternsTrack)
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(patternsTrack, i)
        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        reaper.SetEditCurPos(pos, 0, 0)
        local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if pos >= itemPosition and len == itemLength and item ~= selectedItem then
            newItem = item
            break
        end
    end

    if newItem then
        -- Delete unwanted selected items
        deleteUnwantedSelectedItems(newItem)

        -- Rename the new item
        local nextPatternNumber = getNextPatternNumber(patternsTrack)
        local take = reaper.GetActiveTake(newItem)
        if take then
            reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "Pattern " .. nextPatternNumber, true)
        end
        reaper.SetMediaItemSelected(newItem, true)
    else
        reaper.ShowMessageBox("Unable to identify the duplicated item.", "Error", 0)
    end

    patternSelectSlider = maxPatternNumber + 1

    reaper.Undo_EndBlock("Duplicate and rename pattern", -1)
    reaper.UpdateArrange()
    reaper.PreventUIRefresh(-1)
end


---- STEP SEQUENCER BASIC FUNCTIONALITY  ---------------------------------

local function populateNotePositions(midi_item)
    if not midi_item then return {}, {} end

    local take = reaper.GetMediaItemTake(midi_item, 0)
    if not take or not reaper.TakeIsMIDI(take) then return {}, {} end

    local note_count, _, _ = reaper.MIDI_CountEvts(take)
    local note_positions = {}
    local note_velocities = {}

    for i = 0, note_count - 1 do
        local _, _, _, start_ppq, _, _, _, velocity = reaper.MIDI_GetNote(take, i)
        note_positions[i + 1] = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppq)
        note_velocities[i + 1] = velocity
    end

    return note_positions, note_velocities
end




local function insertMidiNote(trackIndex, buttonIndex, pitch, velocity, note_length, patternSelectSlider, startTime,
                              endTime, track_count)
    local track = reaper.GetTrack(0, trackIndex)
    local item_start = reaper.GetMediaItemInfo_Value(getPatternItems(track_count)[patternSelectSlider][1], "D_POSITION")
    local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1)
    local item_length_secs = lengthSlider * beatsInSec / time_resolution
    local item_end = item_start + item_length_secs
    local note_position = item_start + (buttonIndex - 1) * beatsInSec / time_resolution
    local itemCount = reaper.CountTrackMediaItems(track)
    local midi_item

    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        if itemPos <= note_position and note_position < (itemPos + itemLength) then
            midi_item = item
            break
        end
    end

    if not midi_item then
        midi_item = reaper.CreateNewMIDIItemInProj(track, item_start, item_end, false)
    end

    local take = reaper.GetMediaItemTake(midi_item, 0)
    if not reaper.ValidatePtr(take, "MediaItem_Take*") then
        reaper.ShowMessageBox("Failed to get MIDI take.", "Error", 0)
        return
    end

    if not reaper.TakeIsMIDI(take) then
        reaper.ShowMessageBox("The item is not a MIDI item.", "Error", 0)
        return
    end

    local note_ppq_position = reaper.MIDI_GetPPQPosFromProjTime(take, note_position)
    local bpm = reaper.TimeMap_GetDividedBpmAtTime(note_position)
    local beat_length_secs = 60 / bpm
    local sixteenth_note_length_secs = beat_length_secs / 8
    local note_end_time = note_position + sixteenth_note_length_secs
    local note_end_ppq_position = reaper.MIDI_GetPPQPosFromProjTime(take, note_end_time)

    reaper.MIDI_InsertNote(take, false, false, note_ppq_position, note_end_ppq_position, 0, pitch, velocity, false)

    reaper.UpdateArrange()
end
local function insertMidiPooledItems(trackIndex, patternSelectSlider, patternItems)
    reaper.Undo_BeginBlock()
    reaper.PreventUIRefresh(1)
    local cursor_pos = reaper.GetCursorPosition()
    -- Retrieve the pattern items for the selected pattern
    local patternMediaItems = patternItems[patternSelectSlider]

    -- Get the track at the specified index
    local targetTrack = reaper.GetTrack(0, trackIndex) -- Track index is 0-based

    for _, patternItem in ipairs(patternMediaItems) do
        -- Get the start and end times for the pattern item
        local itemStart = reaper.GetMediaItemInfo_Value(patternItem, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(patternItem, "D_LENGTH")

        -- Check for existing MIDI items on the target track that overlap with the current pattern item
        local existingMidiItemFound = false
        for i = 0, reaper.CountTrackMediaItems(targetTrack) - 1 do
            local item = reaper.GetTrackMediaItem(targetTrack, i)
            local midiItemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local midiItemEnd = midiItemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

            -- Check if the MIDI item overlaps with the pattern item
            if midiItemStart < itemEnd and midiItemEnd > itemStart then
                existingMidiItemFound = true
                reaper.Main_OnCommand(40289, 0) -- unselect all items
                --local nil_item = nil
                --reaper.SetMediaItemSelected(nil_item,1)
                reaper.SetMediaItemSelected(item, 1)
                reaper.Main_OnCommand(40698, 0) -- copy item

                break
            end
        end

        -- If no existing MIDI item overlaps, create a new one
        if not existingMidiItemFound then
            reaper.SetOnlyTrackSelected(targetTrack)
            reaper.SetEditCurPos(itemStart, false, false)
            reaper.Main_OnCommand(41072, 0) -- paste item pooled
        end
    end
    reaper.SetEditCurPos(cursor_pos, false, false)
    reaper.PreventUIRefresh(-1)



    reaper.Undo_EndBlock('Insert MIDI Notes', -1)
end

local function deleteMidiNote(trackIndex, buttonIndex, patternSelectSlider, patternItems)
    local track = reaper.GetTrack(0, trackIndex)
    if not track then return end

    local item_start = reaper.GetMediaItemInfo_Value(patternItems[patternSelectSlider][1], "D_POSITION")
    local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1)
    local note_position = item_start + (buttonIndex - 1) * beatsInSec / time_resolution
    local tolerance = beatsInSec / (time_resolution * 2)
    local startTime = note_position - tolerance
    local endTime = note_position + tolerance

    for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if itemPos <= note_position and note_position < (itemPos + itemLength) then
            local take = reaper.GetMediaItemTake(item, 0)
            if reaper.ValidatePtr(take, "MediaItem_Take*") and reaper.TakeIsMIDI(take) then
                local _, note_count = reaper.MIDI_CountEvts(take)
                local startPPQ = reaper.MIDI_GetPPQPosFromProjTime(take, startTime)
                local endPPQ = reaper.MIDI_GetPPQPosFromProjTime(take, endTime)

                for i = note_count - 1, 0, -1 do
                    local _, _, _, note_start_ppq, _, _, _, _ = reaper.MIDI_GetNote(take, i)
                    if note_start_ppq >= startPPQ and note_start_ppq < endPPQ then
                        reaper.MIDI_DeleteNote(take, i)
                        break -- Assuming only one note needs to be deleted within this range
                    end
                end
                reaper.MIDI_Sort(take)
                reaper.UpdateArrange()
                break -- Exit the loop once the MIDI item is processed
            end
        end
    end
end


local function undoPoint(text, track, item)
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    if not item then return end
    if not track then return end
    reaper.MarkTrackItemsDirty(track, item)
    reaper.Undo_EndBlock(text, -1)
    reaper.PreventUIRefresh(-1)
end

local function undoPoint2(text)
    local track = reaper.GetSelectedTrack(0, 0)
    if track then
        local item = reaper.GetTrackMediaItem(track, 0)
        reaper.PreventUIRefresh(1)
        reaper.Undo_BeginBlock()
        if not item then return end
        if not track then return end
        reaper.MarkTrackItemsDirty(track, item)
        reaper.Undo_EndBlock(text, -1)
        reaper.PreventUIRefresh(-1)
    end
end

---- STEP SEQUENCER ADDITIONAL FUNCTIONALITY  ---------------------------------


local function openMidiEditor(trackIndex, patternItems)
    -- reaper.Undo_BeginBlock()
    local track = reaper.GetTrack(0, trackIndex)
    if track then
        -- Get the selected pattern item based on the patternSelectSlider
        if not (patternItems and patternItems[patternSelectSlider] and patternItems[patternSelectSlider][1]) then
            return
        end
        local pattern_item = patternItems[patternSelectSlider][1]
        local pattern_start = reaper.GetMediaItemInfo_Value(pattern_item, "D_POSITION")
        local pattern_end = pattern_start + reaper.GetMediaItemInfo_Value(pattern_item, "D_LENGTH")
        reaper.SetOnlyTrackSelected(track)
        local item_count = reaper.CountTrackMediaItems(track)
        unselectAllMediaItems()
        for i = 0, item_count - 1 do
            local item = reaper.GetTrackMediaItem(track, i)
            local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            -- Check if the item falls within the pattern item range
            if item and item_start >= pattern_start and item_end <= pattern_end then
                reaper.SetMediaItemSelected(item, true) -- Select the media item
            end
        end
    end
    local track = reaper.GetTrack(0, trackIndex)
    if track then
        local item_count = reaper.CountTrackMediaItems(track)
        for i = 0, item_count - 1 do
            local item = reaper.GetTrackMediaItem(track, i)
            local take = reaper.GetMediaItemTake(item, 0) -- Get the active take of the media item
            if item and take and reaper.TakeIsMIDI(take) and reaper.IsMediaItemSelected(item) then
                reaper.Main_OnCommand(40153, 0)           -- Open in MIDI Editor
                break
            end
        end
    end
end

local function cloneDuplicateTrack(trackIndex)
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    reaper.Main_OnCommand(40062, 0) -- duplicate tracks
    local duplicated_tracks = {}
    local track_count = reaper.CountSelectedTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        table.insert(duplicated_tracks, track)
    end

    for k, v in pairs(duplicated_tracks) do
        local originalTrackIndex = reaper.GetMediaTrackInfo_Value(v, "IP_TRACKNUMBER") - 1

        -- Select the original track
        local originalTrack = reaper.GetTrack(0, originalTrackIndex)
        if not originalTrack then
            return
        end
        -- reaper.SetOnlyTrackSelected(originalTrack)

        enumerateTrack(v)


        -- Process the duplicated track
        local itemCount = reaper.CountTrackMediaItems(v)
        local pools = {}

        -- Identify the first item in each pool and collect other items
        for i = 0, itemCount - 1 do
            local item = reaper.GetTrackMediaItem(v, i)
            local take = reaper.GetActiveTake(item)
            if take and reaper.TakeIsMIDI(take) then
                _, chunk = reaper.GetItemStateChunk(item, "", false)
                local pooledGUID = chunk:match("POOLEDEVTS {(.-)}")
                if pooledGUID then
                    if not pools[pooledGUID] then
                        pools[pooledGUID] = { firstItem = item, otherItems = {} }
                    else
                        table.insert(pools[pooledGUID].otherItems, item)
                    end
                end
            end
        end

        -- Process each pool
        for pooledGUID, pool in pairs(pools) do
            local firstItem = pool.firstItem
            local otherItems = pool.otherItems
            local otherItemPositions = {}

            -- Get positions of other items
            for _, item in ipairs(otherItems) do
                local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                table.insert(otherItemPositions, itemStart)
            end

            -- Delete other items in the pool
            for _, item in ipairs(otherItems) do
                reaper.DeleteTrackMediaItem(v, item)
            end

            -- Unselect all items, then select and copy the first item
            reaper.SetOnlyTrackSelected(v)
            reaper.SelectAllMediaItems(0, false)
            reaper.SetMediaItemSelected(firstItem, true)
            reaper.Main_OnCommand(41613, 0) -- Item: Remove active take from MIDI source data pool (unpool)
            reaper.Main_OnCommand(40698, 0) -- Copy items

            -- Delete and paste items at original positions
            for _, pos in ipairs(otherItemPositions) do
                reaper.SetEditCurPos(pos, false, false)
                reaper.Main_OnCommand(41072, 0) -- Paste item pooled
            end

            reaper.SetMediaItemSelected(firstItem, false)
        end
    end
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
    reaper.Undo_EndBlock('Clone/Duplicate Track', -1)
end


local function deleteTrack(trackIndex, track_suffix)
    reaper.Undo_BeginBlock()

    local count_tracks = reaper.CountSelectedTracks(0)
    local total_tracks = reaper.CountTracks(0)
    local seq_track_count = 0
    local last_seq_track_index = -1

    for i = 0, total_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track, "")
    
        -- Check if the track name ends with "SEQ" and is not exactly "Patterns SEQ"
        if string.find(track_name, "SEQ" .. "$") and track_name ~= "Patterns SEQ" then
            seq_track_count = seq_track_count + 1
            last_seq_track_index = i
        end
    end

    -- Delete selected tracks but leave at least one SEQ track
    for i = count_tracks - 1, 0, -1 do
        local track = reaper.GetSelectedTrack(0, i)
        local _, track_name = reaper.GetTrackName(track, "")
        if track and (seq_track_count <= 1 and reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1 == last_seq_track_index) then

        else
            reaper.DeleteTrack(track)
            update_required = true
            -- Update SEQ track count if a SEQ track was deleted
            if string.find(track_name, "SEQ" .. "$") then
                seq_track_count = seq_track_count - 1
            end
        end
    end

    update_channel_data_from_reaper(track_suffix, total_tracks)
    reaper.Undo_EndBlock('Delete tracks', -1)
end

local function deleteAllMIDIFromChannel(trackIndex, patternSelectSlider, patternItems)
    local pattern_item, _, _, midi_item = getSelectedPatternItemAndMidiItem(trackIndex, patternItems, patternSelectSlider)
    if not midi_item then
        return
    end

    local take = reaper.GetMediaItemTake(midi_item, 0)
    if not reaper.ValidatePtr(take, "MediaItem_Take*") then
        reaper.ShowMessageBox("Failed to get MIDI take.", "Error", 0)
        return
    end

    if not reaper.TakeIsMIDI(take) then
        reaper.ShowMessageBox("The item is not a MIDI item.", "Error", 0)
        return
    end

    -- Get counts of each event type
    local note_count, cc_count, text_sysex_count = reaper.MIDI_CountEvts(take)

    -- Delete all notes
    for i = note_count - 1, 0, -1 do
        reaper.MIDI_DeleteNote(take, i)
    end

    -- Delete all CC events
    for i = cc_count - 1, 0, -1 do
        reaper.MIDI_DeleteCC(take, i)
    end

    -- Delete all Text/Sysex events
    for i = text_sysex_count - 1, 0, -1 do
        reaper.MIDI_DeleteTextSysexEvt(take, i)
    end

    reaper.UpdateArrange()
end

local function shiftNotes(direction, patternItems, patternSelectSlider)
    local selTrackCount = reaper.CountSelectedTracks(0)
    for ti = 0, selTrackCount - 1 do
        local track = reaper.GetSelectedTrack(0, ti)
        local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
        local pattern_item, pattern_start, pattern_end, midi_item = getSelectedPatternItemAndMidiItem(trackIndex,
            patternItems, patternSelectSlider)
        if not midi_item then
            return
        end

        local take = reaper.GetActiveTake(midi_item)
        if not reaper.ValidatePtr(take, "MediaItem_Take*") then
            reaper.ShowMessageBox("Failed to get MIDI take.", "Error", 0)
            return
        end

        local _, note_count = reaper.MIDI_CountEvts(take)
        local pattern_start_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, pattern_start)
        local step_size = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution -- Assuming a 16th note step size
        local step_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, pattern_start + step_size) - pattern_start_ppq
        local shift_ppq = direction * step_ppq

        -- Collect notes to shift
        local shiftedNotes = {}
        for i = 0, note_count - 1 do
            local _, _, _, start_ppq, end_ppq, _, pitch, vel = reaper.MIDI_GetNote(take, i)
            local new_start_ppq = start_ppq + shift_ppq
            local new_end_ppq = new_start_ppq + (end_ppq - start_ppq)

            if new_start_ppq < pattern_start_ppq then
                new_start_ppq = new_start_ppq + (pattern_end - pattern_start)
                new_end_ppq = new_end_ppq + (pattern_end - pattern_start)
            elseif new_start_ppq >= (pattern_start_ppq + (pattern_end - pattern_start)) then
                new_start_ppq = new_start_ppq - (pattern_end - pattern_start)
                new_end_ppq = new_end_ppq - (pattern_end - pattern_start)
            end

            table.insert(shiftedNotes, { new_start_ppq, new_end_ppq, pitch, vel })
        end

        -- Delete all existing notes and insert shifted notes
        reaper.MIDI_DisableSort(take)
        for i = note_count - 1, 0, -1 do
            reaper.MIDI_DeleteNote(take, i)
        end

        for _, note in ipairs(shiftedNotes) do
            local start_ppq, end_ppq, pitch, vel = table.unpack(note)
            reaper.MIDI_InsertNote(take, false, false, start_ppq, end_ppq, 0, pitch, vel, false)
        end

        reaper.MIDI_Sort(take)
    end
    reaper.UpdateArrange()
end

local function copyChannelData(trackIndex, patternSelectSlider, patternItems)
    local trackData = {}

    -- Get the selected pattern item and its start and end positions
    local pattern_item, pattern_start, pattern_end = getSelectedPatternItemAndMidiItem(trackIndex, patternItems,
        patternSelectSlider)
    if not pattern_item then
        reaper.ShowConsoleMsg("No pattern item selected.\n")
        return nil
    end

    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        reaper.ShowConsoleMsg("Track not found.\n")
        return nil
    end

    local itemCount = reaper.CountTrackMediaItems(track)
    if itemCount == 0 then
        -- reaper.ShowConsoleMsg("No items in track.\n")
        return trackData
    end

    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        -- Only process items within the selected pattern's time range
        if itemStart >= pattern_start and itemEnd <= pattern_end then
            local take = reaper.GetMediaItemTake(item, 0)
            if reaper.ValidatePtr(take, "MediaItem_Take*") and reaper.TakeIsMIDI(take) then
                local noteCount, _, _ = reaper.MIDI_CountEvts(take)
                for j = 0, noteCount - 1 do
                    local _, selected, _, startPPQ, endPPQ, channel, pitch, velocity = reaper.MIDI_GetNote(take, j)
                    local noteData = { startPPQ = startPPQ, endPPQ = endPPQ, channel = channel, pitch = pitch, velocity =
                    velocity }
                    table.insert(trackData, noteData)
                end
            end
        end
    end

    return trackData
end

local function pasteChannelDataToSelectedTracks(patternItems, patternSelectSlider)
    if #clipboard == 0 then
        reaper.ShowConsoleMsg("Clipboard is empty.\n")
        return
    end

    reaper.Undo_BeginBlock()
    local selTrackCount = reaper.CountSelectedTracks(0)

    if selTrackCount > 0 then
        local firstSelTrack = reaper.GetSelectedTrack(0, 0)
        local firstSelTrackIndex = reaper.GetMediaTrackInfo_Value(firstSelTrack, "IP_TRACKNUMBER") - 1
        local totalTracks = reaper.CountTracks(0)

        -- Calculate the number of tracks to process
        local numTracksToProcess = math.max(selTrackCount, #clipboard)

        -- Loop through and select tracks, then paste MIDI data
        for i = 0, numTracksToProcess - 1 do
            local targetTrackIndex = firstSelTrackIndex + i
            if targetTrackIndex < totalTracks then
                local track = reaper.GetTrack(0, targetTrackIndex)
                if track then
                    reaper.SetTrackSelected(track, true)

                    local clipboardIndex = (i % #clipboard) + 1
                    local noteDataList = clipboard[clipboardIndex]

                    -- Paste the MIDI data to each track
                    local pattern_item, pattern_start, pattern_end = getSelectedPatternItemAndMidiItem(targetTrackIndex,
                        patternItems, patternSelectSlider)
                    if pattern_item then
                        local item = findOrCreateMIDIItem(track, pattern_start, pattern_end)
                        local take = reaper.GetActiveTake(item)
                        if take and reaper.TakeIsMIDI(take) then
                            -- Clear existing notes
                            local _, noteCount, _ = reaper.MIDI_CountEvts(take)
                            for j = noteCount - 1, 0, -1 do
                                reaper.MIDI_DeleteNote(take, j)
                            end

                            -- Insert new notes
                            local itemStartPPQ = reaper.MIDI_GetPPQPosFromProjTime(take,
                                reaper.GetMediaItemInfo_Value(item, "D_POSITION"))
                            for _, noteData in ipairs(noteDataList) do
                                local relativeStartPPQ = noteData.startPPQ - itemStartPPQ
                                local relativeEndPPQ = noteData.endPPQ - itemStartPPQ
                                reaper.MIDI_InsertNote(
                                    take,
                                    false,
                                    false,
                                    relativeStartPPQ,
                                    relativeEndPPQ,
                                    noteData.channel,
                                    noteData.pitch,
                                    noteData.velocity
                                )
                            end
                            reaper.MarkTrackItemsDirty(track, item)
                            reaper.MIDI_Sort(take)
                        end
                    end
                end
            end
        end
    end

    reaper.Undo_EndBlock('Paste MIDI Notes', -1)
end


local function removeChannelData(trackIndex)
    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        return
    end

    local itemCount = reaper.CountTrackMediaItems(track)
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local take = reaper.GetMediaItemTake(item, 0)
        if reaper.ValidatePtr(take, "MediaItem_Take*") and reaper.TakeIsMIDI(take) then
            local noteCount, _, _ = reaper.MIDI_CountEvts(take)
            for j = noteCount - 1, 0, -1 do
                reaper.MIDI_DeleteNote(take, j)
            end
        end
    end
end

---- SLIDERS VELOCITY  ---------------------------------



local function OnMouseWheel(delta)
    -- Invert the direction of tension change
    tension = tension - delta * 1                  -- Adjust the scaling factor as needed
    tension = math.max(-10, math.min(tension, 10)) -- Clamp tension to prevent extreme curves
    return tension
end


local function applyCurveToValue(startValue, endValue, position, maxPosition, tension)
    local t = position / maxPosition
    local curveValue = startValue + (endValue - startValue) * t

    if tension ~= 0 then
        -- Reduce the exponent's impact by dividing tension, making the curve closer to linear
        local tensionAdjustment = tension / 3.14 -- Adjust this divisor to control the curve's linearity
        local factor = math.exp(tensionAdjustment * t)
        curveValue = startValue + (endValue - startValue) * ((factor - 1) / (math.exp(tensionAdjustment) - 1))
    end



    return curveValue
end



-- This is the obj_RectSlider function which takes an additional parameter "isNotePresent"
local function obj_RectSlider(ctx, cursor_x, cursor_y, width, height, value, drawList, x_padding, color, isNotePresent,
                              colorValues)
    local slider_left = cursor_x
    local slider_top = cursor_y
    local slider_right = slider_left + width
    local slider_bottom = slider_top + height

    -- Background rectangle
    reaper.ImGui_DrawList_AddRectFilled(drawList, slider_left + x_padding, slider_top, slider_right - x_padding,
        slider_bottom, color)
    -- Foreground rectangle - height changes based on value, but only if a note is present
    if value ~= nil then
        local slider_top_value = slider_top + (height - (value * height))
        reaper.ImGui_DrawList_AddRectFilled(drawList, slider_left + x_padding, slider_top_value - 1,
            slider_right - x_padding, slider_bottom, colorValues.color23_slider1)
    end
    -- Return values are used to handle interactions, which we'll leave unchanged as it's not part of the requirement
    return numColorsPushed, rv, slider_left, slider_top, slider_right, slider_bottom
end

local function updateMidiNoteVelocity(step_num, velocity, midi_item, midi_take, num_events, pattern_start, step_duration,
                                      tolerance, noteData)
    local note_position = pattern_start + (step_num - 1) * step_duration

    -- Use binary search algorithm to find the note event closest to the note_position within the tolerance range and update its velocity
    local function binarySearch(start, finish, note_position, tolerance)
        while start <= finish do
            local mid = math.floor((start + finish) / 2)
            local note_start_time = noteData[mid].note_start_time
            if math.abs(note_position - note_start_time) <= tolerance then
                return mid
            elseif note_start_time < note_position then
                start = mid + 1
            else
                finish = mid - 1
            end
        end
        return nil
    end

    local index = binarySearch(0, num_events - 1, note_position, tolerance)
    if index then
        -- Update the velocity of the note event
        reaper.MIDI_SetNote(midi_take, index, nil, nil, nil, nil, nil, nil, velocity, false, false)
    end

    -- Check if the MIDI take was modified before sorting
    if reaper.MIDI_GetHash(midi_take, false, "") ~= reaper.MIDI_GetHash(midi_take, true, "") then
        -- Update the MIDI take
        reaper.MIDI_Sort(midi_take)
    end
end


local function obj_VelocitySliders(ctx, trackIndex, note_positions, note_velocities,
                                   mouse, keys, numberOfSliders, sliderWidth, sliderHeight, x_padding, patternItems,
                                   patternSelectSlider, colorValues)
    if not trackIndex then return end
    local track = reaper.GetTrack(0, trackIndex)
    if not track or not reaper.IsTrackSelected(track) then return end
    local pattern_item, pattern_start, pattern_end, midi_item = getSelectedPatternItemAndMidiItem(trackIndex,
        patternItems, patternSelectSlider)
    if not midi_item then
        return false
    end
    local midi_take = reaper.GetMediaItemTake(midi_item, 0)
    if not midi_take then
        return false
    end
    local num_events, _, _, _ = reaper.MIDI_CountEvts(midi_take)
    if not num_events then
        return false
    end

    local noteData = {}
    local noteIndicesByPosition = {}
    for i = 0, num_events - 1 do
        local _, _, _, start_ppq, _, _, _, _ = reaper.MIDI_GetNote(midi_take, i)
        local note_start_time = reaper.MIDI_GetProjTimeFromPPQPos(midi_take, start_ppq)
        noteData[i] = { start_ppq = start_ppq, note_start_time = note_start_time }
        noteIndicesByPosition[note_start_time] = i
    end

    local step_duration = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution
    local tolerance = step_duration / 2
    -- local draw_list = reaper.ImGui_GetWindowDrawList(ctx)
    local cursor_x, cursor_y = reaper.ImGui_GetCursorScreenPos(ctx)
    local cursor_x = cursor_x + 230 * size_modifier
    local cursor_y = cursor_y
    local x_padding = x_padding * size_modifier
    local sliderWidth = sliderWidth * size_modifier
    local sliderHeight = sliderHeight * size_modifier
    local color1 = colorValues.color24_slider2
    local color2 = colorValues.color25_slider3

    local dragStartedOnAnySlider = false

    if mouse.isMouseDownL or mouse.isMouseDownR then
        for i = 0, lengthSlider - 1 do
            local sliderLeftX = cursor_x + (i * sliderWidth)
            local sliderRightX = sliderLeftX + sliderWidth
            local sliderTopY = cursor_y
            local sliderBottomY = cursor_y + sliderHeight

            if drag_start_x >= sliderLeftX and drag_start_x <= sliderRightX
                and drag_start_y >= sliderTopY and drag_start_y <= sliderBottomY then
                dragStartedOnAnySlider = true
                break
            end
        end
    end

    -- Left-click drag handling
    if mouse.isMouseDownL and dragStartedOnAnySlider then
        for i = 0, lengthSlider - 1 do
            local step_time = pattern_start + i * step_duration
            local slider = slider[i + 1]
            -- Check if a note is present at this step time using the preprocessed data
            local noteIndex = noteIndicesByPosition[step_time]
            local isNotePresent = noteIndex ~= nil

            if isNotePresent then
                -- Iterate through the path between the previous and current mouse positions
                for t = 0, 1, 0.01 do -- Adjust the step size (0.01) for smoother interpolation
                    local interpolated_x = previous_mouse_x + (mouse.mouse_x - previous_mouse_x) * t
                    local interpolated_y = previous_mouse_y + (mouse.mouse_y - previous_mouse_y) * t

                    local sliderLeftX = cursor_x + (i * sliderWidth)
                    local sliderRightX = sliderLeftX + sliderWidth

                    -- Check if the interpolated mouse position is over the slider
                    if interpolated_x >= sliderLeftX and interpolated_x <= sliderRightX then
                        local valueToApply
                        if keys.altDown then
                            valueToApply = 100 / 127 -- Reset to 100 velocity
                        else
                            valueToApply = 1 - (interpolated_y - cursor_y) / sliderHeight
                            valueToApply = math.max(0, math.min(valueToApply, 1)) -- Clamp the value
                        end

                        -- Update the slider's value and MIDI velocity if necessary
                        if slider.value ~= valueToApply then
                            slider.value = valueToApply
                            local new_velocity = math.max(1, math.floor(valueToApply * 127))
                            updateMidiNoteVelocity(i + 1, new_velocity, midi_item,
                                midi_take, num_events, pattern_start, step_duration, tolerance, noteData)
                        end
                        break -- Break the loop after updating to avoid redundant processing
                    end
                end
            end
        end
    end

    -- Right-click drag handling
    if mouse.isMouseDownR and dragStartedOnAnySlider then
        if not right_drag_start_x then
            right_drag_start_x = mouse.mouse_x
            right_drag_start_y = mouse.mouse_y
            right_drag_velocity = true
            for i = 0, numberOfSliders - 1 do
                local slider = slider[i + 1]
                slider.startValue = slider.value
                slider.startPos = cursor_x + (i * sliderWidth)
            end
        else
            local tension = OnMouseWheel(mouse.mousewheel_v)
            local drag_start_index = math.floor((right_drag_start_x - cursor_x) / sliderWidth)
            local drag_end_index = math.floor((mouse.mouse_x - cursor_x) / sliderWidth)
            local drag_min_index = math.min(drag_start_index, drag_end_index)
            local drag_max_index = math.max(drag_start_index, drag_end_index)
            local startYValue = 1 - (right_drag_start_y - cursor_y) / sliderHeight
            local currentYValue = 1 - (mouse.mouse_y - cursor_y) / sliderHeight

            for i = drag_min_index, drag_max_index do
                local slider = slider[i + 1]
                if slider then
                    local relativePos
                    if drag_start_index == drag_end_index then
                        -- If dragging started and ended on the same slider
                        relativePos = (mouse.mouse_x - right_drag_start_x) / sliderWidth
                    else
                        -- Normal calculation for relative position
                        relativePos = (slider.startPos - right_drag_start_x) / (mouse.mouse_x - right_drag_start_x)
                    end
                    relativePos = math.max(0, math.min(relativePos, 1)) -- Clamp the value

                    local curveValue = applyCurveToValue(startYValue, currentYValue, relativePos, 1, tension)
                    slider.value = math.max(0, math.min(curveValue, 1))
                    -- Update MIDI note velocity based on the slider's new value
                    local new_velocity = math.max(1, math.floor(slider.value * 127))
                    local step_num = i + 1
                    updateMidiNoteVelocity(i + 1, new_velocity, midi_item,
                        midi_take, num_events, pattern_start, step_duration, tolerance, noteData)
                end
            end
        end
    end



    -- Sliders
    for i = 0, lengthSlider - 1 do
        local step_time = pattern_start + i * step_duration
        local slider_cursor_x = cursor_x + (i * sliderWidth)
        local slider_value = nil -- Default to no value
        local isNotePresent = false
        -- Check for the presence of a note at this step and set slider_value if found
        for idx, note_pos in ipairs(note_positions) do
            if math.abs(note_pos - step_time) <= tolerance then
                slider_value = note_velocities[idx] / 127
                isNotePresent = true
                break
            end
        end

        -- Display the slider
        local color = (math.floor(i / 4) % 2 == 0) and color1 or color2
        local numColorsPushed, rv, slider_left, slider_top, slider_right, slider_bottom = obj_RectSlider(
            ctx, slider_cursor_x, cursor_y, sliderWidth, sliderHeight, slider_value, drawList, x_padding, color,
            isNotePresent, colorValues)
    end


    --Dummy Spacer
    reaper.ImGui_Dummy(ctx, 0, sliderHeight)

    -- Reset states on mouse release
    if mouse.mouseReleasedR then
        right_drag_start_x, right_drag_start_y = nil, nil
        -- tension = 0
    end

    -- Update the previous mouse position for interpolation
    previous_mouse_x, previous_mouse_y = mouse.mouse_x, mouse.mouse_y
end

---- RS5K  ---------------------------------


local function cycleRS5kSample(track, fxIndex, direction)
    local ret, currentFile = reaper.TrackFX_GetNamedConfigParm(track, fxIndex, "FILE0")

    if not ret or currentFile == "" then
        return
    end

    local dirPath, currentFileName = currentFile:match("^(.-)([^/\\]+)$")

    if not dirPath or not currentFileName then
        return
    end

    local files = {}
    local i = 0
    while true do
        local fileName = reaper.EnumerateFiles(dirPath, i)
        if not fileName then
            break
        end
        table.insert(files, fileName)
        i = i + 1
    end

    table.sort(files)

    local currentIndex
    for i, fileName in ipairs(files) do
        if fileName == currentFileName then
            currentIndex = i
            break
        end
    end

    local newIndex
    if direction == "previous" then
        newIndex = currentIndex - 1
        if newIndex < 1 then
            newIndex = #files
        end
    elseif direction == "next" then
        newIndex = currentIndex + 1
        if newIndex > #files then
            newIndex = 1
        end
    elseif direction == "random" then
        newIndex = math.random(#files)
        while newIndex == currentIndex do
            newIndex = math.random(#files)
        end
    else
        return
    end

    local newFileName = files[newIndex]
    if not newFileName then
        return
    end

    local newFilePath = dirPath .. newFileName

    reaper.TrackFX_SetNamedConfigParm(track, fxIndex, "FILE0", newFilePath)
    reaper.TrackFX_SetNamedConfigParm(track, fxIndex, "DONE", "")
end

local function last_tr_in_folder(folder_tr)
    local last = nil
    local dep = reaper.GetTrackDepth(folder_tr)
    local num = reaper.GetMediaTrackInfo_Value(folder_tr, "IP_TRACKNUMBER")
    local tracks = reaper.CountTracks(0)
    for i = num + 1, tracks do
        if reaper.GetTrackDepth(reaper.GetTrack(0, i - 1)) <= dep then
            last = reaper.GetTrack(0, i - 2)
            break
        end
    end
    if last == nil then
        last = reaper.GetTrack(0, tracks - 1)
    end
    return last
end

local function insertNewTrack(filename, track_suffix, track_count)
    -- Find the index of the last "Patterns SEQ" track
    local track_count = reaper.CountTracks(0)
    local last_patterns_seq_index = -1
    local folder_depth = 0
    local num_tracks = reaper.CountTracks(0)
    local insert_track_index = -1

    for track_index = 0, num_tracks - 1 do
        local track = reaper.GetTrack(0, track_index)
        local _, track_name = reaper.GetTrackName(track)
        local current_folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

        if track_name == "Patterns SEQ" then
            last_patterns_seq_index = track_index
            folder_depth = current_folder_depth
            -- Find the last track in the folder
            last_track = last_tr_in_folder(track)
            insert_track_index = reaper.GetMediaTrackInfo_Value(last_track, "IP_TRACKNUMBER")
            last_track_depth = reaper.GetMediaTrackInfo_Value(last_track, "I_FOLDERDEPTH")
            break
        end
    end

    if insert_track_index >= 0 then
        --reaper.Main_OnCommand(40001,0)
        reaper.InsertTrackAtIndex(insert_track_index, false)
        reaper.TrackList_AdjustWindows(false)
        local new_track = reaper.GetTrack(0, insert_track_index)
        -- Ensure the new track is inside the folder and not a folder itself
        reaper.SetMediaTrackInfo_Value(last_track, "I_FOLDERDEPTH", 0)
        reaper.SetMediaTrackInfo_Value(new_track, "I_FOLDERDEPTH", -1)

        if new_track then
            -- Extract the name from the path and remove the .wav file extension
            local trackName = filename:match("^.+[\\/](.+)$")
            trackName = trackName:gsub("%.wav$", "")
            -- Set the track name
            reaper.GetSetMediaTrackInfo_String(new_track, "P_NAME", trackName .. track_suffix, true)
            reaper.GetSetTrackGroupMembership(new_track, 'MEDIA_EDIT_FOLLOW', 1, 1)
            -- Enumerate the track to ensure uniqueness
            enumerateTrack(new_track)
            -- Add Trigger Note instance to the new track
            local note_trigger = reaper.TrackFX_AddByName(new_track, "Note Trigger", false, -1)
            -- Add Swing instance to the new track
            local fx_swing = reaper.TrackFX_AddByName(new_track, "Swing", false, -1)
            -- Add MIDI Offset Shift instance to the new track
            --local fx_offsetshift = reaper.TrackFX_AddByName(new_track, "MIDI Offset Shift", false, -1)
            -- Add RS5k instance to the new track
            local rs5k_index = reaper.TrackFX_AddByName(new_track, "ReaSamplomatic5000", false, -1)

            -- Close the RS5k window immediately after opening
            reaper.TrackFX_Show(new_track, rs5k_index, 2)
            reaper.TrackFX_Show(new_track, fx_swing, 2)
            --reaper.TrackFX_Show(new_track, fx_offsetshift, 2)

            -- Load the dropped file into RS5k
            reaper.TrackFX_SetNamedConfigParm(new_track, rs5k_index, "FILE0", filename)
            reaper.TrackFX_SetNamedConfigParm(new_track, rs5k_index, "DONE", "")
            -- Update channel data
            update_channel_data_from_reaper(track_suffix)
        else
            -- Handle track creation error
            reaper.ShowMessageBox("Failed to create a new track.", "Error", 0)
        end
    end
end

---- SLIDERS OFFSET  ---------------------------------

local function obj_OffsetSliders(ctx, trackIndex, note_positions)
    if not trackIndex then
        return
    end
    local track = reaper.GetTrack(0, trackIndex)
    if not track or not reaper.IsTrackSelected(track) then
        return
    end
    local pattern_item, pattern_start, pattern_end, midi_item = getSelectedPatternItemAndMidiItem(trackIndex)
    if not pattern_item then
        return
    end

    local step_duration = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution

    -- Get the current cursor position (top-left corner of the rectangle)
    local cursor_x, cursor_y = reaper.ImGui_GetCursorScreenPos(ctx)
    local frame_right = cursor_x + obj_x * lengthSlider
    local frame_bottom = cursor_y + obj_y * 4

    local draw_list = reaper.ImGui_GetWindowDrawList(ctx)
    local border_color = 0xFFFFFFFF
    local border_thickness = 1
    reaper.ImGui_DrawList_AddRect(draw_list, cursor_x - 1, cursor_y - 1, frame_right + 1, frame_bottom + 1, border_color,
        0, 0, border_thickness)

    local step_duration = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution
    local tolerance = step_duration / 2
    for i = 1, lengthSlider do
        local step_time = pattern_start + (i - 1) * step_duration

        -- Find the note closest to the current grid position within the tolerance range
        local closest_distance = math.huge
        local distance = 0
        for idx, note_pos in ipairs(note_positions) do
            local dist = note_pos - step_time
            if math.abs(dist) < closest_distance and math.abs(dist) <= tolerance then
                closest_distance = math.abs(dist)
                distance = dist * 1000     -- Convert to milliseconds
            end
        end


        reaper.ImGui_PushID(ctx, i)

        local rv, new_distance = obj_MiddleSlider("##distance", obj_x, obj_y * 4, distance, -50, 50, 0)

        if rv and distance ~= new_distance then
            updateMidiNoteOffset(trackIndex, i, new_distance / 1000, patternSelectSlider)
        end
        reaper.ImGui_SameLine(ctx, 0, 0)
        cursor_x = cursor_x + obj_x
        reaper.ImGui_PopID(ctx)
    end
end

local function obj_MiddleSlider(id, width, height, value, min, max, default_value)
    local border_thickness = 1       -- Set the desired border thickness
    local border_color = frame_color -- Set the desired border color (same as frame color in this case)

    --[[ Set style variables and color options
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), border_thickness) -- Set border thickness
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBg(), frame_color)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgHovered(), frame_color)          -- Use the same color as FrameBg
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgActive(), frame_color)           -- Use the same color as FrameBg
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_SliderGrab(), color_invisible)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_SliderGrabActive(), color_invisible)    -- Use the same color as SliderGrab
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), border_color)                 -- Set border color
    --]]
    local normalized_value = (value - min) / (max - min)
    local normalized_min, normalized_max = 0, 1

    -- Use ImGui's vertical slider function to create the slider
    local retval
    retval, normalized_value = reaper.ImGui_VSliderDouble(ctx, id, width, height, normalized_value, normalized_min,
        normalized_max)
    local changed = retval -- The return value indicates if the slider value has changed

    value = min + normalized_value * (max - min)

    -- Reset the slider value on double-click
    if reaper.ImGui_IsItemClicked(ctx, 2) then
        value = default_value
        changed = true
    end

    -- Pop style variables and color options
    --reaper.ImGui_PopStyleVar(ctx, 1)   -- Pop border thickness style variable
    --reaper.ImGui_PopStyleColor(ctx, 6) -- Pop all colors

    return changed, value
end

local function updateMidiNoteOffset(trackIndex, step_num, distance, patternSelectSlider)
    -- Get the MIDI take associated with the track and pattern
    local pattern_item, pattern_start, pattern_end, midi_item = getSelectedPatternItemAndMidiItem(trackIndex,
        patternSelectSlider)
    if not midi_item then
        return false
    end

    -- Get the MIDI take from the MIDI item
    local midi_take = reaper.GetMediaItemTake(midi_item, 0)

    -- Calculate the step duration
    local step_duration = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution
    -- Calculate the time position of the grid based on step_num
    local grid_position = pattern_start + (step_num - 1) * step_duration

    -- Calculate the new position of the note based on distance (offset from the grid)
    local new_note_position = grid_position + distance

    -- Define a tolerance value (in seconds) for considering notes close to the grid
    local tolerance = step_duration / 2

    -- Find the note event closest to the grid_position within the tolerance range and update its position
    local event_count = reaper.MIDI_CountEvts(midi_take)
    for i = 0, event_count - 1 do
        local ret, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(midi_take, i)
        if ret then
            local start_time = reaper.MIDI_GetProjTimeFromPPQPos(midi_take, startppq)
            local end_time = reaper.MIDI_GetProjTimeFromPPQPos(midi_take, endppq)
            local note_length = end_time - start_time
            if math.abs(grid_position - start_time) <= tolerance then
                local new_start_ppq = reaper.MIDI_GetPPQPosFromProjTime(midi_take, new_note_position)
                local new_end_ppq = reaper.MIDI_GetPPQPosFromProjTime(midi_take, new_note_position + note_length)
                reaper.MIDI_SetNote(midi_take, i, nil, nil, new_start_ppq, new_end_ppq, nil, nil, nil, true)
                break
            end
        end
    end

    -- Update the MIDI take
    reaper.MIDI_Sort(midi_take)
    reaper.UpdateItemInProject(midi_item)
end

---- OBJECTS  ---------------------------------

local function popup(ctx, track_count)
    local confirmed

    if showPopup then
        local win_x, win_y = reaper.ImGui_GetWindowPos(ctx)
        local win_w, win_h = reaper.ImGui_GetWindowSize(ctx)
        local center_x = win_x + win_w / 2
        local center_y = win_y + win_h / 2
        reaper.ImGui_SetNextWindowPos(ctx, center_x, center_y, reaper.ImGui_Cond_Appearing(), 0.5, 0.5)
        reaper.ImGui_OpenPopup(ctx, "Delete tracks")
    end


    if reaper.ImGui_BeginPopupModal(ctx, "Delete tracks", nil, reaper.ImGui_WindowFlags_AlwaysAutoResize()) then
        reaper.ImGui_Text(ctx, 'Delete ' .. track_count .. ' tracks?')
        if reaper.ImGui_Button(ctx, 'OK', 120, 0) then
            confirmed = true
            reaper.ImGui_CloseCurrentPopup(ctx)
            showPopup = false
        end

        reaper.ImGui_SameLine(ctx)

        -- Cancel button logic
        if reaper.ImGui_Button(ctx, 'Cancel', 120, 0) then
            confirmed = false
            reaper.ImGui_CloseCurrentPopup(ctx)
            showPopup = false
        end

        reaper.ImGui_EndPopup(ctx)
        return confirmed
    end
end

-- right click menu
local function obj_Channel_Button_Menu(ctx, trackIndex, contextMenuID, patternItems, track_count)
    -- Menu items
    if reaper.ImGui_MenuItem(ctx, "Open MIDI Editor") then
        -- Action for Opening MIDI Editor
        openMidiEditor(trackIndex, patternItems)
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end
    -- Add separator
    reaper.ImGui_Separator(ctx)
    if reaper.ImGui_MenuItem(ctx, "Clone (Duplicate)") then
        -- Action for Duplicating Track
        unselectNonSuffixedTracks()
        cloneDuplicateTrack(trackIndex)
        update_required = true
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end
    if reaper.ImGui_MenuItem(ctx, "Delete") then
        unselectNonSuffixedTracks()
        -- Action for Deleting Track
        deleteTrack(trackIndex)
        -- showPopup = true  -- Set the flag to open the popup
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end



    reaper.ImGui_Separator(ctx)
    -- Fill every 2 steps
    if reaper.ImGui_MenuItem(ctx, "Fill every 2 steps") then
        -- reaper.Undo_BeginBlock()
        deleteAllMIDIFromChannel(trackIndex, patternSelectSlider, patternItems) -- Clear the MIDI channel

        for i = 1, lengthSlider do
            if i % 2 == 1 then
                insertMidiNote(trackIndex, i, 60, 100, 0.125, patternSelectSlider, nil, nil, track_count) -- Insert a note on every other step
            end
        end
        undoPoint2('Fill every 2 steps', track, item)
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu

        --  reaper.Undo_EndBlock('Fill every 2 steps' ,-1)
    end
    -- Fill every 4 steps
    if reaper.ImGui_MenuItem(ctx, "Fill every 4 steps") then
        deleteAllMIDIFromChannel(trackIndex, patternSelectSlider, patternItems) -- Clear the MIDI channel
        for i = 1, lengthSlider do
            if i % 4 == 1 then
                insertMidiNote(trackIndex, i, 60, 100, 0.125, patternSelectSlider, nil, nil, track_count) -- Insert a note on every other step
            end
        end
        undoPoint2('Fill every 4 steps', track, item)
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end
    -- Fill every 8 steps
    if reaper.ImGui_MenuItem(ctx, "Fill every 8 steps") then
        deleteAllMIDIFromChannel(trackIndex, patternSelectSlider, patternItems) -- Clear the MIDI channel
        for i = 1, lengthSlider do
            if i % 8 == 1 then
                insertMidiNote(trackIndex, i, 60, 100, 0.125, patternSelectSlider, nil, nil, track_count) -- Insert a note on every other step
            end
        end
        undoPoint2('Fill every 8 steps', track, item)
        reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
    end

    -- Intercept key presses
    if reaper.ImGui_IsWindowFocused(ctx) then
        local is_key_c_pressed = reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_C())
        local is_key_d_pressed = reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_D())
        if is_key_c_pressed then
            -- Run Clone (Duplicate) action
            unselectNonSuffixedTracks()
            cloneDuplicateTrack(trackIndex)
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        elseif is_key_d_pressed then
            -- Run Delete action
            unselectNonSuffixedTracks()
            deleteTrack(trackIndex)
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
    end


    reaper.ImGui_EndPopup(ctx)
    -- end
end

local function obj_Channel_Button(ctx, buttonIndex, mouse, patternItems, track_count, colorValues)
    local trackIndex = channel.GUID.trackIndex[buttonIndex]
    if not trackIndex then
        return
    end

    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        return
    end

    local buttonName = shorten_name(channel.GUID.name[buttonIndex] or " ", track_suffix) .. "##" .. tostring(trackIndex)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), colorValues.color35_channelbutton_frame)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 1)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), colorValues.color34_channelbutton_active)

    -- Check if the current button is active
    if selectedChannelButton == trackIndex then
        -- Set the background color as active color if the button is active
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorValues.color34_channelbutton_active)
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color34_channelbutton_active)
    else
        -- Set the background color as regular color if the button is not active
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color32_channelbutton)
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorValues.color32_channelbutton)
    end

    local rv_chan_button = reaper.ImGui_Button(ctx, buttonName, 95 * size_modifier, obj_y)

    if reaper.ImGui_IsItemHovered(ctx) then
        hoveredControlInfo.id = 'Channel Button'
    end

    if active_lane == nil then
        if reaper.ImGui_IsItemClicked(ctx, 0) then
            unselectAllTracks()
            reaper.SetTrackSelected(track, true)
        end
    end

    local contextMenuID = "ChannelButtonContextMenu" .. tostring(buttonIndex)

    if reaper.ImGui_IsItemHovered(ctx) and reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.SetTrackSelected(track, true)
        reaper.ImGui_OpenPopup(ctx, contextMenuID)
    end

    if reaper.ImGui_BeginPopup(ctx, contextMenuID, reaper.ImGui_WindowFlags_NoMove()) then
        obj_Channel_Button_Menu(ctx, trackIndex, contextMenuID, patternItems, track_count)
    end

    -- if shiftDown and active_lane == nil and reaper.ImGui_BeginPopupContextItem(ctx, contextMenuID, reaper.ImGui_MouseButton_Right()) and not reaper.ImGui_IsMouseDragging(ctx, 1)  then
    --     reaper.SetTrackSelected(track, true)
    --     obj_Channel_Button_Menu(ctx, trackIndex, contextMenuID)

    --     else if active_lane == nil and reaper.ImGui_BeginPopupContextItem(ctx, contextMenuID, reaper.ImGui_MouseButton_Right()) then
    --         unselectAllTracks()
    --         reaper.SetTrackSelected(track, true)
    --         obj_Channel_Button_Menu(ctx, trackIndex, contextMenuID)
    --     end
    -- end

    local buttonXMin, buttonYMin = reaper.ImGui_GetItemRectMin(ctx)
    local buttonXMax, buttonYMax = reaper.ImGui_GetItemRectMax(ctx)
    buttonCoordinates[buttonIndex] = { minY = buttonYMin, maxY = buttonYMax }
    local function dragChannel()
        -- -- Start drag source for channel button
        -- if reaper.ImGui_BeginDragDropSource(ctx) then
        --     -- reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_DragDropTarget(), color33_channelbutton_dropped)
        --     -- Set payload to identify which button is being dragged
        --     local payloadValue = tostring(buttonIndex)
        --     reaper.ImGui_SetDragDropPayload(ctx, "CHANNEL_BUTTON_DRAG", payloadValue)
        --     reaper.ImGui_Text(ctx, buttonName) -- Display the button name as a preview while dragging
        --     reaper.ImGui_PopStyleColor(ctx, 1)
        --     -- reaper.ImGui_EndDragDropSource(ctx)
        -- end

        -- -- In the function where you handle the drag and drop
        -- if reaper.ImGui_BeginDragDropTarget(ctx) then
        --     local payloadType, payloadValue = reaper.ImGui_AcceptDragDropPayload(ctx, "CHANNEL_BUTTON_DRAG")
        --     local draw_list = reaper.ImGui_GetWindowDrawList(ctx)
        --     local lineColor = 0xFFFFFFFF -- White color for the line
        --     local lineHeight = 2 -- Thickness of the line
        --     local lineOffset = 3 -- Offset from the button edge
        --     local mousePosX, mousePosY = reaper.ImGui_GetMousePos(ctx)

        --     -- Iterate through the stored button coordinates
        --     for index, coords in pairs(buttonCoordinates) do
        --         if mousePosY >= coords.minY and mousePosY <= coords.maxY then
        --             local buttonMidY = (coords.minY + coords.maxY) / 2
        --             local lineYPosition = mousePosY < buttonMidY and coords.minY - lineOffset or coords.maxY + lineOffset

        --             -- Draw the line above or below the hovered button
        --             reaper.ImGui_DrawList_AddLine(
        --                 draw_list,
        --                 buttonXMin,
        --                 lineYPosition,
        --                 buttonXMax,
        --                 lineYPosition,
        --                 lineColor,
        --                 lineHeight
        --             )
        --             break -- Exit the loop as we found the hovered button
        --         end
        --     end

        --     if payloadType then
        --     -- Your existing drag and drop handling logic
        --     end

        --     reaper.ImGui_EndDragDropTarget(ctx)
    end

    if rv_chan_button then
        selectedChannelButton = trackIndex
    end

    --find last channel button edge
    local cursorPosX, cursorPosY = reaper.ImGui_GetCursorPos(ctx)
    -- local buttonHeight = obj_y -- Assuming obj_y is the height of the button
    local buttonBottomY = cursorPosY + obj_y

    -- Check if this button is the last one and update the global variable
    if buttonIndex == #channel.GUID.trackIndex then -- Assuming this is the last index
        lastButtonBottomY = buttonBottomY
    end

    reaper.ImGui_PopStyleColor(ctx, 4)
    reaper.ImGui_PopStyleVar(ctx, 1)

    if active_lane and mouse.isMouseDownR then
        local dragged = true
    end

    if reaper.ImGui_BeginDragDropTarget(ctx) then
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_DragDropTarget(), colorValues.color33_channelbutton_dropped)
        local rv, count = reaper.ImGui_AcceptDragDropPayloadFiles(ctx)
        if rv then
            for i = 0, count - 1 do
                local filename
                rv, filename = reaper.ImGui_GetDragDropPayloadFile(ctx, i)

                -- Extract the name from the path and remove the .wav file extension
                local buttonName = filename:match("^.+[\\/](.+)$")
                buttonName = buttonName:gsub("%.wav$", "")

                -- Save the cleaned-up buttonName and file path to channel
                channel.GUID.name[buttonIndex] = buttonName
                channel.GUID.file_path[buttonIndex] = filename

                -- Save the updated channel data
                save_channel_data()

                -- Set the track name
                local track = reaper.GetTrack(0, trackIndex)
                if track then
                    local newName = buttonName
                    local index = 2
                    while track_name_exists(newName) do
                        newName = buttonName .. "_" .. tostring(index) .. track_suf1fix
                        index = index + 1
                    end
                    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", newName .. track_suffix, true)
                    -- Check for existing RS5K instance on the track
                    local rs5k_index = -1
                    for fx_index = 0, reaper.TrackFX_GetCount(track) - 1 do
                        local _, fx_name = reaper.TrackFX_GetFXName(track, fx_index, "")
                        if fx_name:sub(-6) == "(RS5K)" then
                            rs5k_index = fx_index
                            break
                        end
                    end

                    -- If RS5K is not found, add it without showing the UI
                    if rs5k_index == -1 then
                        rs5k_index = reaper.TrackFX_AddByName(track, "ReaSamplomatic5000", false, -2)
                        reaper.TrackFX_Show(track, rs5k_index, 2) -- Close the window immediately after opening
                    end

                    -- set velocity min to 0
                    reaper.TrackFX_SetParamNormalized(track, rs5k_index, 2, 0)

                    -- Load the dropped file into RS5K without floating the FX window
                    reaper.TrackFX_SetNamedConfigParm(track, rs5k_index, "FILE0", filename)

                    -- Load the dropped file into RS5K by passing it the file path
                    if rs5k_index >= 0 then
                        reaper.TrackFX_SetNamedConfigParm(track, rs5k_index, "FILE0", filename)
                        reaper.TrackFX_SetNamedConfigParm(track, rs5k_index, "DONE", "")
                    end
                end
            end
        end

        reaper.ImGui_PopStyleColor(ctx, 1)
        reaper.ImGui_EndDragDropTarget(ctx)
    end
end

local function obj_Slider(ctx, label, currentValue, minValue, maxValue, colorSliderGrab, colorSliderGrabActive,
                          colorFrameBg, colorFrameBgHovered, colorFrameBgActive, width, framePaddingX, framePaddingY,
                          mouse, numberKeys, colorValues)
    -- Apply frame padding
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FramePadding(), framePaddingX, framePaddingY)

    -- Apply colors
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_SliderGrab(), colorSliderGrab)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_SliderGrabActive(), colorSliderGrabActive)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBg(), colorFrameBg)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgHovered(), colorFrameBgHovered)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_FrameBgActive(), colorFrameBgActive)

    -- Set item width
    reaper.ImGui_PushItemWidth(ctx, width)

    -- Create the slider
    local changed, newValue = reaper.ImGui_SliderInt(ctx, label, currentValue, minValue, maxValue)

    -- Mouse wheel adjustment
    if reaper.ImGui_IsItemHovered(ctx) and mouse.mousewheel_v then
        local potentialNewValue = newValue + mouse.mousewheel_v
        newValue = math.min(math.max(potentialNewValue, minValue), maxValue)
        changed = true
    end

    -- Pop style colors and style var
    reaper.ImGui_PopStyleColor(ctx, 5)
    reaper.ImGui_PopStyleVar(ctx, 1)

    -- Pop item width
    reaper.ImGui_PopItemWidth(ctx)

    return changed, newValue
end

local function obj_Pattern_Controller(patternItems, ctx, mouse, keys, colorValues)
    -- Determine the maximum pattern number among all retrieved pattern items.
    local maxPatternNumber = 0;
    for patternNumber, _ in pairs(patternItems) do
        maxPatternNumber = math.max(maxPatternNumber, patternNumber);
    end;

    -- Get the last selected pattern number from REAPER's extended state or default to 1.
    local lastSelectedPattern = tonumber(reaper.GetExtState("PatternController", "lastSelectedPattern")) or 1;
    -- Use the last selected pattern number to initialize the pattern selection slider, if not already set.
    patternSelectSlider = patternSelectSlider or 1;

    -- Prepare and retrieve snapping settings from REAPER's extended state.
    local extStateSection = "PatternControllerSnapSettings";
    local snapToEnabled = toboolean(reaper.GetExtState(extStateSection, "snapToEnabled")) or false;
    local snapAmount = tonumber(reaper.GetExtState(extStateSection, "snapAmount")) or 1;

    -- Retrieve and set the last length slider step from the extended state, defaulting to 1.
    local lastLengthSliderStep = tonumber(reaper.GetExtState("PatternController", "lastLengthSliderStep")) or 1;
    local lengthSliderStep = lengthSliderStep or lastLengthSliderStep;
    reaper.ImGui_SetCursorPosX(ctx, 0)
    reaper.ImGui_SetCursorPosY(ctx, 4 * size_modifier)
    reaper.ImGui_Text(ctx, 'Pattern:')
    reaper.ImGui_SameLine(ctx)

    rvp, patternSelectSlider = obj_Slider(ctx, "##Pattern Select", patternSelectSlider, 1, maxPatternNumber,
        colorValues.color32_channelbutton, colorValues.color59_button_solo_inactive,
        colorValues.color34_channelbutton_active, colorValues.color34_channelbutton_active,
        colorValues.color34_channelbutton_active,
        120 * size_modifier, 0, 4 * size_modifier, mouse, keys)

    if reaper.ImGui_IsItemHovered(ctx) then
        hoveredControlInfo.id = 'Selected Pattern'
    end

    if reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, "patternSelectMenu")
    end

    if reaper.ImGui_BeginPopup(ctx, "patternSelectMenu", reaper.ImGui_WindowFlags_NoMove()) then
        for i = 1, (maxPatternNumber + 1) - 1 do
            if reaper.ImGui_MenuItem(ctx, i) then
                patternSelectSlider = i
            end
        end
        reaper.ImGui_EndPopup(ctx)
    end

    if rvp then reaper.SetExtState("PatternController", "lastSelectedPattern", tostring(patternSelectSlider), true); end

    local selectedItem;
    local selectedItemStartPos = nil

    local patternSelected = false;
    -- If the selected pattern number has associated items, process the first item to set the length slider.
    if patternItems[patternSelectSlider] then
        for _, item in ipairs(patternItems[patternSelectSlider]) do
            selectedItem = item;
            if item ~= nil then
                local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
                local patternStartPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                selectedItemStartPos = selectedItemStartPos or patternStartPos
                local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1);
                -- Calculate the length slider value based on item length.
                lengthSlider = math.floor(itemLength / beatsInSec * time_resolution);
                patternSelected = true;
            end
        end;
    end;

    local numSteps = math.floor(16 * 4 / snapAmount);

    reaper.ImGui_SameLine(ctx)
    reaper.ImGui_Text(ctx, 'Length:')
    reaper.ImGui_SameLine(ctx)
    rvpl, lengthSlider = obj_Slider(ctx, "##Pattern Length", lengthSlider, 1, 64,
        colorValues.color32_channelbutton, colorValues.color59_button_solo_inactive,
        colorValues.color34_channelbutton_active, colorValues.color34_channelbutton_active,
        colorValues.color34_channelbutton_active,
        200 * size_modifier, 1, 4 * size_modifier, mouse, keys, colorValues)

    if rvpl then reaper.SetExtState("PatternController", "lastLengthSliderStep", tostring(lengthSliderStep), true); end

    if reaper.ImGui_IsItemHovered(ctx) then
        hoveredControlInfo.id = 'Pattern Length'
    end

    local showPopupMenu = false

    if reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, "patternLengthMenu")
    end

    if reaper.ImGui_BeginPopup(ctx, "patternLengthMenu", reaper.ImGui_WindowFlags_NoMove()) then
        if reaper.ImGui_MenuItem(ctx, "8") then
            lengthSlider = 8
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
        if reaper.ImGui_MenuItem(ctx, "16") then
            lengthSlider = 16
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
        if reaper.ImGui_MenuItem(ctx, "32") then
            lengthSlider = 32
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
        if reaper.ImGui_MenuItem(ctx, "64") then
            lengthSlider = 64
            reaper.ImGui_CloseCurrentPopup(ctx) -- Close the context menu
        end
        reaper.ImGui_EndPopup(ctx)
    end

    if not patternItems[patternSelectSlider] then
        local lastPatternNumber = nil
        for patternNumber, _ in pairs(patternItems) do
            if not lastPatternNumber or patternNumber > lastPatternNumber then
                lastPatternNumber = patternNumber
            end
        end
        patternSelectSlider = lastPatternNumber or 1
    end

    -- If a pattern is selected and the length slider has changed, update the length of pattern items.
    if patternSelected and prevLengthSlider ~= lengthSlider then
        local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1)
        local newLength = beatsInSec * (lengthSlider / time_resolution)
        local trackCount = reaper.CountTracks(0)
        local patternsSeqTrackName = "Patterns SEQ" -- Replace with the actual name of your "Patterns SEQ" track

        -- Process each selected pattern item
        for _, patternItem in ipairs(patternItems[patternSelectSlider]) do
            local patternItemStart = reaper.GetMediaItemInfo_Value(patternItem, "D_POSITION")
            local patternItemEnd = patternItemStart + reaper.GetMediaItemInfo_Value(patternItem, "D_LENGTH")

            for trackIdx = 0, trackCount - 1 do
                local track = reaper.GetTrack(0, trackIdx)
                local itemCount = reaper.CountTrackMediaItems(track)

                for itemIdx = 0, itemCount - 1 do
                    local item = reaper.GetTrackMediaItem(track, itemIdx)
                    local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

                    -- Check if item is within the range of the pattern item
                    if itemStart >= patternItemStart and itemStart < patternItemEnd then
                        reaper.SetMediaItemInfo_Value(item, "D_LENGTH", newLength)
                    end
                end
            end
        end

        reaper.UpdateArrange()
    end

    -- Store the current length slider value for future comparisons.
    prevLengthSlider = lengthSlider;
    return selectedItemStartPos, maxPatternNumber
end

local function obj_Control_Sidebar(ctx, keys, colorValues, mouse)
    if selectedChannelButton == 0 then
        reaper.ImGui_Text(ctx, "No channel selected.")
        selectedChannelButton = 1
        return
    end
    local trackIndex = selectedChannelButton
    if trackIndex == nil then
        reaper.ImGui_Text(ctx, "Track index is invalid.")
        return
    end
    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        return
    end
    local fxCount = reaper.TrackFX_GetCount(track)
    for fxIndex = 0, fxCount - 1 do
        reaper.ImGui_Dummy(ctx, 1 * size_modifier, 0)

        local _, fxName = reaper.TrackFX_GetFXName(track, fxIndex, "")
        if fxName:find("ReaSamplOmatic5000") or fxName:find("%(RS5K%)") then
            local ret, sampleName = reaper.TrackFX_GetNamedConfigParm(track, fxIndex, "FILE0")
            local fileName = sampleName:match("^.+[\\/](.+)$") or ""

            -- reaper.ImGui_PushFont(ctx, font_SidebarSampleTitle)
            if ret and fileName ~= "" then
                reaper.ImGui_Text(ctx, fileName)
            else
                reaper.ImGui_Text(ctx, "No sample loaded.")
            end
            -- reaper.ImGui_PopFont(ctx)

            reaper.ImGui_Dummy(ctx, 1 * size_modifier, 1 * size_modifier)
            reaper.ImGui_Separator(ctx)
            reaper.ImGui_Dummy(ctx, 1 * size_modifier, 1 * size_modifier)


            -- Create "Previous Sample" button
            if obj_Button(ctx, "Prev", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 33 * size_modifier, 33 * size_modifier, "Previous Sample") then
                cycleRS5kSample(track, fxIndex, "previous")
            end
            reaper.ImGui_SameLine(ctx) -- Place the next button on the same line

            -- Create "Next Sample" button
            if obj_Button(ctx, "Next", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 33 * size_modifier, 33 * size_modifier, "Next Sample") then
                cycleRS5kSample(track, fxIndex, "next")
            end

            reaper.ImGui_SameLine(ctx) -- Place the next button on the same line

            -- Create "Random Sample" button
            if obj_Button(ctx, "Rnd", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 33 * size_modifier, 33 * size_modifier, "Random Sample") then
                cycleRS5kSample(track, fxIndex, "random")
            end

            reaper.ImGui_SameLine(ctx) -- Place the next button on the same line

            -- Create "Choose Sample" button
            if obj_Button(ctx, "Pick", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 33 * size_modifier, 33 * size_modifier, "Pick Sample") then
                local ret, chosenFile = reaper.GetUserFileNameForRead("", "Select Sample", "")
                if ret then
                    reaper.TrackFX_SetNamedConfigParm(track, fxIndex, "FILE0", chosenFile)
                end
            end

            reaper.ImGui_SameLine(ctx) -- Place the next button on the same line

            -- Create "Float RS5K Instance" button
            if obj_Button(ctx, "Float", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 33 * size_modifier, 33 * size_modifier, "Float RS5K Instance") then
                reaper.TrackFX_Show(track, fxIndex, 3) -- 3: float the window
            end
            -- reaper.ImGui_PopFont(ctx)

            reaper.ImGui_Dummy(ctx, 0, 5 * size_modifier)

            -- Volume knob
            local valueVolume = reaper.GetMediaTrackInfo_Value(track, "D_VOL") -- Get track volume
            local rv, newVolume = obj_VolKnob(ctx, 'Vol', obj_y / 2.5, valueVolume, 0, 3, 1, nil, 1, .1,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, false, 0, keys, mouse)

            if rv then
                reaper.SetMediaTrackInfo_Value(track, "D_VOL", newVolume) -- Set track volume
            end

            reaper.ImGui_SameLine(ctx, 40 * size_modifier)

            -- Pan knob
            local valuePan = reaper.GetMediaTrackInfo_Value(track, "D_PAN") -- Get track pan
            local _, newPan = obj_Knob(ctx, 'Pan', obj_y / 2.5, valuePan, -1, 1, 0, nil, .1, .01,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, false, 0, keys)

            reaper.SetMediaTrackInfo_Value(track, "D_PAN", newPan) -- Set track pan


            reaper.ImGui_SameLine(ctx, 80 * size_modifier)

            -- Create Boost knob
            valueBoost, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 0)
            _, valueBoost = obj_Knob(ctx, "Boost", obj_y / 2.5, valueBoost, 1, 4, 1, nil, .1, .001,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, false, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 0, valueBoost)
            end

            reaper.ImGui_SameLine(ctx, 120 * size_modifier)

            -- Create Start knob
            valueStart, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 13)
            _, valueStart = obj_Knob_Exp(ctx, "Start", obj_y / 2.5, valueStart, 0, 1, 0, nil, .1, .001,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, 0.3, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 13, valueStart)
            end

            reaper.ImGui_SameLine(ctx, 160 * size_modifier)

            -- Create End knob
            valueEnd, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 14)
            _, valueEnd = obj_Knob(ctx, "End", obj_y / 2.5, valueEnd, 0, 1, 1, nil, .1, .001,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, false, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 14, valueEnd)
            end

            reaper.ImGui_Dummy(ctx, 0, 15 * size_modifier)

            reaper.ImGui_Separator(ctx)

            reaper.ImGui_Dummy(ctx, 0, 7 * size_modifier)

            -- Create Pitch knob (with snap)
            valueSnap, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 15)
            _, valueSnap = obj_Knob(ctx, "Pitch", obj_y / 2.5, valueSnap, .2, .8, .5, 1 / 160, .25, .0033,
                colorValues.color44_knob_sidebar_circle, colorValues.color45_knob_sidebar_line,
                colorValues.color44_knob_sidebar_circle, true, 1, .1, true, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            reaper.ImGui_SameLine(ctx, 40 * size_modifier)

            -- Display the actual value of the parameter within RS5K as text (if valid)
            local retval, actualValue = reaper.TrackFX_GetFormattedParamValue(track, fxIndex, 15, "")
            if retval then
                local yOffset = obj_y - 3 -- Adjust this value to align the text vertically
                reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
                reaper.ImGui_Text(ctx, actualValue)
            end

            reaper.ImGui_SameLine(ctx, 36 * size_modifier)

            -- Define button width and spacing
            local buttonWidth = 29
            local buttonSpacing = 4

            -- Define vertical offset value
            local yOffset = 1

            -- Set initial horizontal position for buttons
            local xOffsetButtons = reaper.ImGui_GetCursorPosX(ctx)

            -- Pitch -12
            reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
            -- reaper.ImGui_PushFont(ctx, font_SidebarButtons)

            if obj_Button(ctx, "-12", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, buttonWidth * size_modifier, 25 * size_modifier, "Pitch -12 semitones") then
                valueSnap = valueSnap - (12 / 160)
                valueSnap = math.max(valueSnap, .2) -- Ensure the value does not go below min limit
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- Pitch -1
            reaper.ImGui_SameLine(ctx, xOffsetButtons + (buttonWidth + buttonSpacing) * size_modifier)
            reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
            if obj_Button(ctx, "-1", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, buttonWidth * size_modifier, 25 * size_modifier, "Pitch -1 semitone") then
                valueSnap = valueSnap - (1 / 160)
                valueSnap = math.max(valueSnap, .2) -- Ensure the value does not go below min limit
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- Pitch RANDOM
            reaper.ImGui_SameLine(ctx, xOffsetButtons + (2 * buttonWidth + 2 * buttonSpacing) * size_modifier)
            reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
            if obj_Button(ctx, "Rnd##Pitch", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, buttonWidth * size_modifier, 25 * size_modifier, "Pitch random, right click for greater range") then
                -- Generate a random value within the range [0.2, 0.8]
                valueSnap = 0.480 + math.random() * 0.03
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- greater randomization on right click
            if reaper.ImGui_IsItemClicked(ctx, 1) then
                valueSnap = 0.4 + math.random() * 0.2
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- Pitch +1
            reaper.ImGui_SameLine(ctx, xOffsetButtons + (3 * buttonWidth + 3 * buttonSpacing) * size_modifier)
            reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
            if obj_Button(ctx, "+1", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, buttonWidth * size_modifier, 25 * size_modifier, "Pitch +1 semitone") then
                valueSnap = valueSnap + (1 / 160)
                valueSnap = math.min(valueSnap, .8) -- Ensure the value does not exceed max limit
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- Pitch +12
            reaper.ImGui_SameLine(ctx, xOffsetButtons + (4 * buttonWidth + 4 * buttonSpacing) * size_modifier)
            reaper.ImGui_SetCursorPosY(ctx, reaper.ImGui_GetCursorPosY(ctx) + yOffset)
            if obj_Button(ctx, "+12", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, buttonWidth * size_modifier, 25 * size_modifier, "Pitch +12 semitones") then
                valueSnap = valueSnap + (12 / 160)
                valueSnap = math.min(valueSnap, .8) -- Ensure the value does not exceed max limit
                reaper.TrackFX_SetParam(track, fxIndex, 15, valueSnap)
            end

            -- reaper.ImGui_PopFont(ctx)
            reaper.ImGui_Dummy(ctx, 0, 5 * size_modifier)
            reaper.ImGui_Separator(ctx)

            reaper.ImGui_Dummy(ctx, 0, 7 * size_modifier)

            -- Attack knob
            valueAttack, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 9)
            _, valueAttack = obj_Knob_Exp(ctx, "Att", obj_y / 2.5, valueAttack, 0, 1, 0, nil, .025, .01,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, .1, 0.3, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 9, valueAttack)
            end

            reaper.ImGui_SameLine(ctx, 40 * size_modifier)

            -- Decay knob
            valueDecay, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 24)
            _, valueDecay = obj_Knob_Exp(ctx, "Dec", obj_y / 2.5, valueDecay, 0, 1, .35, nil, .025, .01,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, .1, 0.27, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 24, valueDecay)
            end

            reaper.ImGui_SameLine(ctx, 80 * size_modifier)
            -- Sustain knob
            valueSustain, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 25)
            _, valueSustain = obj_Knob(ctx, "Sus", obj_y / 2.5, valueSustain, 0, 1, 1, nil, 2, 1,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, .1, false, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 25, valueSustain)
            end

            reaper.ImGui_SameLine(ctx, 120 * size_modifier)

            -- Release knob
            valueRelease, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 10)
            _, valueRelease = obj_Knob_Exp(ctx, "Rel", obj_y / 2.5, valueRelease, 0, 1, 0.006, nil, .025, .01,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, .1, 0.618, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 10, valueRelease)
            end

            reaper.ImGui_SameLine(ctx, 153 * size_modifier)
            -- reaper.ImGui_PushFont(ctx, font_SidebarButtons)

            -- Note Off Button
            local noteOffValue, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 11)
            -- Determine the color based on the value
            local buttonColor = (noteOffValue == 1) and colorValues.color61_button_sidebar_active or
                colorValues.color62_button_sidebar_inactive
            if obj_Button(ctx, "N-Off", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 44 * size_modifier, 28 * size_modifier, "Obey note-off") then
                --reaper.TrackFX_SetParam(track, fxIndex, 11, value)
                noteOffValue = 1 - noteOffValue
                -- Update the "Note Off" parameter with the new value
                reaper.TrackFX_SetParam(track, fxIndex, 11, noteOffValue)
            end

            reaper.ImGui_Dummy(ctx, 0, 20 * size_modifier)
        end
    end

    reaper.ImGui_Separator(ctx)
    reaper.ImGui_Dummy(ctx, 0, 7 * size_modifier)

    for fxIndex = 0, fxCount - 1 do
        local _, fxName = reaper.TrackFX_GetFXName(track, fxIndex, "")
        if fxName:find("Swing") then
            -- Offset knob
            valueOffset, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 16)
            _, valueOffset = obj_Knob(ctx, "Offs", obj_y / 2.5, valueOffset, 0, 50, 0, .5, .5, .5,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, 1, false, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 16, valueOffset)
            end

            -- Swing knob
            reaper.ImGui_SameLine(ctx, 40 * size_modifier)
            valueSwing, _, _ = reaper.TrackFX_GetParam(track, fxIndex, 1)
            _, valueSwing = obj_Knob(ctx, "Swing", obj_y / 2.5, valueSwing, 0, 50, 0, .5, .5, .5,
                colorValues.color42_knob_env_circle, colorValues.color43_knob_env_line,
                colorValues.color42_knob_env_circle, true, 1, .1, false, 0, keys)
            if reaper.ImGui_IsItemActive(ctx) or mouse.mousewheel_v ~= 0 then
                reaper.TrackFX_SetParam(track, fxIndex, 1, valueSwing)
            end
        end
    end
    reaper.ImGui_Dummy(ctx, 0, 330 * size_modifier)
    -- reaper.ImGui_PopFont(ctx)
end

local function obj_PlayCursor_Buttons(ctx, mouse, keys, patternSelectSlider, colorValues)
    local track = parent.GUID[0]

    if not track or not reaper.ValidatePtr(track, "MediaTrack*") then
        return nil
    end

    local itemsByPattern = getItemsByPattern()

    local currentPatternItems = itemsByPattern[patternSelectSlider]
    if not currentPatternItems or #currentPatternItems == 0 then
        return
    end

    local selectedItem
    local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution
    local cursorPosition = reaper.GetPlayState() & 1 == 1 and reaper.GetPlayPosition() or reaper.GetCursorPosition()

    for _, item in ipairs(currentPatternItems) do
        local itemPosition = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if cursorPosition >= itemPosition and cursorPosition < itemPosition + itemLength then
            selectedItem = item
            break
        end
    end
    selectedItem = selectedItem or currentPatternItems[1]

    local selectedItemPosition = reaper.GetMediaItemInfo_Value(selectedItem, "D_POSITION")
    local itemLength = reaper.GetMediaItemInfo_Value(selectedItem, "D_LENGTH")
    local lengthSlider = math.floor(itemLength / beatsInSec)
    local relativeCursorPosition = cursorPosition - selectedItemPosition
    local currentBeat = math.floor(relativeCursorPosition / beatsInSec) + 1

    local styleColors = {
        reaper.ImGui_Col_Border(),
        reaper.ImGui_Col_Button(),
        reaper.ImGui_Col_ButtonHovered(),
        reaper.ImGui_Col_ButtonActive()
    }
    local colorValues2 = { colorValues.color12_playcursor_frame, colorValues.color11_playcursor_bg, colorValues
        .color14_playcursor_hovered, colorValues.color13_playcursor_active }

    for i = 1, lengthSlider do
        reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 1)
        reaper.ImGui_PushID(ctx, i)

        for j = 1, #styleColors do
            reaper.ImGui_PushStyleColor(ctx, styleColors[j], colorValues2[j])
        end

        local isActiveBeat = currentBeat == i
        if isActiveBeat then
            reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color13_playcursor_active)
        end

        local rv = reaper.ImGui_Button(ctx, " ", obj_x, obj_y)

        if isActiveBeat then
            reaper.ImGui_PopStyleColor(ctx)
        end

        reaper.ImGui_PopStyleColor(ctx, 4)

        if rv then
            if keys.ctrlDown then
                reaper.GetSet_LoopTimeRange(1, 1, selectedItemPosition, selectedItemPosition + itemLength, 0)
            elseif active_lane == nil then
                local newCursorPosition = selectedItemPosition + (beatsInSec * (i - 1))
                reaper.SetEditCurPos(newCursorPosition, true, true)
            end
        end

        reaper.ImGui_PopID(ctx)
        reaper.ImGui_PopStyleVar(ctx)
        if i ~= lengthSlider then
            reaper.ImGui_SameLine(ctx, 0, 0)
        end
    end
end

local function findOrCreateMidiItem(track, note_position, item_start, item_length_secs)
    local itemCount = reaper.CountTrackMediaItems(track)
    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

        if itemPos <= note_position and note_position < (itemPos + itemLength) then
            return item
        end
    end

    return reaper.CreateNewMIDIItemInProj(track, item_start, item_start + item_length_secs, false)
end

local function sequencer_Drag(mouse, keys, button_left, button_top, button_right, button_bottom, trackIndex, i, buttonId,
                              midi_item, patternItems)
    if mouse.drag_start_x and mouse.drag_start_y then
        local drag_area_left = math.min(mouse.drag_start_x, mouse.mouse_x)
        local drag_area_right = math.max(mouse.drag_start_x, mouse.mouse_x)
        local intersectL = rectsIntersect(drag_area_left, drag_start_y, drag_area_right, mouse.mouse_y, button_left,
            button_top, button_right, button_bottom)

        local track = reaper.GetTrack(0, trackIndex)
        local item_start = reaper.GetMediaItemInfo_Value(patternItems[patternSelectSlider][1], "D_POSITION")
        local beatsInSec = reaper.TimeMap2_beatsToTime(0, 1)
        local item_length_secs = lengthSlider * beatsInSec / time_resolution

        -- Calculate BPM and 1/16 note length outside of the loops
        local bpm = reaper.TimeMap_GetDividedBpmAtTime(item_start)
        local beat_length_secs = 60 / bpm
        local sixteenth_note_length_secs = beat_length_secs / 8

        if trackIndex == active_lane then
            -- Process left-click events
            if mouse.isMouseDownL and intersectL then
                if not processedButtons[buttonId] then -- If button is not processed, insert note
                    local note_position = item_start + (i - 1) * beatsInSec / time_resolution
                    local midi_item = findOrCreateMidiItem(track, note_position, item_start, item_length_secs)

                    if midi_item then
                        local take = reaper.GetMediaItemTake(midi_item, 0)
                        if take and reaper.ValidatePtr(take, "MediaItem_Take*") and reaper.TakeIsMIDI(take) then
                            local note_ppq_position = reaper.MIDI_GetPPQPosFromProjTime(take, note_position)
                            local note_end_time = note_position + sixteenth_note_length_secs
                            local note_end_ppq_position = reaper.MIDI_GetPPQPosFromProjTime(take, note_end_time)

                            reaper.MIDI_InsertNote(take, false, false, note_ppq_position, note_end_ppq_position, 0, 60,
                                100, false)
                            processedButtons[buttonId] = true -- Mark button as processed
                        end
                    end
                end
            end

            -- Process right-click events
            if mouse.isMouseDownR and intersectL then
                deleteMidiNote(trackIndex, i, patternSelectSlider, patternItems)
                processedButtons[buttonId] = nil -- Reset button state on right-click
            end
        end
    end

    -- Handle mouse release events
    if (mouse.mouseReleasedL or mouse.mouseReleasedR) and active_lane ~= nil then
        if mouse.mouseReleasedL then
            insertMidiPooledItems(active_lane, patternSelectSlider, patternItems)
        end
        if mouse.mouseReleasedR then
            local track = reaper.GetTrack(0, active_lane)
            undoPoint('Delete MIDI Notes', track, midi_item)
        end
        selectOnlyTrack(active_lane)
        active_lane = nil
        processedButtons = {} -- Reset the processed buttons on mouse release
    end
end

local function obj_Sequencer_Buttons(ctx, trackIndex, mouse, keys, pattern_item,
                                     pattern_start, pattern_end, midi_item, note_positions, note_velocities, patternItems,
                                     colorValues)
    if not (trackIndex and pattern_item and reaper.GetTrack(0, trackIndex)) then
        return note_positions, note_velocities
    end

    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 5)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameRounding(), 5.0)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), colorValues.color1_bg)

    local step_duration = reaper.TimeMap2_beatsToTime(0, 1) / time_resolution
    local adjusted_step_duration = step_duration * 0.49
    local step_start_points = {}

    for i = 1, lengthSlider do
        step_start_points[i] = pattern_start + (i - 1) * step_duration
    end

    local isDarkerBlock, colorBlue, colorDarkBlue, step_start, step_end, colorButton

    for i = 1, lengthSlider do
        reaper.ImGui_SameLine(ctx, 0, 0)

        buttonStates[trackIndex][i] = false
        step_start = step_start_points[i]
        step_end = step_start + step_duration

        for _, pos in ipairs(note_positions) do
            if pos >= (step_start - adjusted_step_duration) and pos < (step_end - adjusted_step_duration) then
                buttonStates[trackIndex][i] = true
                break
            end
        end

        isDarkerBlock = ((i - 1) // time_resolution) % 2 == 0
        colorBlue = isDarkerBlock and colorValues.color18_Steps_odd_off or colorValues.color16_Steps_even_off
        colorDarkBlue = isDarkerBlock and colorValues.color19_Steps_odd_on or colorValues.color17_Steps_even_on
        colorButton = buttonStates[trackIndex][i] and colorDarkBlue or colorBlue

        reaper.ImGui_PushID(ctx, i)
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorButton)
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorButton)
        reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), colorDarkBlue)

        local rv = reaper.ImGui_Button(ctx, " ", obj_x, obj_y)
        reaper.ImGui_PopStyleColor(ctx, 3)
        reaper.ImGui_PopID(ctx)

        if reaper.ImGui_IsItemHovered(ctx) and (reaper.ImGui_IsMouseClicked(ctx, 0) or reaper.ImGui_IsMouseClicked(ctx, 1)) then
            active_lane = trackIndex
        end

        local button_left, button_top = reaper.ImGui_GetItemRectMin(ctx)
        local button_right, button_bottom = reaper.ImGui_GetItemRectMax(ctx)
        sequencer_Drag(mouse, keys, button_left, button_top, button_right, button_bottom, trackIndex, i,
            trackIndex .. '_' .. i, midi_item, patternItems)
    end

    reaper.ImGui_PopStyleColor(ctx, 1)
    reaper.ImGui_PopStyleVar(ctx, 2)
    return note_positions, note_velocities
end

local function obj_muteButton(ctx, id, value, trackIndex, color_active, color_inactive, color_border, border_size,
                              button_width, button_height)
    local track = reaper.GetTrack(0, trackIndex)
    if not track then return value end
    local is_active = (value == 1)
    local rv = obj_Button(ctx, id, is_active, color_active, color_inactive, color_border, border_size, button_width,
        button_height)
    if rv then
        value = is_active and 0 or 1 -- Toggle value between 0 and 1
        reaper.SetMediaTrackInfo_Value(track, "B_MUTE", value)
    end
    return value
end

local function obj_soloButton(ctx, id, value, trackIndex, color_active, color_inactive, color_border, border_size,
                              button_width, button_height)
    local track = reaper.GetTrack(0, trackIndex)
    if not track then return value end
    local is_active = (value ~= 0)
    local rv = obj_Button(ctx, id, is_active, color_active, color_inactive, color_border, border_size, button_width,
        button_height)
    if rv then
        value = is_active and 0 or 2 -- Toggle value between 0 and 2
        reaper.SetMediaTrackInfo_Value(track, "I_SOLO", value)
    end
    return value
end

local function obj_Add_Channel_Button(track_suffix, ctx, count_tracks, colorValues)
    -- reaper.ImGui_Dummy(ctx, 0,0)
    reaper.ImGui_SameLine(ctx, 116 * size_modifier)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), colorValues.color35_channelbutton_frame)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 1)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), colorValues.color34_channelbutton_active)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color32_channelbutton)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorValues.color34_channelbutton_active)
    local rv2 = reaper.ImGui_Button(ctx, '+', 95 * size_modifier, 25 * size_modifier)
    reaper.ImGui_PopStyleColor(ctx, 4)
    reaper.ImGui_PopStyleVar(ctx, 1)

    if rv2 then
        local numSelectedTracks = reaper.CountSelectedTracks(0)
        if numSelectedTracks > 0 then
            for i = 0, numSelectedTracks - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                local _, track_name = reaper.GetTrackName(track)
                if not string.find(track_name, track_suffix .. "$") then
                    -- Append the suffix if it's not already there
                    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", track_name .. track_suffix, true)
                end
            end
        else
            -- reaper.ShowMessageBox("Please select at least one track to add the suffix.", "Track Not Selected", 0)
        end
    end



    if reaper.ImGui_BeginDragDropTarget(ctx) then
        local rv, count = reaper.ImGui_AcceptDragDropPayloadFiles(ctx)
        if rv then
            for i = 0, count - 1 do
                local filename
                rv, filename = reaper.ImGui_GetDragDropPayloadFile(ctx, i)
                insertNewTrack(filename, track_suffix, count_tracks)
            end
        end
        reaper.ImGui_EndDragDropTarget(ctx)
    end

    if reaper.ImGui_IsItemHovered(ctx) or reaper.ImGui_IsItemActive(ctx) then
        hoveredControlInfo.id = "Click to add selected track to McSequencer, or drag wav files here"
    end
end

local function obj_Invisible_Channel_Button(track_suffix, ctx, count_tracks, colorValues)
    -- reaper.ImGui_Dummy(ctx, 0,0)
    -- reaper.ImGui_SameLine(ctx)
    local x, y = reaper.ImGui_GetWindowContentRegionMax(ctx)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), colorValues.color35_channelbutton_frame)
    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 1)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), colorValues.color34_channelbutton_active)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color32_channelbutton)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorValues.color34_channelbutton_active)
    if reaper.ImGui_InvisibleButton(ctx, '##AreaBelowControls', x, 1000 * size_modifier) then
    end
    reaper.ImGui_PopStyleColor(ctx, 4)
    reaper.ImGui_PopStyleVar(ctx, 1)
    -- reaper.ImGui_SameLine(ctx, -1)

    -- if reaper.ImGui_InvisibleButton(ctx, '##AreaBelowControls', window_width, window_height) then
    --     --nothing
    -- end

    if reaper.ImGui_BeginDragDropTarget(ctx) then
        local rv, count = reaper.ImGui_AcceptDragDropPayloadFiles(ctx)
        if rv then
            for i = 0, count - 1 do
                local filename
                rv, filename = reaper.ImGui_GetDragDropPayloadFile(ctx, i)
                insertNewTrack(filename, track_suffix, count_tracks)
            end
        end
        reaper.ImGui_EndDragDropTarget(ctx)
    end
end

local function obj_Selector(ctx, trackIndex, width, height, color, border_size, border_color, roundness, mouse, keys)
    local track = reaper.GetTrack(0, trackIndex)
    if not track then
        return
    end

    -- Initial button state based on track selection
    local isSelected = reaper.IsTrackSelected(track)

    local button_size_offset = 5
    local border_size_offset = 4
    -- local draw_list = reaper.ImGui_GetWindowDrawList(ctx)

    -- Get cursor position
    local cursor_x, cursor_y = reaper.ImGui_GetCursorScreenPos(ctx)

    -- Calculate the positions of the button
    local button_left = cursor_x
    local button_top = cursor_y
    local button_right = button_left + width
    local button_bottom = button_top + height

    -- Draw the selected background if the track is selected
    if isSelected then
        reaper.ImGui_DrawList_AddRectFilled(drawList, button_left + border_size_offset, button_top + border_size_offset,
            button_right - border_size_offset, button_bottom - border_size_offset, border_color, roundness)
    end

    -- Draw the button background
    reaper.ImGui_DrawList_AddRectFilled(drawList, button_left + button_size_offset, button_top + button_size_offset,
        button_right - button_size_offset, button_bottom - button_size_offset, color, roundness)

    -- Audio indicator rectangle
    local audioPeakL = reaper.Track_GetPeakInfo(track, 0)
    local audioPeakR = reaper.Track_GetPeakInfo(track, 1)
    local audioPeak = math.max(audioPeakL, audioPeakR)

    local audioThreshold = 0.01 -- Threshold for detecting audio signal
    if audioPeak > audioThreshold then
        local scaleFactor = .6
        local minAlpha = 0.1
        local audioIndicatorAlpha = math.min(1.0, minAlpha + (1 - minAlpha) * (audioPeak ^ scaleFactor))

        local audioIndicatorColor = reaper.ImGui_ColorConvertDouble4ToU32(0.6, 0.99, 0.0, audioIndicatorAlpha)
        reaper.ImGui_DrawList_AddRectFilled(drawList, button_left + button_size_offset + 2,
            button_top + button_size_offset + 2, button_right - button_size_offset - 2,
            button_bottom - button_size_offset - 2, audioIndicatorColor, roundness)
    end

    -- Invisible button for interaction
    pressed = reaper.ImGui_InvisibleButton(ctx, '##Selector' .. tostring(trackIndex), width, height)

    if active_lane == nil then
        if (keys.shiftDown or keys.ctrlDown) and reaper.ImGui_IsItemClicked(ctx, 0) then
            --
        elseif reaper.ImGui_IsItemClicked(ctx, 0) then
            unselectAllTracks()
            reaper.SetTrackSelected(track, true)
        end

        if reaper.ImGui_IsItemClicked(ctx, 0) and reaper.ImGui_IsMouseDoubleClicked(ctx, 0) then
            toggleSelectTracksEndingWithSEQ()
        end

        if mouse.isMouseDownL and mouse.mouse_x >= button_left and mouse.mouse_x <= button_right and mouse.mouse_y >= button_top and mouse.mouse_y <= button_bottom then
            reaper.SetTrackSelected(track, true)
        elseif mouse.isMouseDownR and mouse.mouse_x >= button_left and mouse.mouse_x <= button_right and mouse.mouse_y >= button_top and mouse.mouse_y <= button_bottom then
            reaper.SetTrackSelected(track, false)
        end
    end
end

local function obj_New_Pattern(ctx, patternItems, colorValues, maxPatternNumber, track_count)
    if obj_Button(ctx, "New Pattern", false, colorValues.color34_channelbutton_active, colorValues.color32_channelbutton, colorValues.color35_channelbutton_frame, 1, 99 * size_modifier, 22 * size_modifier) then
        newPatternItem(maxPatternNumber)
    end

    if reaper.ImGui_IsItemClicked(ctx, 1) then
        reaper.ImGui_OpenPopup(ctx, 'New Pattern')
    end

    if reaper.ImGui_BeginPopup(ctx, 'New Pattern', reaper.ImGui_WindowFlags_NoMove()) then
        if reaper.ImGui_MenuItem(ctx, "Duplicate all to new pattern") then
            reaper.PreventUIRefresh(1)
            unselectAllTracks()
            toggleSelectTracksEndingWithSEQ()
            local selTrackCount = reaper.CountSelectedTracks(0)
            clipboard = {}
            for i = 0, selTrackCount - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
                table.insert(clipboard, copyChannelData(trackIndex, patternSelectSlider, patternItems))
            end
            newPatternItem(maxPatternNumber)
            local patternItems, patternTrackIndex, patternTrack = getPatternItems(track_count)
            pasteChannelDataToSelectedTracks(patternItems, patternSelectSlider)
            unselectAllTracks()
            reaper.PreventUIRefresh(-1)

            reaper.ImGui_CloseCurrentPopup(ctx)     -- Close the context menu
        end

        if reaper.ImGui_MenuItem(ctx, "Duplicate selected to new pattern") then
            reaper.PreventUIRefresh(1)
            unselectNonSuffixedTracks()
            local selTrackCount = reaper.CountSelectedTracks(0)
            clipboard = {}
            for i = 0, selTrackCount - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
                table.insert(clipboard, copyChannelData(trackIndex, patternSelectSlider, patternItems))
            end
            newPatternItem(maxPatternNumber)
            local patternItems, patternTrackIndex, patternTrack = getPatternItems(track_count)
            pasteChannelDataToSelectedTracks(patternItems, patternSelectSlider)
            reaper.PreventUIRefresh(-1)

            reaper.ImGui_CloseCurrentPopup(ctx)     -- Close the context menu
        end

        if reaper.ImGui_MenuItem(ctx, "Make selected pattern item unique") then
            reaper.PreventUIRefresh(1)
            reaper.Undo_BeginBlock()

            local selectedItem = reaper.GetSelectedMediaItem(0, 0)
            if selectedItem then
                local take = reaper.GetActiveTake(selectedItem)
                if take then
                    local _, currentName = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
                    if string.match(currentName, "Pattern %d+") then
                        local newPatternName = "Pattern " .. (maxPatternNumber + 1)
                        reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", newPatternName, true)
                    end
                end
            end
            patternSelectSlider = maxPatternNumber + 1

            reaper.Undo_EndBlock("Rename selected pattern", -1)
            reaper.UpdateArrange()
            reaper.PreventUIRefresh(-1)
        end

        reaper.ImGui_EndPopup(ctx)
    end

    --
end

----- TIME SIGNATURE -----

local function findTempoMarkerFromPosition(position)
    local numTempoMarkers = reaper.CountTempoTimeSigMarkers(0)

    local prevMarkerIndex = -1
    local prevMarkerTime = -1
    local prevTimesigNum = nil
    local prevTimesigDenom = nil

    for i = 0, numTempoMarkers - 1 do
        local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo = reaper
        .GetTempoTimeSigMarker(0, i)
        if timepos <= position then
            prevMarkerIndex = i
            prevMarkerTime = timepos
            prevTimesigNum = timesig_num
            prevTimesigDenom = timesig_denom
        else
            break
        end
    end

    if prevMarkerIndex == -1 then
        return nil, "No previous tempo marker found."
    else
        return prevMarkerIndex, prevMarkerTime, prevTimesigNum, prevTimesigDenom
    end
end

---- MOUSE & KEYBAORD MANAGEMENT  ---------------------------------

local function mouseTrack(ctx)
    local mousewheel_v, mousewheel_h = reaper.ImGui_GetMouseWheel(ctx)
    local mouse_x, mouse_y = reaper.ImGui_GetMousePos(ctx)
    local isMouseDownL = reaper.ImGui_IsMouseDown(ctx, 0)
    local isMouseDownR = reaper.ImGui_IsMouseDown(ctx, 1)
    local mouseReleasedL = false
    local mouseReleasedR = false


    -- Handle drag start
    if isMouseDownL or isMouseDownR then
        if not drag_start_x and not drag_start_y then
            drag_start_x = mouse_x
            drag_start_y = mouse_y
            drag_started = true
        end
    else
        -- Handle drag end
        if drag_started then
            drag_started = false
            -- Add any additional code you want to run when the drag ends
        end
        drag_start_x = nil
        drag_start_y = nil
    end

    -- Check if the left mouse was previously down and now it's up
    if wasMouseDownL and not isMouseDownL then
        mouseReleasedL = true
    end

    -- Check if the right mouse was previously down and now it's up
    if wasMouseDownR and not isMouseDownR then
        mouseReleasedR = true
    end

    -- Update the 'wasMouseDown' variables at the end of the function
    wasMouseDownL = isMouseDownL
    wasMouseDownR = isMouseDownR

    return {
        mouse_x = mouse_x,
        mouse_y = mouse_y,
        isMouseDownL = isMouseDownL,
        isMouseDownR = isMouseDownR,
        drag_start_x = drag_start_x,
        drag_start_y = drag_start_y,
        mouseReleasedL = mouseReleasedL,
        mouseReleasedR = mouseReleasedR,
        mousewheel_v = mousewheel_v,
        mousewheel_h = mousewheel_h
    }
end

local function keyboard_shortcuts(ctx, patternItems, patternSelectSlider)
    local keyMods = reaper.ImGui_GetKeyMods(ctx)
    local altDown = keyMods == reaper.ImGui_Mod_Alt()
    local ctrlDown = keyMods == reaper.ImGui_Mod_Ctrl()
    local shiftDown = keyMods == reaper.ImGui_Mod_Shift()
    local ctrlShiftDown = keyMods == reaper.ImGui_Mod_Ctrl() | reaper.ImGui_Mod_Shift()
    local ctrlAltDown = keyMods == reaper.ImGui_Mod_Ctrl() | reaper.ImGui_Mod_Alt()
    local shiftAltDown = keyMods == reaper.ImGui_Mod_Shift() | reaper.ImGui_Mod_Alt()
    local ctrlAltShiftDown = keyMods == reaper.ImGui_Mod_Ctrl() | reaper.ImGui_Mod_Shift() | reaper.ImGui_Mod_Alt()

    if not menu_open then
        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_1()) then
            goToLoopStart()
        end

        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_V()) and not ctrlDown then
            show_VelocitySliders = not show_VelocitySliders
        end

        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_Q()) and not sliderTriggered then
            local numSelectedTracks = reaper.CountSelectedTracks(0)
            for i = 0, numSelectedTracks - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                if track then
                    local note_triggerindex = -1
                    for fx_index = 0, reaper.TrackFX_GetCount(track) - 1 do
                        local _, fx_name = reaper.TrackFX_GetFXName(track, fx_index, "")
                        if fx_name:find("JS: Note Trigger") then
                            note_triggerindex = fx_index
                            break
                        end
                    end

                    if note_triggerindex ~= -1 then
                        reaper.TrackFX_SetParamNormalized(track, note_triggerindex, 0, 1)
                    end
                end
            end
            sliderTriggered = true
            triggerTime = reaper.time_precise()
        elseif sliderTriggered and (reaper.time_precise() - triggerTime) > triggerDuration then
            local numSelectedTracks = reaper.CountSelectedTracks(0)
            for i = 0, numSelectedTracks - 1 do
                local track = reaper.GetSelectedTrack(0, i)
                if track then
                    local note_triggerindex = -1
                    for fx_index = 0, reaper.TrackFX_GetCount(track) - 1 do
                        local _, fx_name = reaper.TrackFX_GetFXName(track, fx_index, "")
                        if fx_name:find("JS: Note Trigger") then
                            note_triggerindex = fx_index
                            break
                        end
                    end

                    if note_triggerindex ~= -1 then
                        reaper.TrackFX_SetParamNormalized(track, note_triggerindex, 0, 0)
                    end
                end
            end
            sliderTriggered = false
        end

        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_UpArrow()) then
            goToPreviousTrack()
        end

        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_DownArrow()) then
            goToNextTrack()
        end

        -- Handle Spacebar (Transport Stop/Play)
        if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_Space()) then
            if not spacebarPressed then
                spacebarPressed = true    -- Update the state to pressed
                if reaper.GetPlayState() ~= 0 then
                    reaper.CSurf_OnStop() -- Stop the transport
                else
                    reaper.CSurf_OnPlay() -- Start the transport
                end
            end
        elseif reaper.ImGui_IsKeyReleased(ctx, reaper.ImGui_Key_Space()) then
            spacebarPressed = false -- Update the state to not pressed
        end

        if altDown then
            -- Alt + Up Arrow (Move Tracks Up)
            if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_UpArrow()) then
                moveTracksUpWithinFolders()
            end
            -- Alt + Down Arrow (Move Tracks Down)
            if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_DownArrow()) then
                moveTracksDownWithinFolders()
            end
        end

        if ctrlDown then
            -- Ctrl + C (Copy)
            if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_C()) then
                clipboard = {}
                unselectNonSuffixedTracks()
                local selTrackCount = reaper.CountSelectedTracks(0)
                for i = 0, selTrackCount - 1 do
                    local track = reaper.GetSelectedTrack(0, i)
                    local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
                    table.insert(clipboard, copyChannelData(trackIndex, patternSelectSlider, patternItems))
                end
                -- Ctrl + X (Cut)
            elseif reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_X()) then -- Ctrl + X (Cut)
                clipboard = {}
                unselectNonSuffixedTracks()
                local selTrackCount = reaper.CountSelectedTracks(0)
                for i = 0, selTrackCount - 1 do
                    local track = reaper.GetSelectedTrack(0, i)
                    local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
                    table.insert(clipboard, copyChannelData(trackIndex, patternSelectSlider, patternItems))
                    removeChannelData(trackIndex, patternSelectSlider, patternItems)
                end
                local track = reaper.GetSelectedTrack(0, 0)
                if track then 
                    local item = reaper.GetTrackMediaItem(track, 0)
                    undoPoint('Cut MIDI Notes', track, item)
                end
                -- Ctrl + V (Paste)
            elseif reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_V()) then
                unselectNonSuffixedTracks()
                if #clipboard > 0 then -- Check if clipboard contains notes
                    pasteChannelDataToSelectedTracks(patternItems, patternSelectSlider)
                end
            elseif reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_RightArrow()) then
                shiftNotes(1, patternItems, patternSelectSlider)
            elseif reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_LeftArrow()) then
                shiftNotes(-1, patternItems, patternSelectSlider)
            end
        end

        if shiftDown then
            if reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_RightArrow()) then
                shiftNotes(1, patternItems, patternSelectSlider)
            elseif reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_LeftArrow()) then
                shiftNotes(-1, patternItems, patternSelectSlider)
            end
        end
    end

    return {
        altDown = altDown,
        shiftDown = shiftDown,
        ctrlDown = ctrlDown,
        ctrlShiftDown = ctrlShiftDown,
        shiftAltDown = shiftAltDown,
        ctrlAltDown = ctrlAltDown,
        ctrlAltShiftDown = ctrlAltShiftDown

    }
end



----- PREFERENCES ------

local function obj_Preferences(ctx)
    -- Check if the Preferences popup should be shown
    if showPreferencesPopup then
        -- Store the original settings before any changes are made
        originalSizeModifier = size_modifier
        originalObjX = obj_x
        originalObjY = obj_y
        originalTimeRes = time_resolution
        originalfindTempoMarker = vfindTempoMarker
        originalFontSize = fontSize
        originalFontSidebarSize = fontSidebarButtonsSize

        -- Calculate and set the next window position
        local win_x, win_y = reaper.ImGui_GetWindowPos(ctx)
        local win_w, win_h = reaper.ImGui_GetWindowSize(ctx)
        local center_x = win_x + win_w / 2
        local center_y = win_y + win_h / 2
        reaper.ImGui_SetNextWindowPos(ctx, center_x, center_y, reaper.ImGui_Cond_Appearing(), 0.5, 0.5)

        reaper.ImGui_OpenPopup(ctx, 'PreferencesPopup')
        showPreferencesPopup = false -- Reset the flag
    end

    if reaper.ImGui_BeginPopupModal(ctx, 'PreferencesPopup', nil, reaper.ImGui_WindowFlags_AlwaysAutoResize()) then
        local scalingFactor = 0.1
        local sliderIntValue = math.floor(size_modifier / scalingFactor + 0.5)
        local minValue = math.floor(0.8 / scalingFactor)
        local maxValue = math.floor(3 / scalingFactor)
        local label = string.format('GUI Size: %.1f', size_modifier)
        _, sliderIntValue = reaper.ImGui_SliderInt(ctx, label, sliderIntValue, minValue, maxValue)
        size_modifier = sliderIntValue * scalingFactor
        obj_x, obj_y = 20 * size_modifier, 34 * size_modifier

        _, fontSize = reaper.ImGui_SliderInt(ctx, 'Font Size (requires restart)', fontSize, 6, 20)
        _, fontSidebarButtonsSize = reaper.ImGui_SliderInt(ctx, 'Sidebar Font Size (requires restart)',
            fontSidebarButtonsSize, 6, 20)

        if reaper.ImGui_Checkbox(ctx, 'Track Time Signature Markers', vfindTempoMarker) then
            vfindTempoMarker = not vfindTempoMarker -- Set vfindTempoMarker based on the new state
        end

        _, time_resolution = reaper.ImGui_SliderInt(ctx, "Time resolution", time_resolution, 2, 12)

        if reaper.ImGui_Button(ctx, 'Reset to default', 120, 0) then
            local keysToDelete = { "SizeModifier", "ObjX", "ObjY", "TimeResolution", "Find Tempo Marker", "Font Size",
                "Font Size Sidebar Buttons", "themeLastLoadedPath" }                                                                                                      -- Replace with your actual key names

            for _, key in ipairs(keysToDelete) do
                reaper.DeleteExtState("McSequencer", key, true)
            end
            reaper.ImGui_CloseCurrentPopup(ctx)
        end


        -- OK button logic
        if reaper.ImGui_Button(ctx, 'OK', 120, 0) then
            -- Save the modified settings to ExtState
            reaper.SetExtState("McSequencer", "SizeModifier", tostring(size_modifier), true)
            reaper.SetExtState("McSequencer", "ObjX", tostring(obj_x), true)
            reaper.SetExtState("McSequencer", "ObjY", tostring(obj_y), true)
            reaper.SetExtState("McSequencer", "TimeResolution", tostring(time_resolution), true)
            reaper.SetExtState("McSequencer", "Find Tempo Marker", tostring(vfindTempoMarker), true)
            reaper.SetExtState("McSequencer", "Font Size", tostring(fontSize), true)
            reaper.SetExtState("McSequencer", "Font Size Sidebar Buttons", tostring(fontSidebarButtonsSize), true)
            reaper.ImGui_CloseCurrentPopup(ctx)
        end
        reaper.ImGui_SameLine(ctx)

        -- Cancel button logic
        if reaper.ImGui_Button(ctx, 'Cancel', 120, 0) then
            -- Revert to original settings
            size_modifier = originalSizeModifier
            obj_x = originalObjX
            obj_y = originalObjY
            time_resolution = originalTimeRes
            vfindTempoMarker = originalfindTempoMarker
            fontSize = originalFontSize
            fontSidebarButtonsSize = originalFontSidebarSize
            reaper.ImGui_CloseCurrentPopup(ctx)
        end

        reaper.ImGui_EndPopup(ctx)
    end
end

local function getPreferences()
    local size_modifier = tonumber(reaper.GetExtState("McSequencer", "SizeModifier"))
    if not size_modifier then size_modifier = 1 end
    local obj_x = tonumber(reaper.GetExtState("McSequencer", "ObjX"))
    if not obj_x then obj_x = 20 end
    local obj_y = tonumber(reaper.GetExtState("McSequencer", "ObjY"))
    if not obj_y then obj_y = 34 end
    local time_resolution = tonumber(reaper.GetExtState("McSequencer", "TimeResolution"))
    if not time_resolution then time_resolution = 4 end
    local vfindTempoMarkerStr = reaper.GetExtState("McSequencer", "Find Tempo Marker")
    local vfindTempoMarker = (vfindTempoMarkerStr == "true") --
    if not vfindTempoMarkerStr then vfindTempoMarkerStr = false end
    local fontSize = tonumber(reaper.GetExtState("McSequencer", "Font Size"))
    if not fontSize then fontSize = 13 end
    local fontSidebarButtonsSize = tonumber(reaper.GetExtState("McSequencer", "Font Size Sidebar Buttons"))
    if not fontSidebarButtonsSize then fontSidebarButtonsSize = 12 end

    return size_modifier, obj_x, obj_y, time_resolution, vfindTempoMarker, fontSize, fontSidebarButtonsSize
end
local function obj_HoveredInfo(ctx, hoveredControlInfo)
    local displayText
    if hoveredControlInfo.id ~= "" then
        local formattedValue = ""
        local id = tostring(hoveredControlInfo.id)

        -- Determine how to format the value and whether to append a colon
        local appendColon = true

        if type(hoveredControlInfo.value) == "number" then
            formattedValue = string.format("%.3f", hoveredControlInfo.value)
        elseif type(hoveredControlInfo.value) == "boolean" then
            formattedValue = tostring(hoveredControlInfo.value)
            id = string.gsub(id, "^##", "")
        elseif type(hoveredControlInfo.value) == "string" then
            formattedValue = hoveredControlInfo.value
            appendColon = false -- Do not append colon for string values
        end

        -- Construct the display text with or without a colon
        if appendColon then
            displayText = id .. ': ' .. formattedValue
        else
            displayText = id .. ' ' .. formattedValue
        end

        -- Clear hoveredControlInfo values
        hoveredControlInfo.id = ""
        hoveredControlInfo.value = ''
    else
        displayText = " " -- Display a dummy value when there is no valid hoveredControlInfo.id
    end

    -- Display the text
    reaper.ImGui_Text(ctx, displayText)
end

----- MAIN --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SetButtonState(1)
reaper.atexit(Exit)
reaper.Undo_BeginBlock()
create_or_find_track(target_track_name, 1, track_suffix)
create_pattern_item_if_not_exist(track_suffix)
reaper.Undo_EndBlock('Sequencer Initialize', -1)
update_channel_data_from_reaper(track_suffix, track_count)
clear_extstate_channel_data()
retrieveExtState()
load_channel_data()
local colorValues = colors.colorUpdate()
-- printTable(colorValues)
size_modifier, obj_x, obj_y, time_resolution, vfindTempoMarker, fontSize, fontSidebarButtonsSize = getPreferences()
local ctx = reaper.ImGui_CreateContext("McSequencer")
drawList = reaper.ImGui_GetWindowDrawList(ctx)
local font = reaper.ImGui_CreateFont("Arial", fontSize)
local font_SidebarSampleTitle = reaper.ImGui_CreateFont("Arial", fontSidebarButtonsSize + 5)
local font_SidebarButtons = reaper.ImGui_CreateFont("Arial", fontSidebarButtonsSize)
reaper.ImGui_Attach(ctx, font)
reaper.ImGui_Attach(ctx, font_SidebarSampleTitle)
reaper.ImGui_Attach(ctx, font_SidebarButtons)
local clipper = reaper.ImGui_CreateListClipper(ctx)
local FLT_MIN, FLT_MAX = reaper.ImGui_NumericLimits_Float()

reaper.ImGui_SetConfigVar(ctx, 18, 1) -- move from title bar only
local windowflags = reaper.ImGui_WindowFlags_NoScrollbar() | reaper.ImGui_WindowFlags_NoScrollWithMouse() |
reaper.ImGui_WindowFlags_MenuBar() | reaper.ImGui_WindowFlags_NoCollapse()


----------------------------------------------------------------------------
----- GUI LOOP -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------
local function loop()
    if showColorPicker then
        colorValues = colors.colorUpdate()
    end

    reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowMinSize(), 440, 250)
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_WindowBg(), colorValues.color1_bg);
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_TitleBg(), colorValues.color2_titlebar);
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_TitleBgActive(), colorValues.color3_titlebaractive);
    reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ScrollbarBg(), colorValues.color4_scrollbar);
    local visible, open = reaper.ImGui_Begin(ctx, "McSequencer", true, windowflags);
    reaper.ImGui_PushFont(ctx, font);

    if visible then
        local track_count = reaper.CountTracks(0)
        local patternItems, patternTrackIndex, patternTrack = getPatternItems(track_count)
        local mouse = mouseTrack(ctx)
        local keys = keyboard_shortcuts(ctx, patternItems, patternSelectSlider)
        local channel = update(ctx, track_count, track_suffix, channel)
        local window_width = reaper.ImGui_GetWindowWidth(ctx)
        local window_height = reaper.ImGui_GetWindowHeight(ctx)

        ----- MENU BAR -----
        if reaper.ImGui_BeginMenuBar(ctx) then
            if reaper.ImGui_BeginMenu(ctx, "Options") then
                if reaper.ImGui_MenuItem(ctx, "Preferences") then
                    showPreferencesPopup = true
                end
                reaper.ImGui_Separator(ctx)
                local action_state = reaper.GetToggleCommandState(1156)
                local is_checked = (action_state == 1)
                if reaper.ImGui_MenuItem(ctx, 'Item Grouping', '', is_checked) then
                    reaper.Main_OnCommand(1156, 0) -- 1156 is the command ID for the toggle action
                end
                reaper.ImGui_Separator(ctx)
                if reaper.ImGui_MenuItem(ctx, "Show Theme Editor") then
                    showColorPicker = not showColorPicker
                end
                if reaper.ImGui_MenuItem(ctx, "Show FPS") then
                    showFPS = not showFPS
                end

                reaper.ImGui_EndMenu(ctx)
            end

            if showFPS then
                reaper.ImGui_SetCursorPosX(ctx, window_width - 55)
                reaper.ImGui_Text(ctx, 'FPS: ' .. math.floor((reaper.ImGui_GetFramerate(ctx))))
            end;
            reaper.ImGui_EndMenuBar(ctx)
        end

        obj_Preferences(ctx)

        ----- TOP ROW -----
        local tableflags0 = nil;
        if reaper.ImGui_BeginChild(ctx, 'Top Row', nil, top_row_x * size_modifier) then
            -- menu bar
            --
            -- color picker
            if showColorPicker then
                colors.obj_ColorPicker(ctx);
                top_row_x = 420
            else
                top_row_x = 34
            end;

            reaper.ImGui_SameLine(ctx);
            -- offset sliders show button
            -- if reaper.ImGui_Button(ctx, "Offset") then
            -- show_OffsetSliders = not show_OffsetSliders;
            -- end; 
            -- reaper.ImGui_SameLine(ctx, 160);
            -- pattern controller
            local selectedItemStartPos, maxPatternNumber = obj_Pattern_Controller(patternItems, ctx,
                mouse, keys, colorValues);

            if vfindTempoMarker and selectedItemStartPos then
                local index, time, timesigNum, timesigDenom = findTempoMarkerFromPosition(selectedItemStartPos)
                if index then
                    time_resolution = timesigNum
                end
            end

            reaper.ImGui_SameLine(ctx);

            obj_New_Pattern(ctx, patternItems, colorValues, maxPatternNumber, track_count) 

            reaper.ImGui_SameLine(ctx, window_width - 85);


            -- velocity sliders show button
            if obj_Button(ctx, "Velocity", false, colorValues.color34_channelbutton_active, colorValues.color32_channelbutton, colorValues.color35_channelbutton_frame, 1, 66 * size_modifier, 22 * size_modifier, "Show velocity sliders") then
                show_VelocitySliders = not show_VelocitySliders;
            end;

            --test
            -- reaper.ImGui_SameLine(ctx);

            -- if  obj_Button(ctx,"Test", false, colorValues.color61_button_sidebar_active, colorValues.color62_button_sidebar_inactive, colorValues.color63_button_sidebar_border, 1, 99, 23) then      --

            --     for k, v in pairs(_G) do
            --         print(k, v)
            --     end
            -- end

            reaper.ImGui_Dummy(ctx, 0, 0)
            reaper.ImGui_EndChild(ctx)
        end

        -----  MIDDLE ROW -----

        if reaper.ImGui_BeginChild(ctx, "Middle Row", -controlSidebarWidth * size_modifier, obj_y + 4) then
            -- reaper.ImGui_SameLine(ctx, 0)
            reaper.ImGui_SetCursorPosX(ctx, 8)
            reaper.ImGui_PushID(ctx, 0);
            local pt = parent.GUID.trackIndex[0]
            -- Mute Button
            parent.GUID.mute[0] = obj_muteButton(ctx, "##Mute", parent.GUID.mute[0], pt,
                colorValues.color55_button_mute_active, colorValues.color56_button_mute_inactive,
                colorValues.color57_button_mute_border, 1, obj_x, obj_y,
                keys);
            reaper.ImGui_SameLine(ctx, 0, 3 * size_modifier);
            -- Solo Button
            parent.GUID.solo[0] = obj_soloButton(ctx, "##Solo", parent.GUID.solo[0], pt,
                colorValues.color58_button_solo_active, colorValues.color59_button_solo_inactive,
                colorValues.color60_button_solo_border, 1, obj_x, obj_y,
                keys);
            reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
            -- Volume Knob
            rv_vol, parent.GUID.volume[0] = obj_VolKnob(ctx, "Volume", 12 * size_modifier, parent.GUID.volume[0], 0, 3, 1,
                nil, 1, .1,
                colorValues.color40_knob_tcp_circle, colorValues.color41_knob_tcp_line,
                colorValues.color40_knob_tcp_circle, false, 1, .1, false, 5, keys, mouse);
            reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
            -- -- Pan Knob
            rv_vol, parent.GUID.pan[0] = obj_Knob(ctx, "Pan", 12 * size_modifier, parent.GUID.pan[0], -1, 1, 0, nil, 1,
                .1,
                colorValues.color40_knob_tcp_circle, colorValues.color41_knob_tcp_line,
                colorValues.color40_knob_tcp_circle, false, 1, .1, false, 5, keys);
            reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
            --pop id
            reaper.ImGui_PopID(ctx);
            -- Channel Button
            reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Border(), colorValues.color35_channelbutton_frame)
            reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(), 1)
            reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(), colorValues.color34_channelbutton_active)
            reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), colorValues.color32_channelbutton)
            reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), colorValues.color32_channelbutton)
            local rv_chan_button = reaper.ImGui_Button(ctx, 'Patterns SEQ', 95 * size_modifier, obj_y)
            reaper.ImGui_PopStyleColor(ctx, 4)
            reaper.ImGui_PopStyleVar(ctx, 1)
            reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
            -- Selector
            obj_Selector(ctx, pt, obj_x, obj_y, colorValues.color30_selector, 3, colorValues.color31_selector_frame, 0,
                mouse, keys);
            reaper.ImGui_SameLine(ctx, 0, 1 * size_modifier);
            -- play cursor buttons
            obj_PlayCursor_Buttons(ctx, mouse, keys, patternSelectSlider, colorValues);
            reaper.ImGui_EndChild(ctx)
        end

        ----- DELETE POPUP ------

        if showPopup then
            unselectNonSuffixedTracks()
            local track_count = reaper.CountSelectedTracks(0)
            confirmed = popup(ctx, track_count)
            if confirmed then
                deleteTrack(trackIndex)
            end
        end

        -----  SEQUENCER -----
        if channel and channel.channel_amount then
            if reaper.ImGui_BeginChild(ctx, "Sequencer Row", -controlSidebarWidth * size_modifier, -25 * size_modifier, 1, reaper.ImGui_WindowFlags_NoScrollWithMouse() | reaper.ImGui_WindowFlags_HorizontalScrollbar()) then
                reaper.ImGui_ListClipper_Begin(clipper, channel.channel_amount) --
                while reaper.ImGui_ListClipper_Step(clipper) do
                    local display_start, display_end = reaper.ImGui_ListClipper_GetDisplayRange(clipper)
                    for i = display_start, display_end - 1 do
                        local actualTrackIndex = channel.GUID.trackIndex[i + 1];
                        local pattern_item, pattern_start, pattern_end, midi_item = getSelectedPatternItemAndMidiItem(
                            actualTrackIndex, patternItems, patternSelectSlider)
                        local note_positions, note_velocities = populateNotePositions(midi_item)
                        -- reaper.ImGui_Dummy(ctx, 0,0)
                        reaper.ImGui_PushID(ctx, i);
                        -- Mute Button
                        channel.GUID.mute[i + 1] = obj_muteButton(ctx, "##Mute", channel.GUID.mute[i + 1],
                            actualTrackIndex,
                            colorValues.color55_button_mute_active, colorValues.color56_button_mute_inactive,
                            colorValues.color57_button_mute_border, 1, obj_x, obj_y, keys);
                        reaper.ImGui_SameLine(ctx, 0, 3 * size_modifier);
                        -- Solo Button
                        channel.GUID.solo[i + 1] = obj_soloButton(ctx, "##Solo", channel.GUID.solo[i + 1],
                            actualTrackIndex,
                            colorValues.color58_button_solo_active, colorValues.color59_button_solo_inactive,
                            colorValues.color60_button_solo_border, 1, obj_x, obj_y, keys);
                        reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
                        -- Volume Knob
                        rv_vol, channel.GUID.volume[i + 1] = obj_VolKnob(ctx, "Volume", 12 * size_modifier,
                            channel.GUID.volume[i + 1], 0, 3, 1, nil, 1, .1,
                            colorValues.color40_knob_tcp_circle, colorValues.color41_knob_tcp_line,
                            colorValues.color40_knob_tcp_circle, false, 1, .1, false, 5, keys, mouse);
                        reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
                        -- Pan Knob
                        rv_vol, channel.GUID.pan[i + 1] = obj_Knob(ctx, "Pan", 12 * size_modifier,
                            channel.GUID.pan[i + 1],
                            -1, 1, 0, nil, 1, .1,
                            colorValues.color40_knob_tcp_circle, colorValues.color41_knob_tcp_line,
                            colorValues.color40_knob_tcp_circle, false, 1, .1, false, 5, keys);
                        reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
                        --pop id
                        reaper.ImGui_PopID(ctx);
                        -- Channel Button
                        obj_Channel_Button(ctx, i + 1, mouse, patternItems, track_count, colorValues);
                        reaper.ImGui_SameLine(ctx, 0, 6 * size_modifier);
                        -- Selector
                        obj_Selector(ctx, actualTrackIndex, obj_x, obj_y, colorValues.color30_selector, 3,
                            colorValues.color31_selector_frame, 0, mouse, keys);
                        -- reaper.ImGui_SameLine(ctx, 9, 9 * size_modifier);
                        -- -- Sequencer Buttons
                        local note_positions, note_velocities = obj_Sequencer_Buttons(ctx, actualTrackIndex, mouse, keys,
                            pattern_item, pattern_start, pattern_end, midi_item, note_positions, note_velocities,
                            patternItems, colorValues)

                        -- Velocity Sliders
                        if show_VelocitySliders then
                            reaper.ImGui_Dummy(ctx, 122 * size_modifier, 0);

                            obj_VelocitySliders(ctx, actualTrackIndex,
                                note_positions, note_velocities, mouse, keys, numberOfSliders, sliderWidth, sliderHeight,
                                x_padding, patternItems, patternSelectSlider, colorValues)
                        end;
                        -- Offset Sliders
                        -- if show_OffsetSliders then
                        --     reaper.ImGui_SameLine(ctx, nil, 233)
                        --     obj_OffsetSliders(ctx, actualTrackIndex, note_positions);
                        -- end;
                    end
                end;
                obj_Invisible_Channel_Button(track_suffix, ctx, count_tracks, colorValues)
                reaper.ImGui_EndChild(ctx)
            end
        end
        printHere()

        ---- CONTROL SIDEBAR -----
        reaper.ImGui_PopFont(ctx);
        reaper.ImGui_PushFont(ctx, font_SidebarButtons)
        reaper.ImGui_SameLine(ctx) -- Place the control sidebar on the same line (side by side)

        if reaper.ImGui_BeginChild(ctx, 'Sidebar', 10 + controlSidebarWidth * size_modifier, -25 * size_modifier, false, reaper.ImGui_WindowFlags_NoScrollWithMouse()) then
            obj_Control_Sidebar(ctx, keys, colorValues, mouse)
        end

        reaper.ImGui_EndChild(ctx)
        reaper.ImGui_PopFont(ctx);
        -- reaper.ImGui_PushFont(ctx, font);

        ---  BOTTOM ROW -----
        if reaper.ImGui_BeginChild(ctx, 'Bottom Row', window_width * size_modifier, window_height * size_modifier, false, reaper.ImGui_WindowFlags_NoScrollbar()) then
            reaper.ImGui_Dummy(ctx, 0, 1 * size_modifier)
            obj_Add_Channel_Button(track_suffix, ctx, count_tracks, colorValues)
            reaper.ImGui_SameLine(ctx, nil, 10)
            reaper.ImGui_SetCursorPosY(ctx, 2)
            obj_HoveredInfo(ctx, hoveredControlInfo);
            reaper.ImGui_EndChild(ctx)
        end

        menu_open = nil

        reaper.ImGui_PopStyleVar(ctx, 1)
        -- reaper.ImGui_PopFont(ctx);
        reaper.ImGui_End(ctx);
        reaper.ImGui_PopStyleColor(ctx, 4);

        if open then
            reaper.defer(loop);
        else
            Exit();
        end;
    end
end;


reaper.defer(loop)

-- local profiler = dofile(reaper.GetResourcePath() ..
--   '/Scripts/ReaTeam Scripts/Development/cfillion_Lua profiler.lua')
-- reaper.defer = profiler.defer
-- profiler.attachToWorld() -- after all functions have been defined
-- profiler.run()
