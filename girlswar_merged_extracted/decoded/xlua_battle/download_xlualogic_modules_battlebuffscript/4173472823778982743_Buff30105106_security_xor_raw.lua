local s=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return nil
end
if e.CurrHeroCtrl:IsOnAttack()==false then
if e.CurrHeroCtrl:IsFullFury()then
local n=e.CurrHeroCtrl.HeroId
local i=e.CurrHeroCtrl.BigSkillId
local h={}
local e={
defHeroIds={o.HeroId},
buffId=e.buffId,
isFightBack=true,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,n)
if o==nil then
s:AddTriggerAttackTask(n,i,e,a)
t[10]=false
end
end
end
if a.triggerSkillAtkType==ETriggerSkillAtkType.Normal then
if e.CurrHeroCtrl:GetLastIsSmallSkill()==false then
local i=e.CurrHeroCtrl.HeroId
local n=e.CurrHeroCtrl.SmallSkillId
local h={}
local o={
defHeroIds={o.HeroId},
buffId=e.buffId,
isFightBack=true,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,i)
if e==nil then
s:AddTriggerAttackTask(i,n,o,a)
t[10]=false
end
end
if(t[7]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[8]
a.value=t[9]
o.HeroBattleInfo:AddTempBuffValue(a)
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnFightBack(t,e)
local a=e[1]
local o=e[2]
local i={e[3],e[4],e[6]}
local e=e[5]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,o,i,1,e)
end
function t.HandleOnDoAction(a,t,e)
if e and e.skillData and e.skillData.isFightBack then
if(t[10]==true)then
return false
end
t[10]=true
end
return true
end
return h

