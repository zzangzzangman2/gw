local e={}
local i=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local i=e[1]
local a=e[3]
local r=e[4]
local d={e[5]}
local s=e[6]
local h=e[7]
local n={e[8]}
t:AddBuff(t,a,r,d)
t:AddBuff(t,s,h,n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,i)
end
end
if(e[9]>=RandomMgr:GetBattleRandom())then
local t=t.HeroBattleInfo:GetBuff(e[10])
if(t)then
t:AddFloors(e[11])
end
end
return nil
end
return i

