local o=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function t.GetCanTrigger(e)
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(e)
local t=e:GetBuffData()
local i=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(i*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(i,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
if a.CheckActionSmallSkill(e)then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.BigSkillId
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
o:AddTriggerAttackTask(t,e,a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal,triggerSkillType=AttackType.SmallSkill})
end
end
end
function t.CheckActionSmallSkill(e)
local t=e:GetBuffData()
if e.CurrHeroCtrl:IsFullFury()then
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(302107424)
if e then
local e=e:GetFloors()
if e>=t[3]then
return true
end
end
end
return false
end
return a

