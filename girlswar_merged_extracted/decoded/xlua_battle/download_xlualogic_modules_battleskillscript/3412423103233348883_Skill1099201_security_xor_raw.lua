local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=t[1]
local n=t[3]
local s=t[4]
local t=t[5]
a:CheckAddBuff(n,e,s,t,0)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

