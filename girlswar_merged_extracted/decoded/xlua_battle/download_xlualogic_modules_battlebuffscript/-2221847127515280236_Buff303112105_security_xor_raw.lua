local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if t[2]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
end
if t[4]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=303112105
local a=o:GetHeroBuffFloor(e.CurrHeroCtrl,a)
if a>0 then
local t=t[1]*a
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t*MillionCoe)
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
o:AddSepsisHp(t,e.CurrHeroCtrl,a,true,true)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

