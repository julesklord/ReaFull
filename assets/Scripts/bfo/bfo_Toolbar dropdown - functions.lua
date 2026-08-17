function findInTable(name, lines, startFrom)
    local name = name
    local lines = lines
    local startFrom = startFrom
    for key,value in pairs(lines) do
        if string.find(value,name)~=nil and key>=startFrom then
            return key
        end
    end
    return -1
    
end


function drawMenu(menuName)

      gfx.init("", 0, 0)
      
      gfx.x = gfx.mouse_x
      gfx.y = gfx.mouse_y
      
      
      --open file
      filePath = reaper.GetResourcePath().."/reaper-menu.ini"

      file = io.open(filePath, "r")
      if not file then return end
      io.close(file)
      
      --get lines
      lines = {}
      for line in io.lines(filePath) do 
        lines[#lines + 1] = line
      end
            
      name = "^%[" .. menuName .. "%]$"
      offsetStart = 1 + findInTable(name, lines, 0)      
      
      menu = {}
      showString = ""
      i = offsetStart
      while lines[i]~="" and lines[i]~=nil do
          
          if string.find(lines[i],"title") then
                title = string.sub(lines[i],7)
          else    
                id = string.sub(lines[i], string.find(lines[i],"%d+") )
                value = string.sub(lines[i],string.find(lines[i],"=")+1 )
                          
                if string.find(value," ")==nil then
                    action = value
                    if action=="-1" then
                        showString = showString .. "|" --separator
                    elseif action=="-2" then
                        showString = showString .. ">|"
                    elseif action=="-3" then
                        showString = showString .. "<|" 
                    end
                    name = ""
                else
                    action = string.sub(value, 1, string.find(value," ")-1 )
                    name = string.sub(value, string.find(value," ")+1 )
                    if action=="-1" then
                        showString = showString .. "|" .. name --separator
                    elseif action=="-2" then
                        showString = showString .. ">".. name .."|"
                    elseif action=="-3" then
                        showString = showString .. "<".. name .. "|" 
                    else
                        if string.find(menuName,"MIDI") then
                              toggleState = reaper.GetToggleCommandStateEx( 32060, reaper.NamedCommandLookup(action,0) )
                        else
                              toggleState =  reaper.GetToggleCommandState( reaper.NamedCommandLookup(action,0))
                        end
                        if toggleState==1 then
                            showString = showString .. "!" .. name .. "|"
                        else
                            showString = showString .. name .. "|"
                        end
                        menu[#menu+1] = {action, name}
                    end
                end                
          end --else
          i = i+1
      end --for
      
      --showString = "#" .. title .. "||" .. showString
      
      retval = gfx.showmenu(showString)
      
      if retval>0 then
          if string.find(menuName,"MIDI") then
              reaper.MIDIEditor_OnCommand(  reaper.MIDIEditor_GetActive(), reaper.NamedCommandLookup(menu[retval][1]))
          else
              reaper.Main_OnCommand(reaper.NamedCommandLookup(menu[retval][1]),0)
          end
          --reaper.ShowConsoleMsg(reaper.NamedCommandLookup(menu[retval][1]))
      end
     
      gfx.quit()
end  --function main

