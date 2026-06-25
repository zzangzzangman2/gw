local d=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(s.costMp)
local n=e[1]
local h=#a
for a=3,14,2 do
if h<=e[a]then
n=n+e[a+1]
break
end
end
t.HeroBattleInfo:DispelAllGranBuff(false)
local r={}
local l={1,2,3,4,5}
local o=302107314
local i=t.HeroBattleInfo:GetBuff(o)
local o=e[15]
if i then
local e=i:GetBuffData()
o=o+e[2]
end
local o=RandomTableWithSeed(l,o)
for i=1,#o do
local o=o[i]
if o==1 then
local i=e[16]
local o=e[17]
local n=e[18]
local s=0
local e={}
for t=1,#a do
table.insert(e,a[t])
a[t].HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
local e=RandomTableWithSeed(e,1)
for a=1,#e do
e[a]:CheckAddBuff(i,t,o,n,s)
end
elseif o==2 then
local o={}
for e=1,#a do
table.insert(o,a[e])
end
local a=RandomTableWithSeed(o,e[19])
for o=1,#a do
local n=e[20]
local i=e[21]
local e={e[22],e[23],e[24],e[25]}
a[o]:AddBuff(t,n,i,e)
end
elseif o==3 then
local o={}
for e=1,#a do
table.insert(o,a[e])
end
local a=RandomTableWithSeed(o,e[26])
for o=1,#a do
ModulesInit.ProcedureNormalBattle.StealFury(t,a[o],e[27],EBattleSrcType.SkillBig)
end
elseif o==4 then
local t={}
for e=1,#a do
table.insert(t,a[e])
end
local e=RandomTableWithSeed(t,e[28])
for t=1,#e do
local e=e[t].HeroId
r[e]=true
end
elseif o==5 then
local o={}
for e=1,#a do
table.insert(o,a[e])
end
local a=RandomTableWithSeed(o,e[30])
for o=1,#a do
local a=a[o]
local o=math.floor(a:GetFinalAtk()*e[31]*MillionCoe)
local i=math.floor(a:GetFinalDef()*e[31]*MillionCoe)
local a=e[32]
local e=e[33]
local o={o,i}
t:AddBuff(t,a,e,o)
end
end
end
local o=302107313
local o=t.HeroBattleInfo:GetBuff(o)
if o then
if t:GetSkillUseCount(t.BigSkillId)<=0 then
local a=302107317
local o=1
local e=0
t:AddBuff(t,a,o,e)
end
end
for o=1,h do
local a=a[o]
local o=n
if r[a.HeroId]then
o=o+e[29]
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,o)
local o=o[3]
local o=o.reduceHpValue
local e=e[34]
if i then
local t=i:GetBuffData()
e=t[1]
end
local e=math.floor(o*e*MillionCoe)
d:AddSepsisHp(t,a,e)
end
return nil
end
return u

