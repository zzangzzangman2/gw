local e={
}
local n=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local o=t[1]
local s=t[3]
local n=t[4]
local a={t[5]}
e:AddBuff(e,s,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
if(a.profession==ProfessionType.Mage)then
o=o+t[5]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
