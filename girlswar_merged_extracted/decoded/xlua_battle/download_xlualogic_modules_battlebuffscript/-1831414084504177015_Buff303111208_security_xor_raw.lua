local e={}
local n=e
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
function e.DoActionSmallSkill(a,t)
local e=a:GetBuffData()
local o=e[1]*MillionCoe
local t=t.HeroBattleInfo.MaxHP
local t=math.floor(t*o)
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(e[2]*o*MillionCoe)-e[6]
t=math.min(t,i)
if t>0 then
e[6]=e[6]+t
local e=t/o
a.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e)
end
local i=e[3]
local t=e[4]
local e=math.floor(o*e[5]*MillionCoe)
local e={e}
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,i,t,e)
end
return n

