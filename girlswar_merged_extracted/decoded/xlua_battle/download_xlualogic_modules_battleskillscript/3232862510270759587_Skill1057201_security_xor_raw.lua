local e=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=e[1]
if(a.profession==e[3])then
o=o+e[4]
end
local n=e[5]
local s=e[6]
local h={e[7],e[8]}
local e=e[9]
t:AddBuffWithMaxFloor(t,n,s,h,1,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

