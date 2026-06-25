local s=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill(t,o,h)
local e=t:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fMostDebuff,nil,nil,nil,nil,{isExludeSelf=false})
if a~=nil then
a.HeroBattleInfo:DispelAllGranBuff(false)
end
local a={}
table.appendList(a,o)
local a=RandomTableWithSeed(a,1)
for o=1,#a do
local a=a[o]
local o=e[1]
local i=e[2]
local e={e[3],e[4],e[5],e[6]}
a:AddBuff(t.CurrHeroCtrl,o,i,e,1)
end
local o=302108213
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local n=o.GetShareDamgeValue(a)
local i=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
if n>=i*e[7]*MillionCoe then
o.ClearShareDamgeValue(a)
local o=t.CurrHeroCtrl.HeroId
local a=21082304
local e={
costMp=false,
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillHurtRate=e[8],
realHurtRate=e[9],
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if t==nil then
local t={
triggerSkillAtkType=h
}
s:AddTriggerAttackTask(o,a,e,t)
end
end
end
end
return r

