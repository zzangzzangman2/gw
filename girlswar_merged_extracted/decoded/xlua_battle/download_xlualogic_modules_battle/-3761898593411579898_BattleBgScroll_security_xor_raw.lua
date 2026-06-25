local t=19
local s=0.2
local i=0
local n=0
local a=false
local e=nil
function OnInit(e)
local a,e,e=LuaUtils.GetLocalPos(BottomLeftPoint.transform)
local e,o,o=LuaUtils.GetLocalPos(BottomRightPoint.transform)
t=e-a
end
function OnOpen(a)
local i,o,a=LuaUtils.GetLocalPos(bg_Item.transform)
LuaUtils.SetLocalPos(bg_Item.transform,0,o,a)
if e==nil then
e=LuaUtils.Instantiate(bg_Item.transform)
LuaUtils.SetParent(e.transform,bg_layer.transform)
LuaUtils.SetLocalPos(e.transform,t,o,a)
end
end
function OnClose()
end
function OnBeforeDestroy()
end
function OnRefresh(e)
end
function Reset()
end
function MoveBg(e)
i=Time.time
n=e
a=true
end
function OnUpdate()
if GameInit.IsClient==false then
return
end
if a then
if i+n<Time.time then
a=false
return
end
local e,a,a=LuaUtils.GetLocalPos(bg_layer.transform)
local e=e-s
if e<-t then
LuaUtils.SetLocalPos(bg_layer.transform,0,0,0)
else
LuaUtils.SetLocalPos(bg_layer.transform,e,0,0)
end
end
end 
