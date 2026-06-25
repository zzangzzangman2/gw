local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl:SetSpineBoyScale(1.2,true)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl:SetSpineBoyScale(1,true)
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
if#t>=6 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=math.floor(a*t[7]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

