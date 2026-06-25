local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneReduceFury()
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if e.CurrHeroCtrl:IsLiveAgainState()then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local a=e.CurrHeroCtrl:GetFinalAtk()
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a*t[1]*MillionCoe,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[2])
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
if#t>=6 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
end
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

