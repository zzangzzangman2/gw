local n=require("Modules/Battle/BattleUtil")
local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,a,o,o,o,e)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.buffTriggerTime==BuffTriggerTime.now
or e.buffTriggerTime==BuffTriggerTime.addMyMate
or e.buffTriggerTime==BuffTriggerTime.removeMyMate then
local i=a[2]
local o=a[1]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local e=n:GetHeroWithProfession(e,o)
local e=#e
e=math.min(e,a[6])
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
if e<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
else
local t=o:GetFloors()
if e>t then
o:AddFloors(e-t)
elseif e<t then
o:ReduceFloors(t-e)
end
end
else
if e>0 then
local o=a[3]
local a={a[4],a[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a,e)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

