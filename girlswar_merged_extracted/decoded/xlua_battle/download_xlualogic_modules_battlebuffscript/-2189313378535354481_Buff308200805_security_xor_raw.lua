local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneBuffWithBuffList(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneBuffWithBuffList(e.buffId)
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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
function e.ImmuneBuff(e)
local e=e:GetBuffData()
if e[3]>=RandomMgr:GetBattleRandom()then
return true
end
return false
end
return a

