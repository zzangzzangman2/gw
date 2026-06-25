local n=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(e,t)
local o=e:JudgeSkillPreView(t)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=o[1]
local s=e:GetFinalAtk()
local o=math.floor(s*o[3]*MillionCoe)
n:HpHealthWithSmallSkillAndParam(e,t.skilltype,o)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,t,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

