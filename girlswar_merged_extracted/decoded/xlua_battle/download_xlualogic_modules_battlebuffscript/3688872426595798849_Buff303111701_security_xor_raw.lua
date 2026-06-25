local a=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
if t[7]>0 then
e.CurrHeroCtrl:AddReduceSepsisRate(e.buffId,t[7])
end
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
if t[7]>0 then
e.CurrHeroCtrl:RemoveSepsisReduceRate(e.buffId)
end
end
function t.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
a:ReduceSepsisHpPercent(e.CurrHeroCtrl,e.CurrHeroCtrl,t[1],true,true)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[5])
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ImmuneDebuff(e)
local e=e:GetBuffData()
if e[8]>=e[6]then
return false
end
e[8]=e[8]+1
return true
end
return o

