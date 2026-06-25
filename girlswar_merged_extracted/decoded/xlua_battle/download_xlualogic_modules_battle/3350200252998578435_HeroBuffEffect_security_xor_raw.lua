local e
local i
function OnInit()
e={}
end
function OnEnable(e)
end
function OnDisable()
end
function OnBeforeDestroy()
e=nil
end
function OnUpdate()
LuaUtils.Rotate(Surround,0,Time.deltaTime*50,0)
end
function OnDoAction(e,t)
if(e=="InitBuffData")then
InitBuffData(t)
elseif(e=="AddFloors")then
AddFloors(t)
elseif(e=="ReduceFloors")then
ReduceFloors(t)
elseif(e=="Dispose")then
Dispose()
end
end
function InitBuffData(t)
if(BuffEffectType~=1)then
return
end
i=t[1]
local t=t[2]
local a=ModulesInit.TaskMgr.CreateTaskGroup()
for t=1,t do
local t=ModulesInit.TaskMgr.CreateTaskRoutine()
t.CurrTask=function()
GameTools:PoolGameObjectSpawn(
i,
t,
function(t,o,a)
LuaUtils.SetParent(t,Surround)
LuaUtils.SetLocalPos(t,0,0,0)
table.add(e,t)
a:Leave()
end
)
end
a:AddTask(t)
end
a.OnComplete=function()
RefreshEffect()
end
a:Run()
end
function AddFloors(t)
local o=ModulesInit.TaskMgr.CreateTaskGroup()
for t=1,t do
local a=ModulesInit.TaskMgr.CreateTaskRoutine()
a.CurrTask=function()
GameTools:PoolGameObjectSpawn(
i,
a,
function(t,o,a)
LuaUtils.SetParent(t,Surround)
LuaUtils.SetLocalPos(t,0,0,0)
table.add(e,t)
a:Leave()
end
)
end
o:AddTask(a)
end
o.OnComplete=function()
RefreshEffect()
end
o:Run()
end
function ReduceFloors(t)
if(t<1)then
return
end
if(e)then
for a=#e,1,-1 do
local o=e[a]
GameEntry.Pool:GameObjectDespawn(o)
table.remove(e,a)
t=t-1
if(t==0)then
break
end
end
end
RefreshEffect()
end
function RefreshEffect()
if(e)then
local t=#e
local t=360/t
for e,a in ipairs(e)do
LuaUtils.SetRotation(a,0,(e-1)*t,0)
end
end
end
function Dispose()
if(e)then
for t=#e,1,-1 do
local a=e[t]
GameEntry.Pool:GameObjectDespawn(a)
table.remove(e,t)
end
end
end 
