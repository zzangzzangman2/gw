local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e[1]
local a=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local i=e[9]
local a=e[10]
local o={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
local o=e[13]
local a=e[14]
local i={e[15],e[16]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=e[17]
local o=e[18]
local e={e[19],e[20]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
t.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

