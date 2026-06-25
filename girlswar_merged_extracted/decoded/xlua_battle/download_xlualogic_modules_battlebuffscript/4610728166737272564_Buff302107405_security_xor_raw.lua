local o=require("Modules/Battle/Formula")
local s=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
a.AddBuffToSameRow(e,t)
a.AddInjureRateFromFriend(e,t)
a.AddBuffWithFrontHero(e,t)
elseif o.buffTriggerTime==BuffTriggerTime.addMyMate then
a.AddBuffToSameRow(e,t)
a.AddBuffWithFrontHero(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate)then
return true
end
end
function t.SetLogicData(e,e)
end
function t.AddBuffToSameRow(t,e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfRow)
for o=1,#a do
if a[o].HeroId~=t.CurrHeroCtrl.HeroId then
local n=e[1]
local i=e[2]
local e={e[3],e[4]}
a[o]:AddBuff(t.CurrHeroCtrl,n,i,e)
end
end
end
function t.AddInjureRateFromFriend(e,t)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
local a=0
for t=1,#i do
local t=i[t]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
local e=o:GetInjureData(t)
local e=e.attackFinalInjureRate
if e>a then
a=e
end
end
end
local o=math.floor(a*t[7])
local i=t[5]
local a=t[6]
local t={HeroAttrId.injureRateAdd,o}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,t)
end
function t.AddBuffWithFrontHero(e,t)
if e.CurrHeroCtrl.battleStationRow==2 then
local a=s.GetOtherHeroInSameColumn(e.CurrHeroCtrl)
if a then
local i=o:GetInjureResData(a)
local i=i.defFinalInjureResRate
local i=math.floor(i*t[10])
if i>0 then
local a=t[8]
local t=t[9]
local o={HeroAttrId.injureResRateAdd,i}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
end
local o=o:GetHeroControlResRate(e.CurrHeroCtrl,0)
local o=o.defFinalControlResRate
local o=math.floor(o*t[13])
if o>0 then
local i=t[11]
local n=t[12]
local t={HeroAttrId.controlResRateAdd,o}
a:AddBuff(e.CurrHeroCtrl,i,n,t)
end
end
end
end
return a

