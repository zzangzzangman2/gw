local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
GameInit.LogError("Buff30102501 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
local o=0
if(a)then
o=a:GetFloors()
end
if o<e[7]then
local i=e[1]
local o=e[2]
local n={e[3],e[4],e[5],e[6],e[7]}
local a=1
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(30102506)
if e then
local e=e:GetBuffData()
if e and e[1]then
a=e[1]
end
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,n,a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

