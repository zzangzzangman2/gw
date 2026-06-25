local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if t[1]==1 then
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.Tomb)
end
end
function t.OnRemoveSelf(e,t)
if t[1]==1 then
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.None)
end
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t[1]==0 then
e.isExec=true
return
end
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
local a=t[4]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local a=t[2]
local o=t[3]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
if e.CurrHeroCtrl then
e.CurrHeroCtrl:SetWillHeroSpecialState(HeroSpecialState.Tomb)
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBeforeCheckSuccess
or e==BuffTriggerTime.fatalDmgCheckSuccess)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

