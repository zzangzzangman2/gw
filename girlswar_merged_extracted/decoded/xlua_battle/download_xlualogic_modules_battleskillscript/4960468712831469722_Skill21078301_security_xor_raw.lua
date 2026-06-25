local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
t:ReduceFury(i.costMp)
local d=e[1]
local o=e[3]
local s=e[4]
local n={e[5],e[6]}
t:AddBuff(t,o,s,n)
local s=e[7]
local o=e[8]
local n={e[9],e[10]}
t:AddBuff(t,s,o,n)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
local o={}
table.insert(o,{count=e[11],rate=e[12]})
table.insert(o,{count=e[13],rate=e[14]})
table.insert(o,{count=e[15],rate=e[16]})
local h=0
local n=0
local r=RandomMgr:GetBattleRandom()
for e=1,#o do
n=n+o[e].rate
if(n>=r)then
h=o[e].count
break
end
end
local o={}
if#s>0 then
o=RandomTableWithSeed(s,h)
end
local n=t:GetFinalAtk()
local n=math.floor(n*e[17]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local e={}
table.insert(e,a.HeroId)
local s=#o
for a=1,s do
local a=o[a]
table.insert(e,a.HeroId)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,0,nil,n)
end
t:SetLastBigSkillTargetHeroIds(e)
local e=302107826
local o=t.HeroBattleInfo:GetBuff(e)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.StartAttackWithBigSkill(o)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d,nil,n)
return nil
end
return l

