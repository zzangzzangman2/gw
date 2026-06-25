local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i,e,e)
local a=t:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local s=a[1]
local n=e.HeroBattleInfo:GetCurrHP()
local o=e.HeroBattleInfo.MaxHP
local n=o-n
local o=math.floor(n/o*OneMillion/a[3])
local a={
attrId=a[4],
value=math.min(a[5]*o,a[6]),
}
t:AddAttrValueInCurAttack(a)
local a=303111115
local o=t.HeroBattleInfo:GetBuff(a)
if(o)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.DoBeansActionSmallSkill(o,e)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
