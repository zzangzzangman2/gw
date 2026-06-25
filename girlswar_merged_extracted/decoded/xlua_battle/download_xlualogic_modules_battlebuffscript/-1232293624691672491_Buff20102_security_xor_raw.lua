local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t)
local h=t[1]
local o=t[2]
local i=t[3]
local s=t[4]
local n={t[5],t[6],t[7]}
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if(a)then
a.floors=math.min(a.floors+h,o)
if(a.floors==o)then
e.CurrHeroCtrl:AddFuryWithSkill(t[8])
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[9]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.isExec=true
end
else
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,s,n)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Attack or e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return r

