local e=require("DataNode/DataTable/Create/maps/DTMapsDBModel")
local t=require("Modules/Battle/BattleBeforeData/BattleBeforeDataUtil")
local c=require("DataNode/DataManager/DataMgr/DataUtil")
local s={
battleType=BattleType.campaign
}
function s:GetFightSuppressRatio(a)
local t=0
local e=e.GetEntity(a)
if(e.suppress==1)then
t=PlayerMgr.PlayerInfo.level-e.proposalLv
end
return t
end
function s:GetBattleBeforeData(s,u,e)
local o=PlayerMgr.PlayerInfo
local a=HeroMgr.heros
local m=PlayerMgr.battleDataType
local h=ModulesInit.FormationManager:GetCurEmbattleByFormationNO(PROTO_ENUM.FormationNO.FN_MAIN)
local i=ModulesInit.FormationManager:GetCurEmbattleByFormationNO(PROTO_ENUM.FormationNO.FN_MAIN_ALTER)
local n,r=t:GetHeroListByFormation(h,i,a,o,self.battleType)
local a={}
local d={}
local l={}
if e then
h=e.ourTeamFormation
i=e.ourTeamFormationAlter
n=e.ourHeros
r=e.ourFirstValue
a=e.ourPets
d=e.ourPetHeroAttrs
l=e.ourourPetAttrsPets
else
a=t:GetBattlePetList()
end
t:AddAtkBuff(self.battleType,n)
local d={}
local l=0
local a=c.GetMapsWave(s,self.battleType)
for e=1,#a do
local o=a[e].monsterLists
local i=a[e].id
local r,s,o,i,n=t:GetFormationFromMonsterList(self.battleType,o,u,i)
local a=a[e].monsterEffect
local n=a[4]
local n,h=t:GetPetTestAttr(n)
local t=t:GetTestPetList(a)
if e==1 then
l=i
end
local e={
waveNo=e,
enemyTeamFormation=r,
enemyTeamFormationAlter=s,
enemyHeros=o,
bigRoundData={},
heroStatistics={},
enemyPets=t,
enemyPetHeroAttrs=h,
enemyPetAttrs=n,
}
table.insert(d,e)
end
local t=self:GetFightSuppressRatio(s)
local t={
relics={},
dicePosition=0,
attribute={},
suppressRatio=t,
playerLevel=o.level,
officer=o.officer,
accType=m,
}
local e={
errorCode=0,
battleType=self.battleType,
mapId=s,
randomSeed=math.random(0,1000),
ourTeamFormation=h,
ourTeamFormationAlter=i,
ourHeros=n,
waveData=d,
ourPlayerId=o.playerId,
ourFirstValue=r,
ourExt=t,
enemyPlayerId=0,
enemyFirstValue=l,
enemyExt={},
fightResult=0,
mvpHeroDid=0,
transId=0,
randomNumbers={},
ourPets=e.ourPets,
ourPetHeroAttrs=e.ourPetHeroAttrs,
ourPetAttrs=e.ourPetAttrs,
}
return e
end
return s 
