local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
t:ReduceFury(i.costMp)
local r=e[1]
local o=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,o,n,s)
local o=e[7]
local n=e[8]
local s={e[9],e[10]}
t:AddBuff(t,o,n,s)
local h=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
local o={}
table.insert(o,{count=e[11],rate=e[12]})
table.insert(o,{count=e[13],rate=e[14]})
table.insert(o,{count=e[15],rate=e[16]})
local s=0
local n=0
local d=RandomMgr:GetBattleRandom()
for e=1,#o do
n=n+o[e].rate
if(n>=d)then
s=o[e].count
break
end
end
local o={}
if#h>0 then
o=RandomTableWithSeed(h,s)
end
local n=t:GetFinalAtk()
local s=math.floor(n*e[17]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local n={}
table.insert(n,a.HeroId)
local h=#o
for e=1,h do
local e=o[e]
table.insert(n,e.HeroId)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,0,nil,s)
end
t:SetLastBigSkillTargetHeroIds(n)
local n=302107826
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.StartAttackWithBigSkill(o)
end
local o=e[18]
local n=e[19]
local e={e[20],e[21],e[22],e[23]}
t:AddBuff(t,o,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r,nil,s)
return nil
end
return d

