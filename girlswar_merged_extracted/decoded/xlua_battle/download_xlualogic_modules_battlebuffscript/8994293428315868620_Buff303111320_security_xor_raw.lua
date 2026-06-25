local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local o=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303111304)==nil then
local t=303111308
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local e={e.CurrHeroCtrl}
t.AddBuffFloatGuard(a,e,false)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

