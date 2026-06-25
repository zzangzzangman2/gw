local e=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=a[1]
local i=e:GetFinalAtk()
local s=math.floor(i*a[4]*MillionCoe)
local i=#t
for i=1,i do
local i=t[i]
local t=i.HeroBattleInfo.CurrHP
local t=math.floor(t*a[3]*MillionCoe)
t=math.min(t,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,o,n,0,t)
end
local t=308200803
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddAttackTask(e)
end
return nil
end
function o.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[5]
local o=e[6]
local a={}
for o=7,11 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local o=e[12]
local i=e[13]
local a={}
for o=14,20 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return s 
