local e={}
local h=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(e==nil)then
return
end
local i=#e
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,o[5],e)
end
t:ReduceFury(a.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=o[1]
local s=t.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
local i=#e
for i=1,i do
local i=e[i]
local e=n
local n=i.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
if s>n then
e=e+o[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,a,e)
end
return nil
end
return h

