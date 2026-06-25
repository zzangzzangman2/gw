local e=require("Modules/Battle/BattleUtil")
local u=require("Modules/Battle/Formula")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
o.AddBuffIce(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>1 then
o.AddBuffIce(e,t)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
local a=302104817
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
o.AddBuffIce(e,t,-1,true)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffIce(a,e,n,o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local i=e[11]
local s=e[12]
if n~=nil then
s=n
end
local l={e[13],e[14],e[15],e[16],e[21],e[22]}
local r={}
local h=false
local n=e[20]
if#t<n and o~=true then
table.insert(t,a.CurrHeroCtrl)
h=true
end
if o then
for e=1,#t do
local a=t[e].HeroId
t[e].HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
local d=RandomTableWithSeed(t,n)
local n=0
for e=1,#d do
local e=d[e]
r[e.HeroId]=true
local t=u:GetInjureResData(e)
if t.defFinalInjureResRate>n then
n=t.defFinalInjureResRate
end
e:AddBuff(a.CurrHeroCtrl,i,s,l)
end
if h==false and o~=true then
local i=math.floor(n*e[19])
local t=e[17]
local o=e[18]
local e={HeroAttrId.injureResRateAdd,i}
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,t,o,e)
end
for e=1,#t do
local a=t[e].HeroId
if r[a]~=true then
t[e].HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
end
return o

