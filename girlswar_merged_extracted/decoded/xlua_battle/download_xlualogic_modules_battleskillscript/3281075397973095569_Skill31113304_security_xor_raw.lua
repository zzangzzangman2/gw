local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,i,e,a)
local e=t:JudgeSkillPreView(i)
e=a
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
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
local n=RandomMgr:GetBattleRandomWithRange(e[12],e[13])
local s=table.lightCopyList(a)
local n=RandomTableWithSeed(s,n)
local h=e[3]
local s=e[4]
local e={e[5],e[6],e[7],e[8]}
for a=1,#n do
local a=n[a]
a:AddBuff(t,h,s,e)
end
local n=303111308
local e=t.HeroBattleInfo:GetBuff(n)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddBuffFloatGuardAllMate(e)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r,0,o)
end
return nil
end
return r 
