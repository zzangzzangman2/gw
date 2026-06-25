local e={}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(a and#a==1)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[12])
end
t:ReduceFury(o.costMp)
local i=e[1]
local d=e[3]
local l=e[4]
local h={e[5]}
local r=e[6]
local s=e[7]
local n={e[8]}
t:AddBuff(t,d,l,h)
t:AddBuff(t,r,s,n)
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
return s

