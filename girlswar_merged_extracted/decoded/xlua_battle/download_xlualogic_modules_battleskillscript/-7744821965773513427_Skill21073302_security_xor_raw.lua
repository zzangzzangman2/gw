local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(n.costMp)
local i=e[1]
local s=#a
for a=3,14,2 do
if s<=e[a]then
i=i+e[a+1]
break
end
end
t.HeroBattleInfo:DispelAllGranBuff(false)
local r={}
local d={1,2,3,4,5}
local o=302107314
local h=t.HeroBattleInfo:GetBuff(o)
local o=e[15]
if h then
local e=h:GetBuffData()
o=o+e[2]
end
local o=RandomTableWithSeed(d,o)
for i=1,#o do
local o=o[i]
if o==1 then
local n=e[16]
local i=e[17]
local s=e[18]
local h=0
local o={}
for e=1,#a do
table.insert(o,a[e])
a[e].HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
local e=RandomTableWithSeed(o,1)
for a=1,#e do
e[a]:CheckAddBuff(n,t,i,s,h)
end
elseif o==2 then
local o={}
for e=1,#a do
table.insert(o,a[e])
end
local a=RandomTableWithSeed(o,e[19])
for o=1,#a do
local i=e[20]
local n=e[21]
local e={e[22],e[23],e[24],e[25]}
a[o]:AddBuff(t,i,n,e)
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
local a=math.floor(a:GetFinalDef()*e[31]*MillionCoe)
local i=e[32]
local e=e[33]
local a={o,a}
t:AddBuff(t,i,e,a)
end
end
end
local o=302107313
local o=t.HeroBattleInfo:GetBuff(o)
if o then
if t:GetSkillUseCount(t.BigSkillId)<=0 then
local o=302107317
local a=1
local e=0
t:AddBuff(t,o,a,e)
end
end
for o=1,s do
local o=a[o]
local a=i
if r[o.HeroId]then
a=a+e[29]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,a)
end
return nil
end
return l

