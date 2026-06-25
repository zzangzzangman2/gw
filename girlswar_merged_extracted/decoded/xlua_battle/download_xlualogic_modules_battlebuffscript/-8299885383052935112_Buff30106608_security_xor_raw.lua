local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,s,h,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[3]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[2]=0
end
local o=t[1]
t[2]=t[2]or 0
if(t[2]>=o)then
return nil
end
if e.CurrHeroCtrl:GetCanBigAttack(true)==false then
return nil
end
local t=false
local o=ETriggerSkillAtkType.Normal
if a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if e.CurrHeroCtrl:IsOnAttack()then
if i.HeroId~=e.CurrHeroCtrl.HeroId and i.IsOurHero==e.CurrHeroCtrl.IsOurHero then
t=true
o=ETriggerSkillAtkType.AsistAttack
end
end
elseif a.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if e.CurrHeroCtrl:IsOnAttack()==false then
if s.IsOurHero==e.CurrHeroCtrl.IsOurHero then
t=true
o=ETriggerSkillAtkType.FightBack
end
end
end
if t==true then
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local e={
buffId=e.buffId,
triggerSkillAtkType=o,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
n:AddTriggerAttackTask(t,a,e,h)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.HandleOnDoAction(a,e,t)
if t then
local t=e[1]
e[2]=e[2]or 0
if(e[2]>=t)then
return false
end
e[2]=e[2]+1
end
return true
end
return s

