local e=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local i=a[1]
e:AddFuryWithSkill(a[3])
local n=t.HeroBattleInfo:GetMaxHP()
local a=math.floor(n*a[4]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i,0,a)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

