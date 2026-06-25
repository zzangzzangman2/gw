local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local i=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,a)
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=e[9]
local o=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=303110307
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local o=a.GetNineTailState(o)
local a=0
if o==1 then
a=e[13]
elseif o==2 then
a=e[14]
else
a=e[15]
end
t.CurrHeroCtrl:AddFuryWithBuffImmediately(a)
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

