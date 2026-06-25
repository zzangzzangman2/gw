local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffNetherWorld(t,a)
local e=t:GetBuffData()
local o=e[2]
local i=e[3]
local n={e[4]}
if a:GetBuffTeamStatCount(o)>=e[4]then
return
end
a:AddBuff(t.CurrHeroCtrl,o,i,n)
end
return s

