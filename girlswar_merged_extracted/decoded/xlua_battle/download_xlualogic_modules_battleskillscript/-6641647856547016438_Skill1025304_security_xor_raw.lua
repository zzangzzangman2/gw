local e={}
local n=e
function e.DoAction(e,a,o)
local i=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local t
if o~=nil then
t=o[1]
end
if t==nil then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
end
if(t==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local o=i[1]
local n=e.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
local o=o
local s=t.HeroBattleInfo:GetAttrValue(HeroAttrId.atk)
if n>s then
o=o+i[3]
end
e.IgnoreBlock=true
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e.IgnoreBlock=false
return nil
end
return n

