local e={
}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
local l=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if#a<e[3]then
table.insert(a,t)
end
local a=RandomTableWithSeed(a,e[3])
for o=1,#a do
local a=a[o]
local o=e[4]
local i=e[5]
local e={e[6],e[7]}
a:AddBuff(t,o,i,e)
end
local a=e[8]
local h=e[9]
local d={e[10],e[11]}
local r=1
local n=true
local s=t.HeroBattleInfo:GetBuff(a)
if s then
local t=s:GetFloors()
if t>=e[12]then
n=false
end
end
if n then
t:AddBuff(t,a,h,d,r)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,l)
t:FuryHealth(FuryHealthType.Attack)
end
return l 
