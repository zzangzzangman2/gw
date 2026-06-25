local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,i,i,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.addBuff then
if a.teamId~=e.CurrHeroCtrl:GetTeamId()then
if a.addBuffId==303112001 then
o.AddBuffByFragileAlliance(e)
end
end
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundStart
or t.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
o.AddBuffByFragileAlliance(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffByFragileAlliance(e)
local t=e:GetBuffData()
local a=303112001
local o,a=i:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.enemyAll,a)
local a=#a
local s=t[1]
local i=t[2]
local n={t[3],t[4]}
local o=a
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,s,i,n,o)
local n=t[5]
local i=t[6]
local o={t[7],t[8]}
local t=a
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,n,i,o,t)
local t=303112022
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local t=t:GetBuffData()
local s=t[9]
local i=t[10]
local o={t[11],t[12]}
local n=a
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,s,i,o,n)
local o=t[13]
local i=t[14]
local n={t[15],t[16]}
local t=a
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,o,i,n,t)
end
end
return o

