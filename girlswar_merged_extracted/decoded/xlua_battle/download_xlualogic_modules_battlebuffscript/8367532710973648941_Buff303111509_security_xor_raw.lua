local i=require("Modules/Battle/BattleUtil")
local n=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(a,e,t,o)
n.DoResurgence(a,e,t,o)
end
function a.DoResurgence(e,t,a,a)
if o.CheckCondition(e)==false then
return
end
local a=303111504
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t[1])
local i=t[2]
local a=t[3]
local o={t[4],t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExcuteInTimeLine=false
t[8]=t[8]+1
if t[8]>=t[7]then
e.isExec=true
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function a.CheckCondition(t)
local e=t:GetBuffData()
if e[8]>=e[7]then
return false
end
local a=303111504
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(t)then
local t=t:GetFloors()
if t>=e[1]then
return true
end
end
return false
end
return o 
