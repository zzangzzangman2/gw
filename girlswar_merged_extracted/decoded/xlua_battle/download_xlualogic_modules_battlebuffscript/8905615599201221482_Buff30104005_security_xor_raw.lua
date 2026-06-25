local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,o,a)
if a==nil then
GameInit.LogError("Buff30104005 beAtkHeroCtrl 不能为空 ")
return
end
local a=a.HeroBattleInfo:GetGranBuff(false)
local o=#a
if(o>0)then
local i=math.min(o,e[3])
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[1]
a.value=e[2]*i
t.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

