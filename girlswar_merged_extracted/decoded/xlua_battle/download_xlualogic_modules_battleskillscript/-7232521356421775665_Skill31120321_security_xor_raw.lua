local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
e:ReduceFury(o.costMp)
e:RemoveOneBeans()
local h=t[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=303112003
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local a=table.lightCopyList(a)
local a=RandomTableWithSeed(a,t[3])
for e=1,#a do
o.AddBuffFragileAlliance(i,a[e])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAllExcludeSelf)
local a=RandomTableWithSeed(a,t[6])
table.insert(a,e)
for e=1,#a do
o.AddBuffAlert(i,a[e],nil,t[7])
end
end
local i=303112001
local i,n=s:GetHeroNoBuffByType(e,BattleHeroType.enemyAll,i)
local i=#n
if(t[8]>=RandomMgr:GetBattleRandom())then
if i>1 then
local e=RandomTableWithSeed(n,1)
local e=e[1]
local t=RandomTableWithSeed(n,1)
local a=t[1]
if e and a then
local t=e.HeroBattleInfo:GetGranBuff(false)
local t=t[1]
if t then
s:AddBuffByBuffInfo(a,e,t)
end
end
end
end
local n=a[1]
if n then
local i=t[9]
local o=t[10]
local a={t[11]}
local t=math.floor(e.HeroBattleInfo.MaxHP*t[12]*MillionCoe)
table.insert(a,t)
n:AddBuff(e,i,o,a)
end
local s=math.floor(e.HeroBattleInfo.MaxHP*t[5]*MillionCoe)
local n=#a
for n=1,n do
local n=a[n]
local a=0
if i>0 then
a=math.floor(n.HeroBattleInfo.CurrHP*i*t[4]*MillionCoe)
a=math.min(a,s)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,n,o,h,0,a)
end
return nil
end
return h

