local n=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,s,o,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if t[2]>0 and o.teamId==e.CurrHeroCtrl:GetTeamId()and o.triggerSkillType==AttackType.BigSkill then
local o=false
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#a do
local e=a[e]
local e=e:CurrHPPer()
if e<t[1]*MillionCoe then
o=true
break
end
end
if o==true then
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
end
end
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
if a.CheckBaseCondition(e,t)==false then
return false
end
if e.CurrHeroCtrl:IsOnAttack()==false then
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if i==nil then
n:AddTriggerAttackTask(t,a,e,o)
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(e,t)
if a.CheckBaseCondition(e,t)==false then
return false
end
if e.CurrHeroCtrl:IsFullFury()==false then
return false
end
return true
end
function t.CheckBaseCondition(o,e)
local a=e[7]
local t=302108317
local t=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local e=t:GetBuffData()
a=e[16]
end
if e[9]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[8]=0
end
if e[8]<a then
return true
else
return false
end
end
function t.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
e[8]=e[8]+1
local a=e[4]
local i=e[5]
local n={e[6],1}
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.AddCount(o,1)
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,n)
end
e[2]=e[2]-e[3]
e[2]=math.max(0,e[2])
return true
end
return a

