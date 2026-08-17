--[[
  ReaFull: Tools & Resource Manager for Linux
  Author: Jules Martins / ReaFull Team
  Description: In-DAW resource manager, GitHub releases checker, and ReaPack synchronizer.
]]

local repo_owner = "julesklord"
local repo_name = "ReaFull"
local api_url = string.format("https://api.github.com/repos/%s/%s/releases/latest", repo_owner, repo_name)
local repo_url = string.format("https://github.com/%s/%s", repo_owner, repo_name)

local config_path = reaper.GetResourcePath()
local os_name = reaper.GetOS()
local is_linux = (os_name:match("Other") ~= nil or os_name:match("Linux") ~= nil) and os_name:match("Win") == nil and os_name:match("OSX") == nil

function msg(text, title)
    title = title or "ReaFull"
    reaper.ShowMessageBox(tostring(text), title, 0)
end

function exec_cmd(cmd)
    local handle = io.popen(cmd)
    if not handle then return nil end
    local result = handle:read("*a")
    handle:close()
    return result
end

function check_online_update()
    local curl_cmd = string.format("curl -s -m 5 -H 'User-Agent: REAPER-ReaFull' '%s'", api_url)
    local response = exec_cmd(curl_cmd)
    
    if not response or response == "" or response:match("API rate limit") or response:match("Not Found") then
        local msg_text = "No se encontraron versiones publicadas (Releases) en GitHub o no hay conexión a internet.\n\n" ..
                         "Repositorio: " .. repo_url .. "\n\n" ..
                         "¿Deseas abrir la página del proyecto o sincronizar tus paquetes de ReaPack?"
        local choice = reaper.ShowMessageBox(msg_text, "ReaFull Manager", 4)
        if choice == 6 then -- Yes
            sync_reapack()
        end
        return
    end

    local tag_name = response:match('"tag_name":%s*"([^"]+)"') or "Latest"
    local published_at = response:match('"published_at":%s*"([^"]+)"') or ""
    local html_url = response:match('"html_url":%s*"([^"]+)"') or repo_url
    
    local msg_text = string.format("Versión disponible en GitHub: %s (%s)\n\n¿Deseas abrir la página del release para revisar las notas de actualización?", tag_name, published_at:sub(1, 10))
    local choice = reaper.ShowMessageBox(msg_text, "ReaFull Updater", 4)
    if choice == 6 then
        os.execute(string.format("xdg-open '%s' 2>/dev/null &", html_url))
    end
end

function sync_reapack()
    local sync_cmd = reaper.NamedCommandLookup("_REAPACK_SYNC")
    if sync_cmd and sync_cmd ~= 0 then
        reaper.Main_OnCommand(sync_cmd, 0)
        reaper.ShowMessageBox("Sincronización de repositorios ReaPack iniciada.", "ReaFull", 0)
    else
        reaper.ShowMessageBox("ReaPack no se encuentra instalado o registrado en esta instalación de REAPER.", "ReaFull", 0)
    end
end

function reload_theme_and_views()
    reaper.ThemeLayout_RefreshAll()
    reaper.UpdateArrange()
    reaper.UpdateTimeline()
    reaper.ShowMessageBox("Vistas, temas y disposición de pantalla recargados correctamente.", "ReaFull", 0)
end

function main_menu()
    local menu_str = "#ReaFull Suite por Jules Martins||" ..
                     "Buscar actualizaciones en GitHub|" ..
                     "Sincronizar repositorios ReaPack|" ..
                     "Recargar Tema y Vistas|" ..
                     "|Abrir carpeta de configuración de REAPER|" ..
                     "Ver documentación en línea"
                     
    gfx.init("ReaFullMenu", 0, 0, 0, 0, 0)
    local x, y = reaper.GetMousePosition()
    gfx.x, gfx.y = gfx.screentoclient(x, y)
    local selected = gfx.showmenu(menu_str)
    gfx.quit()

    if selected == 1 then
        check_online_update()
    elseif selected == 2 then
        sync_reapack()
    elseif selected == 3 then
        reload_theme_and_views()
    elseif selected == 4 then
        os.execute(string.format("xdg-open '%s' 2>/dev/null &", config_path))
    elseif selected == 5 then
        os.execute(string.format("xdg-open '%s' 2>/dev/null &", repo_url))
    end
end

main_menu()
