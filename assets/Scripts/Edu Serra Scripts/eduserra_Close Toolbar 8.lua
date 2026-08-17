local function no_undo()reaper.defer(function()end)end;

local numbToolbar = 8;

local Toolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685,
                  41686,41936,41937,41938,41939,41940,41941,41942,41943};

reaper.PreventUIRefresh(1);

local stateTopDock = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;

local state = reaper.GetToggleCommandState(Toolbar_T[numbToolbar]);
if state == 1 then;
    reaper.Main_OnCommand(Toolbar_T[numbToolbar],0);
end;

local stateTopDock_End = (reaper.GetToggleCommandState(41297)==1);
if stateTopDock_End ~= stateTopDock then;
    reaper.Main_OnCommand(41297,0);
end;

reaper.PreventUIRefresh(-1);

reaper.Undo_BeginBlock();
if numbToolbar == 0 then numbToolbar = "Main" end;
reaper.Undo_EndBlock('Close toolbar'..numbToolbar,0);
