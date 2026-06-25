local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,t,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroId
if a==t.HeroId then
local t=false
local t=302108406
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local a=302108413
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t or a then
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.BigSkillId
local e={
defHeroIds={o.HeroId},
buffId=e.buffId,
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
needResetBeforeAction=true,
costMpValue=0,
isExcuteFigthBack=false,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
n:AddTriggerAttackTask(a,t,e,i)
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
function t.HandleOnBeforeAction(e,t,s)
local a=e.CurrHeroCtrl.BigSkillId
local t=false
local i=0
local o=302108413
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
local o=o:GetBuffData()
if e.CurrHeroCtrl.SmallSkillId>0 and e.CurrHeroCtrl.HeroBattleInfo.CurrFury<o[6]and e.CurrHeroCtrl:GetCurIsSmallSkill()==false then
a=e.CurrHeroCtrl.SmallSkillId
t=true
end
end
if t==false then
local o=302108406
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
local o=o:GetBuffData()
if e.CurrHeroCtrl.HeroBattleInfo.CurrFury>=o[1]then
if e.CurrHeroCtrl:GetCanBigAttack(true,false)then
if e.CurrHeroCtrl:IsOnAttack()==false or ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)==false then
a=e.CurrHeroCtrl.BigSkillId
t=true
i=o[1]
end
end
if t==false then
if e.CurrHeroCtrl.HeroBattleInfo.CurrFury>=o[2]then
a=e.CurrHeroCtrl.SmallSkillId
t=true
i=o[2]
end
end
end
end
end
local e=n:ResetTriggerAttackTaskSkillDid(s,a)
e.costMpValue=i
e.isExcuteFigthBack=t
return e
end
function t.HandleOnDoAction(t,a,e)
if e.isExcuteFigthBack==false then
return false
end
if e.costMpValue>0 then
t.CurrHeroCtrl:ReduceFury(e.costMpValue)
end
return true
end
return s

