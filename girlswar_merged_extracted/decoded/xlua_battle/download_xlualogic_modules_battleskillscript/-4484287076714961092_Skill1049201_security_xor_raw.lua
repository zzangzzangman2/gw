local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=e[1]
local i=t.HeroBattleInfo:GetBuff(30104907)
if i==nil then
local i=e[3]
local o=e[4]
local e=e[5]
a:CheckAddBuff(i,t,o,e)
else
local n=e[3]
local i=e[6]
local o=e[7]
local e={e[8],e[9]}
a:CheckAddBuff(n,t,i,o,e)
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local i=RandomTableWithSeed(i,e[10])
for a=1,#i do
local a=i[a]
local o=e[11]
local i=e[12]
local e={e[13]}
a:AddBuff(t,o,i,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
t:FuryHealth(FuryHealthType.Attack)
end
return s 
