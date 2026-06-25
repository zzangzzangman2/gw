local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
a:ReduceFuryWithSkill(t[3],e,EBattleSrcType.SkillBig,true)
local n=t[5]
local s=t[6]
a:CheckAddBuff(t[4],e,n,s,0)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
return nil
end
return s 
