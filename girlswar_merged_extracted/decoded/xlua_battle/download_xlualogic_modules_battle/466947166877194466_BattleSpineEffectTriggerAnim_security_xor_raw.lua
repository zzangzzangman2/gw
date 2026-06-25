function OnInit(e)
end
function OnOpen(e)
local e=transform:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if e then
local a="A"
local t=e.AnimationName
if t~=nil and t~=""then
a=t
end
e.AnimationState:SetAnimation(0,a,true)
end
end
function OnClose()
end
function OnBeforeDestroy()
end
function OnRefresh(e)
end

