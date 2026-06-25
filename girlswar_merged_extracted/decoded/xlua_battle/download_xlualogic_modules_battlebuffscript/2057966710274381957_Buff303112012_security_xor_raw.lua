local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,a,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if a.teamId~=e.CurrHeroCtrl:GetTeamId()
and a.triggerSkillType==AttackType.BigSkill
and o:IsNormalSkillAtkType(a.triggerSkillAtkType)then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eMaxHpPercentWithCount,1)
if(i==nil)then
return nil
end
local i=i[1]
if(i==nil or i.HeroId~=a.heroId)then
return nil
end
if(t[9]>=RandomMgr:GetBattleRandom())then
if t[14]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[14]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[13]=0
end
if t[13]>=t[10]then
return
end
local i=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,i)
if n==nil then
o:AddTriggerAttackTask(i,t,e,a)
end
end
end
elseif n.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=303112003
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for a=1,#e do
local e=e[a]
i.AddBuffAlert(o,e,t[11],t[12])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionSmallSkill(t,e)
local e=t:GetBuffData()
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[5]
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
function a.HandleOnDoAction(t,e,t)
if e[14]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[14]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[13]=0
end
if e[13]>=e[10]then
return false
end
e[13]=e[13]+1
return true
end
return s

