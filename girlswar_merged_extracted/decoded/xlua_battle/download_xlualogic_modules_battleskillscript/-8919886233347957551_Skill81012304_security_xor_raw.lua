local e=require("Modules/Battle/BattleUtil")
local s={
}
local h=s
function s.DoAction(e,s,t)
local o=e:JudgeSkillPreView(s)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local r=o[1]
local n=0
local i=308101205
local a=e.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
n=e.ConsumeDragonDust(a)
end
local i=#t
local a={}
for e=1,i do
a[e]=0
end
if n>0 then
local e=table.lightCopyList(t)
for e=1,n do
local e=RandomMgr:GetBattleRandomWithRange(1,i)
if a[e]then
a[e]=a[e]+1
end
end
end
for i=1,i do
local n=t[i]
local a=a[i]
if a>0 then
local h=o[6]
local s=o[7]
local t={}
for e=8,12 do
table.insert(t,o[e])
end
local i=e:GetFinalAtk()
local o=math.floor(i*o[13]*MillionCoe)
table.insert(t,o)
table.insert(t,0)
n:AddBuff(e,h,s,t,a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,n,s,r)
end
return nil
end
function s.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[3]
local o=e[4]
local e={e[5]}
table.insert(e,0)
t:AddBuff(t,a,o,e)
return nil
end
return h 
