local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.OnDestinyMilestone(t,n)
if n<=0 then
return
end
if t==nil or t.CurrHeroCtrl==nil then
return
end
local e=t:GetBuffData()
local a=e[1]
local o=e[2]
local i=e[11]
e[11]=i+n
local i=math.floor(i/a)
local a=math.floor(e[11]/a)
local a=a-i
if a<=0 then
return
end
local t=t.CurrHeroCtrl
for a=1,a do
local a=e[3]
local i=e[4]
local n={e[5],e[6]}
if o>=RandomMgr:GetBattleRandom()then
t:AddBuff(t,a,i,n)
end
local a=e[7]
local i=e[8]
local e={e[9],e[10]}
if o>=RandomMgr:GetBattleRandom()then
t:AddBuff(t,a,i,e)
end
end
end
return s

