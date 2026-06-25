local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,h,e,e)
local e=t:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=0
local i=303111910
local o=t.HeroBattleInfo:GetBuff(i)
if o then
local e=o:GetBuffData()
local t=t:GetFinalAtk()
s=math.floor(t*e[3]*MillionCoe)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill2(o)
end
local r=e[1]
local n=303111908
local n=t.HeroBattleInfo:GetBuff(n)
if n then
local a=n:GetFloors()
if a>0 then
local i=e[3]
local n=e[4]
local o={e[5],e[6]}
t:AddBuffWithFinalFloor(t,i,n,o,a)
local i=e[7]
local o=e[8]
local e={e[9],e[10]}
t:AddBuffWithFinalFloor(t,i,o,e,a)
end
end
local n=table.lightCopyList(a)
local n=RandomTableWithSeed(n,e[11])
for o=1,#n do
local i=e[13]
local a=e[14]
local s={s}
local e=e[12]
n[o]:AddBuff(t,i,a,s,e)
end
local e=#a
for e=1,e do
local e=a[e]
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.DoActionSmallSkill1(o,e)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,r)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
