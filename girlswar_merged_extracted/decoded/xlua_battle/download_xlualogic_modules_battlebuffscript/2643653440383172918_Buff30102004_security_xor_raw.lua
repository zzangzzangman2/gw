local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil then
GameInit.LogError("Buff30102004 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if(t.CurrHeroCtrl:CurrHPPer()<e[1]*MillionCoe)then
local a=e[2]
local o=e[3]
local e={e[4],e[5],e[6],e[7],e[8],e[9],e[10],e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
if t.CurrHeroCtrl.HeroBattleInfo then
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
t.isExec=true
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.hpDown)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

