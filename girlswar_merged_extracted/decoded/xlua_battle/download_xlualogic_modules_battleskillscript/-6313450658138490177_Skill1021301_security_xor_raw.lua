local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local o=t[1]
local s=t[3]
local n=t[4]
local i={t[5]}
e:AddBuff(e,s,n,i)
local i=t[6]
local n=t[7]
local t={t[8]}
e:AddBuff(e,i,n,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
return nil
end
return s 
