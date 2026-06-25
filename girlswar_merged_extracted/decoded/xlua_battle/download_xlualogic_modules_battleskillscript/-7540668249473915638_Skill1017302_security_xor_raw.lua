local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local d=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a~=nil)then
local l=e[3]
local h=e[4]
local r={e[5]}
local s=e[6]
local n=e[7]
local i={e[8]}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for a,e in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,d)
e:AddBuff(t,l,h,r)
e:AddBuff(t,s,n,i)
end
end
local t=t.CurrBattleTeam:GetBeControlHeros()
if(t)then
t=RandomTableWithSeed(t,e[9])
for t,e in ipairs(t)do
e.HeroBattleInfo:RemoveControlBuff()
end
end
return nil
end
return r 
