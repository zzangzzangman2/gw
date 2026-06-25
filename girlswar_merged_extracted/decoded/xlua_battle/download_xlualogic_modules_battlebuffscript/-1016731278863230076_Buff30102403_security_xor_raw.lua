local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil then
GameInit.LogError("Buff30102403 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if(e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe)then
local a=t[2]
local o=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
e.isExec=true
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.hpDown or e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

