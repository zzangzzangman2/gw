local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local h=t[1]
local s=t[3]
local n=t[4]
local i=t[5]
local o={t[6]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
t:ReduceFuryWithSkill(s,e,EBattleSrcType.SkillBig,true)
t:AddBuff(e,n,i,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
return nil
end
return n 
