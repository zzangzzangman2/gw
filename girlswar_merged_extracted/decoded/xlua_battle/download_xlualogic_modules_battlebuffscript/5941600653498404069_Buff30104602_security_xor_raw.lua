local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(30104602)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(30104602)
end
function e.DoAction(t,e,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a[1]
if o:IsStrongCtlBuff(a)then
if e[2]<e[1]then
e[2]=e[2]+1
if e[2]>=e[1]then
t.isExec=true
end
return{
ret=true,
remove=true
}
end
end
return{
ret=false
}
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
return i

