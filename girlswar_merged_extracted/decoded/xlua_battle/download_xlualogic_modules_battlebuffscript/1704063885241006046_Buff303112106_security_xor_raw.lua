local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddDispelDisturb(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveDispelDisturb(e.buffId)
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnTriggerDispelDisturb(e,t)
local a=e:GetBuffData()
if t==true and a[5]>=RandomMgr:GetBattleRandom()then
local a=303112114
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.OnAddBuffGrowth(t)
end
local t=e:GetFloors()
if t>1 then
e:ReduceFloors(1)
return true,false
else
return true,true
end
end
return false,false
end
return o

