local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetAddHeroCountAndTimes(e)
local e=e:GetBuffData()
return e[5],e[6]
end
function t.DoActionBigSkill1(t,a)
local e=t:GetBuffData()
local o=a.HeroBattleInfo:GetGranBuff(true)
local i=#o
local o=0
if i>0 then
local t=t.CurrHeroCtrl:GetFinalAtk()
o=math.floor(i*t*e[7]*MillionCoe)
end
if(e[8]>=RandomMgr:GetBattleRandom())then
a.HeroBattleInfo:DispelAllGranBuff(true)
end
return o
end
return n

