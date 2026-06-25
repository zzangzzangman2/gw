local n=require("DataNode/DataManager/DataMgr/DataUtil")
local m=require("DataNode/DataTable/Create/skillAct/DTBattleTestPetAttrDBModel")
local c=require("DataNode/DataTable/Create/skillAct/DTBattleTestPetDBModel")
local u=require("DataNode/DataTable/Create/skillAct/DTBattleTestTreasureDBModel")
local e={
}
function e:GetEmptyBattleBeforeData()
local e={
errorCode=0,
battleType=0,
mapId=0,
randomSeed=0,
ourTeamFormation={},
ourTeamFormationAlter={},
ourHeros={},
waveData={},
ourPlayerId=0,
ourFirstValue=0,
ourExt={},
enemyPlayerId=0,
enemyFirstValue=0,
enemyExt={},
fightResult=0,
mvpHeroDid=0,
transId=0,
randomNumbers={},
}
return e
end
function e:AddHeroDataFromFormation(d,t,a,i,s)
if t==nil then
return 0
end
local function h(t)
for e=1,#a do
local e=a[e]
if(e.heroId==t)then
return e
end
end
end
local a=0
local o=SkillMode.Normal
if s==BattleType.dragonWar then
o=SkillMode.DragonWar
end
for s=1,#t do
local t=t[s]
local t=h(t.heroId)
if t then
local r=e:GetAttrValue(t.attribute,HeroAttrId.hp)
local h=e:GetAttrValue(t.attribute,HeroAttrId.fury)
local s=e:GetAttrValue(t.attribute,HeroAttrId.armor)
local e=e:GetAttrValue(t.attribute,HeroAttrId.first)
a=a+e
local e=n:GetSoulIdWithLevelAndHeroDid(t.lockLevel,t.heroDid)
local e={
heroId=t.heroId,
heroDid=t.heroDid,
status=t.status,
attribute=t.attribute,
skills=t.skills,
underwearSuits=t.underwearSuits,
curHp=r,
curMp=h,
playerId=i.playerId,
rankLevel=t.rankLevel,
lockLevel=t.lockLevel,
pos=0,
skillMode=o,
teamNO=0,
enterBuffs={},
soulDid=e,
heroLevel=i.level,
curArmor=s,
treasures=t.treasures,
heroPet=t.heroFightPet,
symphonyDid=t.symphonyDid,
fight=t.fight,
}
table.insert(d,e)
end
end
return a
end
function e:GetAttrValue(e,t)
for a=1,#e do
local e=e[a]
if(e.id==t)then
return e.value
end
end
end
function e:GetHeroListByFormation(s,h,o,n,i)
local a={}
local t=0
local s=e:AddHeroDataFromFormation(a,s,o,n,i)
local e=e:AddHeroDataFromFormation(a,h,o,n,i)
t=t+s
t=t+e
return a,t
end
function e:GetBattlePetList()
local i={}
local e=SummonPetMgr.formation
table.sort(e,function(e,t)
return e.pos<t.pos
end)
for t=1,#e do
local t=e[t]
local e=SummonPetMgr:GetSummonPetById(t.petId)
if e then
local a=SummonPetMgr:IsMainStation(t.pos)
local n=SummonPetMgr:GetPetSkillDid(e.petDid,e.star,a)
local o=2
if a==ESummonPetPosType.Main then
o=1
end
local a={
skillDid=n,
skillType=o,
}
local e={
heroId=e.petId,
heroDid=e.petDid,
skills={a},
playerId=1,
heroLevel=e.level,
rankLevel=e.star,
pos=t.pos,
skillMode=1,
enterBuffs={},
}
table.insert(i,e)
end
end
return i
end
function e:GetCheckMonsterList(a)
local function o(t)
for e=1,6 do
if t[e]==nil or t[e]==0 then
return e
end
end
end
local t={}
for e=1,12 do
local a=a[e]or 0
if e<=6 then
t[e]=a
elseif e<=12 then
local o=o(t)
if o then
t[o]=a
else
t[e]=a
end
end
end
return t
end
function e:GetFormationFromMonsterList(t,a,f,o)
local h={}
local l={}
local r={}
local s=0
local i={}
local m=n.GetMonsterAttrCfgData(t)
local c=n.GetMonsterCfgData(t)
local a=e:GetCheckMonsterList(a)
local u=e:GetTreasureTestData(o)
for o=1,12 do
local t=math.floor((o-1)/6)+1
local d=-o
local a=a[o]or 0
local i={
formationId=t,
heroId=d,
heroDid=a,
position=(o-1)%6+1,
firstValue=0,
}
if a>0 then
if o<=6 then
table.insert(h,i)
else
table.insert(l,i)
end
end
if a>0 then
local n=m.GetEntity(a)
local t=c.GetEntity(a)
if t then
i.firstValue=n.first
s=i.firstValue+s
local i=e:GetMonsterAttrData(n)
local l=e:GetAttrValue(i,HeroAttrId.hp)
local m=e:GetAttrValue(i,HeroAttrId.fury)
local c=e:GetAttrValue(i,HeroAttrId.armor)
local e={}
local n={skillDid=t.monSkill1,skillType=SkillType.Act}
table.insert(e,n)
local n={skillDid=t.monSkill2,skillType=SkillType.Act}
table.insert(e,n)
local n={skillDid=t.monSkill3,skillType=SkillType.Act}
table.insert(e,n)
local n={skillDid=t.monSkill4,skillType=SkillType.Act}
table.insert(e,n)
local n=true
local h={}
local s=u[o]
local o=#t.monSkillPas
for a=1,o do
local t=t.monSkillPas[a]
if n==true then
if(t>0)then
local t={skillDid=t,skillType=SkillType.Pas}
table.insert(e,t)
elseif t==0 then
if f==true then
n=false
end
end
else
end
end
local e={
heroId=d,
heroDid=a,
status=2,
attribute=i,
skills=e,
underwearSuits=h,
curHp=l,
curMp=m,
playerId=0,
rankLevel=t.rankLevel,
lockLevel=t.lockLevel,
pos=0,
skillMode=t.skillMode,
teamNO=0,
enterBuffs={},
soulDid=t.soulDid,
heroLevel=t.monLevel,
curArmor=c,
treasures=s,
heroPet=1,
}
table.insert(r,e)
end
end
end
return h,l,r,s
end
function e:GetTestPetList(t)
local i={}
for e=1,#t do
if e<=3 then
local a=t[e]
local t=100+e
local e=c.GetEntity(a)
local a=SummonPetMgr:IsMainStation(t)
if e then
local n=SummonPetMgr:GetPetSkillDid(e.petId,e.star,a)
local o=2
if a==ESummonPetPosType.Main then
o=1
end
local a={
skillDid=n,
skillType=o,
}
local e={
heroId=-t,
heroDid=e.petId,
skills={a},
playerId=0,
heroLevel=1,
rankLevel=e.star,
pos=t,
skillMode=1;
enterBuffs={};
}
table.insert(i,e)
end
end
end
return i
end
function e:GetPetTestAttr(e)
local e=m.GetEntity(e)
local t={"petAtk","petCritical","petCriticalStrength","petInjure","petControl","petAtkFactor"}
local i={"petCriticalRes","petInjureRes","petControlRes","petCriticalStrengthRes","petDefFactor"}
local o={}
local a={}
if e then
for a=1,#t do
local t=t[a]
local e={
id=HeroAttrId[t],
value=e[t]
}
table.insert(o,e)
end
for t=1,#i do
local t=i[t]
local e={
id=HeroAttrId[t],
value=e[t]
}
table.insert(a,e)
end
end
return o,a
end
function e:GetTreasureTestData(e)
local o={}
local e=u.GetEntity(e)
for t=1,12 do
local a={}
table.insert(o,a)
if e then
local o=e["treasure"..t]
local t={}
for e=1,3 do
local e=o[e]
if e and t[e]==nil then
t[e]=true
else
e=0
end
local e={treasureId=0,treasureDid=e,level=1,breakLevel=0}
table.insert(a,e)
end
end
end
return o
end
function e:AddAtkBuff(a,o)
local e=ActMgr:CheckHeroBuffIsOpen()
local t=n:GetNewHeroBuffCfg(e)
if(t)then
local e=0
if(a==BattleType.campaign)then
e=t.idleAtkBuff
elseif(a==BattleType.elite)then
e=t.eliteBuff
elseif(a==BattleType.trial)then
e=t.towerAtkBuff
elseif(a==BattleType.thiefCrusade)then
e=t.crusadeAtkBuff
end
for a,t in ipairs(o)do
local e={buffId=99997,round=-1,overlap=1,args={e}}
table.add(t.enterBuffs,e)
end
end
end
function e:AddSuppressBuff(t,e)
if(e)then
for a,t in ipairs(t)do
local e={buffId=e[1],round=e[2],overlap=1,args={e[3],e[4]}}
table.add(t.enterBuffs,e)
end
end
end
function e:GetMonsterAttrData(t)
local e={}
for o,a in pairs(EAttrFlag2Id)do
local t=t[o]
if t then
local t={
id=a,
value=t,
}
table.insert(e,t)
end
end
return e
end
return e 
