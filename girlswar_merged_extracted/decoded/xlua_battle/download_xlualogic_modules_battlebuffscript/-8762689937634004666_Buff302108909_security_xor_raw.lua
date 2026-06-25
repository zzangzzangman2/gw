local a={}
local n=a
local t=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,i,o)
t.DoResurgence(e,a,i,o)
end
function a.DoResurgence(e,t,a,a)
t[6]=t[6]+1
local i=t[1]
local a=t[2]
local o={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
local o=t[5]
local a=302108913
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local e=a:GetBuffData()
o=e[11]
end
if t[6]>=o then
e.isExec=true
end
e.isExcuteInTimeLine=false
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
return n 
