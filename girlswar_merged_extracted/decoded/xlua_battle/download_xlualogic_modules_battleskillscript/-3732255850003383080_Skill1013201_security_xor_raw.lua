local e={}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[3]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
local a=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
t:HpHealthWithNormalSkill(e,a*i*MillionCoe,false,EBattleSrcType.SkillSmall)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i

