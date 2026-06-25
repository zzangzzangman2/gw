local o=require("Modules/Battle/BattleUtil")
local e={}
local n=e
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
function e.AddSmallSkillTask(e,n)
local t=e:GetBuffData()
if t[2]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.SmallSkillId
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
o:AddTriggerAttackTask(t,a,i,n)
end
return nil
end
function e.AddBigSkillTask(e,n)
local t=e:GetBuffData()
if t[3]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.BigSkillId
local e={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if i==nil then
o:AddTriggerAttackTask(a,t,e,n)
end
return nil
end
function e.HandleOnDoAction(e,a,t)
if t then
if t.skillDid==e.CurrHeroCtrl.SmallSkillId then
a[2]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(43218,BuffRemoveType.Expire)
elseif t.skillDid==e.CurrHeroCtrl.BigSkillId then
a[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(43220,BuffRemoveType.Expire)
end
end
return true
end
return n

