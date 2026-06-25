local t=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
o.CheckAddDamageConvert(e)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
end
function e.DoAction(e,o,o,o,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a.triggerSkillAtkType
if t:IsDependAtkType(a)==false then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t then
local e=92490
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.RefreshAddDamageConvertPercent(t)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnDamageConvert(t,a)
local e=t:GetBuffData()
local o={
totalHurtValue=a,
round=e[2],
leftPercent=OneMillion,
}
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t.releaseHeroId)
if a then
local i=92490
local a=a.HeroBattleInfo:GetBuff(i)
if a then
local e=a:GetBuffData()
e[15]=e[15]or{}
table.insert(e[15],o)
end
local i=e[3]
local o=e[4]
local a={}
for o=5,8 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
end
end
function e.CheckAddDamageConvert(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
local t=t[1]
if t>0 then
local t={
buffId=e.buffId,
reduceHpConvertRate=t,
damageResHeroId=e.CurrHeroCtrl.HeroId,
}
e.CurrHeroCtrl:AddDamageConvertData(t)
end
end
return o

