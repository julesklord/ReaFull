--[[
  ReaFull: Updater & Resource Downloader for Linux
  Author: Jules Martins / ReaFull Team
  Description: In-DAW updater, GitHub asset fetcher, and ReaPack synchronization tool.
]]

local repo_owner = "julesklord"
local repo_name = "ReaFull"
local api_url = string.format("https://api.github.com/repos/%s/%s/releases/latest", repo_owner, repo_name)
local raw_url = string.format("https://raw.githubusercontent.com/%s/%s/main", repo_owner, repo_name)

local config_path = reaper.GetResourcePath()
local is_linux = reaper.GetOS():match("Other") or reaper.GetOS():match("OSX") == nil and reaper.GetOS():match("Win") == nil

function msg(text, title)
    title = title or "ReaFull Updater"
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
        -- Fallback check git commit or branch
        local msg_text = "No se pudo conectar a GitHub Releases (o aún no hay releases creados).\n\n" ..
                         "¿Deseas sincronizar los paquetes de ReaPack y actualizar la configuración local?"
        local choice = reaper.ShowMessageBox(msg_text, "ReaFull Updater", 4)
        if choice == 6 then -- Yes
            sync_reapack()
        end
        return
    end

    local tag_name = response:match('"tag_name":%s*"([^"]+)"') or "Latest"
    local published_at = response:match('"published_at":%s*"([^"]+)"') or ""
    
    local msg_text = string.format("Versión disponible en GitHub: %s (%s)\n\n¿Deseas descargar e instalar la última actualización de ReaFull?", tag_name, published_at:sub(1, 10))
    local choice = reaper.ShowMessageBox(msg_text, "ReaFull Updater", 4)
    if choice == 6 then
        download_and_apply_update()
    end
end

function sync_reapack()
    -- ReaPack: Synchronize packages command ID
    local sync_cmd = reaper.NamedCommandLookup("_REAPACK_SYNC")
    if sync_cmd and sync_cmd ~= 0 then
        reaper.Main_OnCommand(sync_cmd, 0)
        reaper.ShowMessageBox("Sincronización de ReaPack iniciada.", "ReaFull", 0)
    else
        reaper.ShowMessageBox("ReaPack no se encuentra instalado o registrado en esta sesión.", "ReaFull", 0)
    end
end

function download_and_apply_update()
    local install_script = config_path .. "/Scripts/ReaFull/update_installer.py"
    -- Run updater via python in background
    local cmd = string.format("python3 -c \"import urllib.request, os; urllib.request.urlretrieve('%s/install.py', '/tmp/reafull_install.py'); os.system('python3 /tmp/reafull_install.py --quiet --no-backup')\" &", raw_url)
    os.execute(cmd)
    reaper.ShowMessageBox("Actualización de ReaFull ejecutándose en segundo plano.\nReinicia REAPER cuando finalice.", "ReaFull", 0)
end

function main_menu()
    local menu_str = "#ReaFull Suite por Jules Martins||" ..
                     "Buscar actualizaciones en GitHub|" ..
                     "Sincronizar repositorios ReaPack|" ..
                     "Recargar Tema y Vistas|" ..
                     "|Abrir carpeta de configuración de REAPER"
                     
    gfx.init("ReaFullMenu", 0, 0, 0, 0, 0)
    local x, y = gfx.mouse_cap, gfx.mouse_cap
    x, y = reaper.GetMousePosition()
    gfx.x, gfx.y = gfx.screentoclient(x, y)
    local selected = gfx.showmenu(menu_str)
    gfx.quit()

    if selected == 1 then
        check_online_update()
    elseif selected == 2 then
        sync_reapack()
    elseif selected == 3 then
        reaper.ThemeLayout_RefreshAll()
        reaper.UpdateArrange()
        reaper.UpdateTimeline()
        reaper.ShowMessageBox("Vistas y temas recargados correctamente.", "ReaFull", 0)
    elseif selected == 4 then
        os.execute(string.format("xdg-open '%s' 2>/dev/null &", config_path))
    end
end

main_menu()
