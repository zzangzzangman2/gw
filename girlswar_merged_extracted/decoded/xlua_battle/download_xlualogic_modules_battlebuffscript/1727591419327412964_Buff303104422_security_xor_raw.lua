local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local o=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoBeansActionSmallSkill(t,i,a)
local e=t:GetBuffData()
if a then
o.AddBuffGoodScore(t)
else
if e[25]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[25]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[24]=0
end
local a=e[16]
if e[24]<a then
e[24]=e[24]+1
local o=e[17]
local e=e[18]
local a={}
i:AddBuff(t.CurrHeroCtrl,o,e,a)
end
end
end
function t.AddBuffGoodScore(t)
local e=t:GetBuffData()
local i=e[10]
local o=e[11]
local a={}
for t=12,15 do
table.insert(a,e[t])
end
local e=e[9]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a,e)
end
function t.DoBeansActionBigSkill(e,a)
local t=e:GetBuffData()
local n=a
if a.HeroBattleInfo:HasControlBuff()then
local e=i:GetConCtrlHeroInTeam(a,1,false)
if#e>0 then
n=e[1]
end
end
local s=t[20]
local i=t[21]
local a={}
for e=22,23 do
table.insert(a,t[e])
end
table.insert(a,0)
local t=n:AddBuff(e.CurrHeroCtrl,s,i,a)
if t then
o.AddBuffGoodScore(e)
end
end
function t.AddAttackTask(t,n,o)
local e=t:GetBuffData()
if e[27]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[27]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[26]=0
end
local a=e[19]
if e[26]<a then
e[26]=e[26]+1
local a=t.CurrHeroCtrl.HeroId
local e=t.CurrHeroCtrl.SmallSkillId
if e>0 then
local t={
defHeroIds={o},
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if o==nil then
i:AddTriggerAttackTask(a,e,t,n)
end
end
end
end
return o

