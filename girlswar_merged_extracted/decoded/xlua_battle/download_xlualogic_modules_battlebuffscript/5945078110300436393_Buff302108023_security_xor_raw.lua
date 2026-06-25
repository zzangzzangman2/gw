local e=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.Tomb)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.None)
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
local a=t[3]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local a=t[1]
local t=t[2]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
e.CurrHeroCtrl:SetWillHeroSpecialState(HeroSpecialState.Tomb)
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

