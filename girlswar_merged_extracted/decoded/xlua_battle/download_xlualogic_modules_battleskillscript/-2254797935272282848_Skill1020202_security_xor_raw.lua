local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHp)
if(a==nil)then
return nil
end
local h=t[1]
local r=t[3]
local s=t[4]
local n=t[5]
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30102003)
local t=i.GetBuffValue(e,t)
a:CheckAddBuff(r,e,s,n,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
