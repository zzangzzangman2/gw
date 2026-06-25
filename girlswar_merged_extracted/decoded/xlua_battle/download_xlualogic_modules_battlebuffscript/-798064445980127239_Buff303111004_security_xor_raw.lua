local e=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(o,t,a,i)
e.DoResurgence(o,t,a,i)
end
function t.DoResurgence(e,t,o,o)
if a.CheckCondition(e)==false then
return nil
end
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1)
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckConditionInTimeline(e)
local t=e:GetBuffData()
if a.CheckCondition(e)==false then
return 0
end
if e.CurrHeroCtrl:GetBuffTeamStatCount(303111005)>=t[6]then
return 2
end
return 1
end
function t.DoActionInTimeline(e)
e.CurrHeroCtrl:AddBuffTeamStatCount(303111005,1)
end
function t.CheckCondition(e)
local t=e:GetBuffData()
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId)>=t[6]then
return
end
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303111014)
if e then
local e=e:GetFloors()
if e*t[1]>t[7]then
return true
end
end
return false
end
return a

