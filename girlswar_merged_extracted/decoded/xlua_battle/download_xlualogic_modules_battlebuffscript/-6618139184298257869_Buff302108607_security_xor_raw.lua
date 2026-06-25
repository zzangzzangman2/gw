local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(e,t)
o:HideCampionEffect(e)
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e[2]
local i=e[4]
if t.CurrHeroCtrl:IsRealLastRowHero()then
a=math.floor(e[2]*e[5]*MillionCoe)
i=math.floor(e[4]*e[5]*MillionCoe)
end
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],a)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],i)
local a=ModulesInit.ProcedureNormalBattle.GetTeamFormation()
local a=a.enemyTeamFormation
local o=o:GetHeroCountByFormation(a)
local a=e[19]
if o>e[18]then
a=e[20]
end
local i=e[21]
local o=e[22]
local e={e[23],e[24]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,e,a)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o:ShowCampionEffect(t,nil,EBattleCampionPosType.EnemyTeamCenter,0,false)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local n=e[10]
local i=e[11]
local a={}
for t=12,17 do
table.insert(a,e[t])
end
for e=1,#o do
local e=o[e]
e:AddBuff(t.CurrHeroCtrl,n,i,a)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

