local e={}
local h=e
function e.DoAction(t,e)
local s=e.args[1]
local h=e.args[3]
local d=e.args[4]
local r={e.args[5]}
local n=e.args[6]
local o=e.args[7]
local a={e.args[8]}
local i=e.args[9]
t:ReduceFury(e.costMp)
t:AddBuff(t,h,d,r)
t:AddBuff(t,n,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=#a
for o=1,o do
local a=a[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,e,s)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a,1)
local o=#a
for o=1,o do
local a=a[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,e,i,1)
end
end
return nil
end
return h

