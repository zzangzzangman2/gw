local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
local a=0
if(o)then
a=o:GetFloors()
end
if a<e[7]then
local a=e[1]
local i=e[2]
local o={e[3],e[4],e[5],e[6]}
local e=1*(1+e[8])
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,o,e)
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

