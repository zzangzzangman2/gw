local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,o,a,e)
local a=t:JudgeSkillPreView(o)
local e=e.cfgArgs
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local i=302108518
local n=t.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.SetTriggerBuff(n)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local i=302108507
local n=t.HeroBattleInfo:GetBuff(i)
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.GainTaskHalo(n,e[3])
end
local n=e[4]
local i=e[5]
local s={e[6],e[7]}
t:AddBuff(t,n,i,s)
local s=e[8]
local n=e[9]
local i={e[10],e[11]}
t:AddBuff(t,s,n,i)
local s=e[12]
local i=e[13]
local n={e[15],e[14]}
t:AddBuff(t,s,i,n)
local n=#a
local i=e[18]
for t=17,28,2 do
if n==e[t]then
i=e[t+1]
break
end
end
local n=#a
for n=1,n do
local a=a[n]
local n=0
if a.profession==ProfessionType.Tank then
local o=e[29]
local i=e[30]
local e={e[31],e[32]}
a:AddBuff(t,o,i,e)
elseif a.profession==ProfessionType.Mage then
local i=e[33]
local o=e[34]
local e={e[35],e[36],e[37],e[38]}
a:AddBuff(t,i,o,e)
elseif a.profession==ProfessionType.Warrior then
local n=e[39]
local i=e[40]
local o=t:GetFinalAtk()
local e=math.floor(o*e[41]*MillionCoe)
local e={e}
a:AddBuff(t,n,i,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
end
return nil
end
return s 
