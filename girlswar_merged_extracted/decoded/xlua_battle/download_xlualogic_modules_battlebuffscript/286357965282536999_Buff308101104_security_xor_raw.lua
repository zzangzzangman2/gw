local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4])
o.AddAttrHpChange(e)
elseif a.buffTriggerTime==BuffTriggerTime.hpChange then
o.AddAttrHpChange(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddAttrHpChange(t)
local e=t:GetBuffData()
local a=t.CurrHeroCtrl:CurrHPPer()
if e[5]>0 then
if a*OneMillion<e[5]then
local a=math.floor((e[5]-a*OneMillion)*e[7])
a=math.min(a,e[8])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[6],a)
else
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValue(t.buffId,e[6])
end
end
end
return o

