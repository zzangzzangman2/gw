local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
a.CheckAddDamageRes(e)
e.CurrHeroCtrl:ShowRageBar(true)
a.RefresFightGodValueBar(e)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function t.DoAction(e,t,s,n,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.resurgence then
a.CheckAddDamageRes(e)
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local t=e.CurrHeroCtrl.HeroId
if t==n.HeroId then
local t=i.reduceHpValueBeforeReduceLimit
a.GainFightGodValue(e,t)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 and t[15]>=t[14]then
a.ClearFightGodValue(e)
local o=t[4]
local n=t[5]
local i={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,i)
a.CheckAddDamageRes(e)
local o=t[7]
local i=t[8]
local a={t[9],t[10],t[11],t[12]}
local t=t[13]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,o,i,a,1,t)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local a=a.GetfloorsFightLoss(e)
local t=t[16]-a*t[6]
if t>0 then
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t,
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
end
function t.GainFightGodValue(e,o)
local t=e:GetBuffData()
t[15]=t[15]+o
a.RefresFightGodValueBar(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function t.ClearFightGodValue(e)
local t=e:GetBuffData()
t[15]=0
a.RefresFightGodValueBar(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function t.GetfloorsFightLoss(e)
local a=e:GetBuffData()
local t=0
local a=a[4]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
t=e:GetFloors()
end
return t
end
function t.RefresFightGodValueBar(t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=t:GetBuffData()
local a=e[14]
t.CurrHeroCtrl:SetRageBar(e[15],a)
end
end
return a

