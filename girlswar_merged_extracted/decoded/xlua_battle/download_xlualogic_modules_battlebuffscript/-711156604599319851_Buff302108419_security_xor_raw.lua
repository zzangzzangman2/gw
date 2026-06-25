local i=require("Modules/Battle/Formula")
local h=require("Modules/Battle/BattleUtil")
local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionBigSkill(t,s)
local e=t:GetBuffData()
local a=e[1]
local o=e[2]
local n={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,n)
local a=e[5]
local n=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,o)
local o=e[9]
local n=e[10]
local a={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,a)
local n=e[13]
local o=e[14]
local a={e[15],e[16]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,o,a)
local o=e[17]
local n=e[18]
local a={e[19],e[20]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,a)
local o=false
local a=0
local n=i:CalculateHeroAttackCriticalRate(t.CurrHeroCtrl)
local n=n.attackCriticalRate
local i=i:CalculateHeroAttackCriticalResRate(s)
local i=i.defFinalCriticalResRate
local i=n*OneMillion-i*OneMillion
if(i>e[21])then
o=true
a=e[22]
local a=math.floor((i-e[21])*e[23]*MillionCoe)
local o={
attrId=HeroAttrId.criticalStrengthRateAdd,
value=a,
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(o)
if a>e[24]then
t.CurrHeroCtrl:AddMustCritValueInCurAttack()
end
end
return o,a
end
function a.AddPursuitAttack(e,a)
local t=e:GetBuffData()
local o=math.floor(a*t[25]*MillionCoe)
local a=e.CurrHeroCtrl.HeroId
local t=21084102
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
realhurt=o,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
h:AddTriggerAttackTask(a,t,e,o)
end
end
return r

