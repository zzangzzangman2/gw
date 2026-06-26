local e=nil
function OnInit(e,e)
end
function OnOpen(t)
t=t or{}
local a=t.closeDoorCallback
local t=spine_cut:GetComponent(typeof(CS.YouYou.UISpineCtr))
t:PlayAnimation(0,'A1',false,function()
t:PlayAnimation(0,"A2",false)
end)
StopDelaySequence()
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(0.5)
t:AppendCallback(function()
if a then
a()
end
end)
e=t
end
function OnClose()
StopDelaySequence()
end
function OnBeforeDestroy()
end
function StopDelaySequence()
if e~=nil then
e:Kill()
e=nil
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

