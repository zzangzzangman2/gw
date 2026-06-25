local e={}
local s=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=o[1]
local s=e.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
local i=#t
for i=1,i do
local i=t[i]
local t=n
local n=i.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
if s>n then
t=t+o[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,a,t)
end
return nil
end
return s

