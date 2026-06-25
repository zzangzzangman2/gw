local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,a,n)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.CurrHeroCtrl:IsOnAttack()then
return
end
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(30106417)
if a==nil then
return
end
local a=e[2]
e[5]=e[5]or 0
if(e[5]>=a)then
return nil
end
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[3]=0
end
local a=e[1]
e[3]=e[3]or 0
if(e[3]>=a)then
return nil
end
e[3]=e[3]+1
local e=t.CurrHeroCtrl.HeroId
local a=t.CurrHeroCtrl.BigSkillId
local s={}
local t={
defHeroIds={i.HeroId},
costMp=false,
buffId=t.buffId,
isFightBack=true,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,e)
if i==nil then
o:AddTriggerAttackTask(e,a,t,n)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.sufferSkillDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.HandleOnDoAction(a,e,t)
if t and t.skillData and t.skillData.isFightBack then
local t=e[2]
e[5]=e[5]or 0
if(e[5]>=t)then
return false
end
e[5]=e[5]+1
end
return true
end
return s

