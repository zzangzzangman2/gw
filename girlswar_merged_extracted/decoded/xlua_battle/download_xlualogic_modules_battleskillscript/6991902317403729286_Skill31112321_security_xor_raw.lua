local e=require("Modules/Battle/BattleUtil")
local r=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local l=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(s.costMp)
e:RemoveOneBeans()
local l=t[1]
local n=t[3]
local h=t[4]
local i=nil
local a={}
local d=#o
for e=1,d do
local e=o[e]
local t=e.HeroBattleInfo:GetBuff(n)
if t then
i=e
t:SetRound(h)
a={}
break
else
table.insert(a,e)
end
end
if i==nil then
local a=RandomTableWithSeed(a,1)
local o=a[1]
if o then
i=o
local a={t[5],t[6]}
local i=303111210
local i=e.HeroBattleInfo:GetBuff(i)
if(i)then
local t=i:GetBuffData()
for e=5,7 do
table.insert(a,t[e])
end
local o=math.floor(e.HeroBattleInfo.MaxHP*t[8]*MillionCoe)
local e=e:GetFinalAtk()
local e=math.floor(e*t[9]*MillionCoe)
local e=math.min(o,e)
table.insert(a,e)
end
o:AddBuff(e,n,h,a)
local s=303111220
local i=-1
local a=r.GetDefaultHpChainData()
a.assumedamagePercent=t[7]
a.reduceDamagePercent=0
a.minHpPercent=0
a.defHeroId=o.HeroId
a.defBuffId=n
local t={a}
e:AddBuff(e,s,i,t)
end
end
local a=table.lightCopyList(o)
local a=RandomTableWithSeed(a,1)
local n=a[1]
if n then
local o=t[8]
local a=t[9]
local i={t[10],t[11]}
n:AddBuff(e,o,a,i)
local i=303111221
local s=-1
local a=r.GetDefaultHpChainData()
a.assumedamagePercent=t[12]
a.reduceDamagePercent=0
a.minHpPercent=0
a.defHeroId=n.HeroId
a.defBuffId=o
local t={a}
e:AddBuff(e,i,s,t)
end
if i then
ModulesInit.ProcedureNormalBattle.StealFury(e,i,t[13],EBattleSrcType.SkillBig)
end
if n then
ModulesInit.ProcedureNormalBattle.StealFury(e,n,t[14],EBattleSrcType.SkillBig)
end
for t=1,d do
local a=o[t]
local t=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,s,l,0,t)
end
return nil
end
return l

