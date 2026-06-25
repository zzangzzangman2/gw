local i=require("Modules/Battle/BattleUtil")
local h=require("Modules/BattleSkillScript/21088/Skill21088Util")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,s,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl.HeroId
if t==s.HeroId then
if a.CheckCondition(e,o)then
local t=e.CurrHeroCtrl.HeroId
local a=21088304
local e={
buffId=e.buffId,
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
skillParams=o,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
i:AddTriggerAttackTask(t,a,e,n)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(t,e)
local a=e[11]
if e[12]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[12]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[13]=0
end
if e[13]>=a then
return false
end
if h.HasAllMusicBuff(t.CurrHeroCtrl)==false then
return false
end
return true
end
function t.HandleOnDoAction(t,e,o)
if a.CheckCondition(t,e)==false then
return false
end
e[13]=e[13]+1
return true
end
return a

