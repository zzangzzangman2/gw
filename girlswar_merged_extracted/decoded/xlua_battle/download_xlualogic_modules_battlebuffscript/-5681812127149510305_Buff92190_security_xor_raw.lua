local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if(e[1]>=RandomMgr:GetBattleRandom())then
local o=e[2]
local a=e[3]
local e={e[4],e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
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
return o

