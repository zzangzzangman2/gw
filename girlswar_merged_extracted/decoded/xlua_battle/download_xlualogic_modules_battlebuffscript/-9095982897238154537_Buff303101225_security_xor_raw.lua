local t={}
local d=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetSkillRate(e,t,a)
local e=e:GetBuffData()
if a==31012301 then
for a=1,12,2 do
if e[a]==t then
return e[a+1]
end
end
elseif a==31012302 then
for a=13,24,2 do
if e[a]==t then
return e[a+1]
end
end
elseif a==31012303 then
for a=25,36,2 do
if e[a]==t then
return e[a+1]
end
end
elseif a==31012321 then
for a=55,66,2 do
if e[a]==t then
return e[a+1]
end
end
end
return nil
end
function t.DoBuffWithBigSkill(t,o)
local e=t:GetBuffData()
local i=0
local s=e[37]
local a=303101211
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(n)then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local a=a.ReduceFlower(n,s)
if a then
i=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[38]*MillionCoe)
local i=t.CurrHeroCtrl.battleStationRow
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
local a=a[o]
if a.battleStationRow==i then
local i=e[39]
local o=e[40]
if a.HeroId==t.CurrHeroCtrl.HeroId then
local e={e[41],e[45],e[43],e[46]}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
else
local e={e[41],e[42],e[43],e[44]}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
end
end
end
local a=e[47]
local i=e[48]
local s={e[49],e[50]}
local n=e[51]
local r=e[52]
local h={e[53],e[54]}
for e=1,#o do
local e=o[e]
e:AddBuff(t.CurrHeroCtrl,a,i,s)
e:AddBuff(t.CurrHeroCtrl,n,r,h)
end
end
end
return i
end
return d

