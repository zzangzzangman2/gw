local e=Class("Bubbles",{})
e.ShowMap={}
e.ShowInst=nil
e.GTimer=nil
function e.Refresh()
if PlayerMgr.loginLoadComplete==false then return end
if e.ShowInst==nil then
for t,a in pairs(e.ShowMap or{})do
if t.currShow==true then
t.currShow=false
t.refreshCount=0
else
if e.ShowInst==nil then
e.ShowInst=t
e.ShowInst.currShow=true
LuaUtils.SetActive(e.ShowInst.node,true)
end
end
end
end
if e.ShowInst then
e.ShowInst.refreshCount=e.ShowInst.refreshCount+1
if e.ShowInst.refreshCount==6 then
LuaUtils.SetActive(e.ShowInst.node,false)
if#table.keys(e.ShowMap)>1 then
e.ShowInst=nil
end
elseif e.ShowInst.refreshCount==10 then
e.ShowInst=nil
end
end
end
function e.AddShow(t)
e.ShowMap[t]=true
if e.GTimer==nil then
e.GTimer=ModulesInit.TimeActionMgr:CreateTimeAction()
e.GTimer:Init(0,0.5,-1,nil,e.Refresh,nil):Run()
end
end
function e.RemoveShow(t)
e.ShowMap[t]=nil
LuaUtils.SetActive(t.node,false)
end
function e:__init(t)
self.node=t.node
self.checkFunc=t.checkFunc
self.isShow=false
self.timer=nil
self.refreshCount=0
self.currShow=false
e.RemoveShow(self)
end
function e:HideShow()
if PlayerMgr.loginLoadComplete==false then return end
self.refreshCount=self.refreshCount+1
if self.refreshCount==2 then
e.RemoveShow(self)
elseif self.refreshCount==5 then
e.AddShow(self)
end
if self.refreshCount>=5 then
self.refreshCount=0
end
end
function e:CheckAndRefresh(t)
local t=PlayerMgr.loginComplete==false or t~=DOCK_TYPE.MAIN_PAGE
if t then
self:Clean()
else
local t=self.checkFunc()
if t then
if t~=self.isShow then
self:Clean()
e.AddShow(self)
end
else
self:Clean()
end
self.isShow=t
end
end
function e:Clean()
if self.timer then
self.timer:Stop()
self.timer=nil
end
self.refreshCount=0
self.isShow=false
e.RemoveShow(self)
end
return e 
