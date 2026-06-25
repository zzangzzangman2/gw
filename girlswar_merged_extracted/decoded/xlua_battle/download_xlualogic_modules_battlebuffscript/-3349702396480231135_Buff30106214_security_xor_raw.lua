local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:ShowRageBar(false)
end
function e.DoAction(e,o,n,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=e.CurrHeroCtrl.HeroId
if n==a.HeroId then
local a=i.reduceHpValue
local n=i.criticalOrBlock
local i=e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
a=math.min(a,i)
local i=o[1]
if n==2 then
i=o[2]
end
local a=math.floor(a*i*MillionCoe)
t.AddFuryDamageValue(e.CurrHeroCtrl,a)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddFuryDamageValue(e,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local a=e.HeroBattleInfo:GetBuff(30106214)
if a==nil then
return
end
local a=a:GetBuffData()
local n=a[5]
local o=e.HeroBattleInfo:GetBuff(n)
if o==nil then
local a=a[6]
local t={i}
e:AddBuff(e,n,a,t)
else
local e=o:GetBuffData()
e[1]=e[1]+i
o:AddBuffData(e)
end
local i=e.HeroBattleInfo.MaxHP
local n=t.GetFuryDamageValue(e)
local o=a[3]
if n>=i then
local t=a[4]
e:AddBuff(e,o,t,0)
end
t.RefreshRageBar(e)
end
function e.RefreshRageBar(e)
local o=e.HeroBattleInfo.MaxHP
local a=t.GetFuryDamageValue(e)
local t=e.HeroBattleInfo:GetBuff(30106216)
if t then
local t=t:GetBuffData()
local t=o+math.floor((t[7]*t[3]*MillionCoe)*o)
e:SetRageBar(a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function e.ReduceFuryDamageValue(a,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
i=math.floor(i)
local e=a.HeroBattleInfo:GetBuff(30106214)
if e==nil then
return
end
local e=e:GetBuffData()
local e=e[5]
local o=a.HeroBattleInfo:GetBuff(e)
if o then
local e=o:GetBuffData()
e[1]=math.floor(e[1]-i)
e[1]=math.min(0,e[1])
o:AddBuffData(e)
else
end
t.RefreshRageBar(a)
end
function e.GetFuryDamageValue(e)
local t=0
local e=e.HeroBattleInfo:GetBuff(30106217)
if e then
local e=e:GetBuffData()
t=e[1]
end
return t
end
return t

