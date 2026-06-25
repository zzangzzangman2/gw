local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for i=1,#o do
local s=t[5]
local n=t[6]
local a={}
for e=7,12 do
table.insert(a,t[e])
end
local t=RandomMgr:GetBattleRandom()
table.insert(a,t)
o[i]:AddBuff(e.CurrHeroCtrl,s,n,a)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
n.AddBuffBabai(e,a[o],t[13])
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
local a=a[o]
local o=a.HeroBattleInfo.MaxHP
local t=math.floor(o*t[14]*MillionCoe)
i:ReduceSepsisHp(e.CurrHeroCtrl,a,t,true,true)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.HeroDead then
local t=t[16]
local a=e.CurrHeroCtrl.CurrBattleTeam:GetHeroCtrlWithBuffId(t)
for o=1,#a do
local o=a[o]
local a=o.HeroBattleInfo:GetBuff(t)
if a and a.releaseHeroId==e.CurrHeroCtrl.HeroId then
o.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
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
function a.AddBuffBabai(t,n,s)
local e=t:GetBuffData()
local r=e[16]
local h=e[17]
local o=e[19]
local i=e[21]
local a=e[23]
if t.CurrHeroCtrl.HeroId==n.HeroId then
o=math.floor(o*e[15]*MillionCoe)
i=math.floor(i*e[15]*MillionCoe)
a=math.floor(a*e[15]*MillionCoe)
end
local e={e[18],o,e[20],i,e[22],a}
n:AddBuff(t.CurrHeroCtrl,r,h,e,s)
end
return n

