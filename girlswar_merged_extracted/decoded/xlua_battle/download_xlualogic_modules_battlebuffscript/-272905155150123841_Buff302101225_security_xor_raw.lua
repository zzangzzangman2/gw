local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetSkillRate(t,a)
local e=t:GetBuffData()
if t.CurrHeroCtrl.BigSkillId==21012301 then
for t=1,12,2 do
if e[t]==a then
return e[t+1]
end
end
elseif t.CurrHeroCtrl.BigSkillId==21012302 then
for t=13,24,2 do
if e[t]==a then
return e[t+1]
end
end
elseif t.CurrHeroCtrl.BigSkillId==21012303 then
for t=25,36,2 do
if e[t]==a then
return e[t+1]
end
end
end
return nil
end
function e.DoBuffWithBigSkill(t,o)
local e=t:GetBuffData()
local n=0
local s=e[37]
local a=302101211
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(i)then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local a=a.ReduceFlower(i,s)
if a then
n=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[38]*MillionCoe)
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
local r=e[47]
local i=e[48]
local a={e[49],e[50]}
local n=e[51]
local h=e[52]
local s={e[53],e[54]}
for e=1,#o do
local e=o[e]
e:AddBuff(t.CurrHeroCtrl,r,i,a)
e:AddBuff(t.CurrHeroCtrl,n,h,s)
end
end
end
return n
end
return s

