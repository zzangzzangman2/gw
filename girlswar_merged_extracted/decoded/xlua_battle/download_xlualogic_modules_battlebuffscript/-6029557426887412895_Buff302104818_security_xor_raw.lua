local e={}
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.Ice,e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.None)
end
function t.DoAction(a,e,t,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=a.CurrHeroCtrl
t.HeroBattleInfo:SetHp(1,true)
t:SetWillHeroSpecialState(HeroSpecialState.Ice)
t.HeroBattleInfo:ClearAllBuff()
local i=e[5]
local n=e[6]
local o={}
for a=7,14 do
table.insert(o,e[a])
end
t:AddBuff(t,i,n,o)
local o=e[1]
local i=e[2]
local n={e[3],e[4]}
local e=e[3]
t:AddBuff(t,o,i,n,e)
a.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDeadBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

