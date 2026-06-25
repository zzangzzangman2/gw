local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t[1]
local o=t[2]
local a={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(t)
local e=t:GetBuffData()
local o=e[5]
local a=e[6]
local i={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=e[9]
local o=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return n

