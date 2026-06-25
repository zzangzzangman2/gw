local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i,e,a)
local e=t:JudgeSkillPreView(i)
e=a
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
t:RemoveOneBeans()
local o=0
local s=303111311
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
o=e.DoActionSmallSkill(n,a)
end
local r=e[10]
local n=t:GetFinalAtk()
o=o+math.floor(n*e[11]*MillionCoe)
local s=RandomMgr:GetBattleRandomWithRange(e[12],e[13])
local n=table.lightCopyList(a)
local n=RandomTableWithSeed(n,s)
local d=e[3]
local s=e[4]
local h={e[5],e[6],e[7],e[8]}
for e=1,#n do
local e=n[e]
e:AddBuff(t,d,s,h)
end
local s=303111308
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddBuffFloatGuardAllMate(n)
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
for a=1,#n do
local o=e[22]
local i=e[23]
local e={e[24],e[25]}
n[a]:AddBuff(t,o,i,e)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r,0,o)
end
return nil
end
return h 
