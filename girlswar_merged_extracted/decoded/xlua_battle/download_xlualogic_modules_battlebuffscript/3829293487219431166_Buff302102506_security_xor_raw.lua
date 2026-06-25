local h=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,n,t,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if ModulesInit.ProcedureNormalBattle.BattleRounding==false then
return
end
if i.CheckCondition(e,a.buffTriggerTime)==false then
return nil
end
if t.HeroId==e.CurrHeroCtrl.HeroId then
return nil
end
local t={
fury=t.HeroBattleInfo.CurrFury,
atk=t:GetFinalAtk()
}
i.TriggerInheritAction(e,o,t,ETriggerSkillAtkType.FightBack)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.teamHeroFatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(t,e)
local a=302102509
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
if e==BuffTriggerTime.teamHeroFatalDmgBefore then
return true
end
else
if e==BuffTriggerTime.teamHeroDead then
return true
end
end
return false
end
function t.TriggerInheritAction(e,t,i,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[7]
local o=302102509
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
local e=o:GetBuffData()
a=a+e[7]
end
t[13]=t[13]or 0
if(t[13]>=a)then
return nil
end
t[13]=t[13]+1
local r=e.CurrHeroCtrl.HeroBattleInfo.CurrFury
local a=math.floor(i.fury*t[1]*MillionCoe)
e.CurrHeroCtrl:AddFuryWithBuff(a)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
local a=e.CurrHeroCtrl.HeroId
local o=e.CurrHeroCtrl.SmallSkillId
local s={
buffId=e.buffId,
triggerSkillAtkType=n,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if n==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
h:AddTriggerAttackTask(a,o,s,e)
end
if r>=t[2]then
local o=e.CurrHeroCtrl:GetFinalAtk()
local a=0
if ModulesInit.ProcedureNormalBattle.IsPVE()and t[6]==0 then
a=math.floor(o*t[5]*MillionCoe)
else
local e=i.atk
local e=math.max(o,e)
a=math.floor(e*t[5]*MillionCoe)
end
local o=t[3]
local n=t[4]
local t={HeroAttrId.atkAdd,a}
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
local i=i:GetBuffData()
t={HeroAttrId.atkAdd,i[2]+a}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,o,n,t)
else
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,t)
end
end
local o=t[8]
local a=t[9]
local i={t[10],t[11]}
local t=t[12]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,o,a,i,1,t)
end
return i

