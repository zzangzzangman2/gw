local e={}
local n=e
local a=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(i,o,t,e)
a.DoResurgence(i,o,t,e)
end
function e.DoResurgence(e,t,a,a)
local o=t[1]
local i=t[2]
local a={}
for e=3,15 do
table.insert(a,t[e])
end
t[17]=t[17]+1
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function e.CheckResetState(e)
local o=e:GetBuffData()
local t=o[16]
local a=302107717
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local e=a:GetBuffData()
t=t+e[1]
end
local a=o[17]
if a<t then
local t=e:GetBuffData()
e.isExcuteInTimeLine=false
e.isExec=false
else
e.isExcuteInTimeLine=true
e.isExec=true
end
end
return n

