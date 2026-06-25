local o=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffElectricalPowerUp(e)
local t=e:GetBuffData()
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[1])
local a=e.CurrHeroCtrl:GetFinalAtk()
local t=math.floor(a*t[2]*MillionCoe)
o:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
end
function e.DoActionBigSkill(t,a)
local e=t:GetBuffData()
local i=e[3]
local n=e[4]
local o={}
for t=5,8 do
table.insert(o,e[t])
end
for e=1,#a do
a[e]:AddBuff(t.CurrHeroCtrl,i,n,o)
end
end
return s

