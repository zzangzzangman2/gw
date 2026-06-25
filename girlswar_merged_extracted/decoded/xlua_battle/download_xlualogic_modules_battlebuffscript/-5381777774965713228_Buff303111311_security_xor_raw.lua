local n=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,i,i,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.addBuff then
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=t.addBuffId
if n:IsGranOrFalseBuff(t)then
a.AddBuffHoner(e,1)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.now then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetGranBuff(false)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetGranBuff(true)
local t=#o+#t
a.AddBuffHoner(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff
or e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffHoner(t,a)
local e=t:GetBuffData()
e[6]=e[6]+a
if e[6]>=e[1]then
local a=math.floor(e[6]/e[1])
e[6]=e[6]-a*e[1]
local i=e[3]
local o=e[4]
local a={}
local e=e[2]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a,e)
end
end
function t.DoActionSmallSkill(e,t)
local a=e:GetBuffData()
local i=0
local o=a[3]
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if s then
n:ReduceHeroBuffFloor(e.CurrHeroCtrl,o,1)
local o=e.CurrHeroCtrl:GetFinalAtk()
i=math.floor(o*a[5]*MillionCoe)
local a=303111322
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(e)then
local e=e:GetBuffData()
for a=1,#t do
local e={
attrId=e[1],
value=e[2],
}
t[a]:AddAttrValueInCurAttack(e)
end
end
end
return i
end
return a

