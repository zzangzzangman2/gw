local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=e[1]
local i=e[2]
local a={e[3],e[4],e[5],0}
local s=e[5]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
if e then
local e=e:GetBuffData()
e[4]=0
else
t.CurrHeroCtrl:AddBuff(o,n,i,a)
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.now or e==BuffTriggerTime.skillAttack then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

