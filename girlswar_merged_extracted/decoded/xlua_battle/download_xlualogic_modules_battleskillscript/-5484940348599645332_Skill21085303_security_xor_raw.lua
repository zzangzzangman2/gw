local e={}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local n=302108507
local a=t.HeroBattleInfo:GetBuff(n)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
if t.GetTaskHaloFloor(a)>=e[16]then
t.reduceTaskHaloFloor(a,e[16])
local e={cfgArgs=e}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,21085304,nil,nil,EBattleSkillType.SkillBig,e)
end
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(i.costMp)
local h=e[1]
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.GainTaskHalo(a,e[3])
end
local s=e[4]
local a=e[5]
local n={e[6],e[7]}
t:AddBuff(t,s,a,n)
local s=e[8]
local n=e[9]
local a={e[10],e[11]}
t:AddBuff(t,s,n,a)
local a=e[12]
local n=e[13]
local e={e[15],e[14]}
t:AddBuff(t,a,n,e)
local e=#o
for e=1,e do
local e=o[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h)
end
return nil
end
return h

