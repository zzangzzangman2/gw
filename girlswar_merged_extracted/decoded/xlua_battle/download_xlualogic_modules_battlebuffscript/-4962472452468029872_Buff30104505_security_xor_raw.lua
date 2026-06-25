local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.GeHurtAddRate(t,e)
if t==nil or t.HeroBattleInfo==nil or t.HeroBattleInfo.CurrHP<=0 then
return
end
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return 0
end
local a=30104505
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local t=t:GetBuffData()
if e:CurrHPPer()<t[1]*MillionCoe then
return t[2]
end
end
return 0
end
function e.AddBoneCrashBuff(t,a)
if t==nil or t.HeroBattleInfo==nil or t.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil or a.HeroBattleInfo==nil or a.HeroBattleInfo.CurrHP<=0 then
return
end
local e=30104505
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
local o=e[3]
local n=e[4]
local i=e[5]
local s=t.HeroBattleInfo:GetMaxHP()*e[9]*MillionCoe
local e={e[6],e[7],e[8],s}
if o>=0 then
a:CheckAddBuff(o,t,n,i,e)
else
a:AddBuff(t,n,i,e)
end
end
end
return h

