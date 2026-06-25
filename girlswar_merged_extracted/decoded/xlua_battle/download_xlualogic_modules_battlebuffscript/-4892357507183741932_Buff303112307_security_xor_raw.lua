local a=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveFuryCostReduceEntry(e.buffId)
end
function e.DoAction(e,i,h,n,s,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local h=e.CurrHeroCtrl
if o.buffTriggerTime==BuffTriggerTime.now then
t.GrantFuryCostReduce(e,i)
elseif o.buffTriggerTime==BuffTriggerTime.teamHeroFatalDmgBefore then
if n.HeroId~=h.HeroId then
return
end
t.GrantFuryCostReduce(e,i)
elseif o.buffTriggerTime==BuffTriggerTime.skillPlay then
local o=s.triggerSkillAtkType
if a:IsDependAtkType(o)==false then
t.DoFire1ActionSkill(e)
end
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroFatalDmgBefore
or e==BuffTriggerTime.skillPlay then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.HealSepsisOnDestinyFloorAdded(e,o)
if o<=0 then
return
end
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl
local e=e:GetBuffData()
local e=math.floor(t.HeroBattleInfo.MaxHP*e[2]*MillionCoe*o)
a:ReduceSepsisHp(t,t,e,true,true)
end
function e.GrantFuryCostReduce(e,t)
e.CurrHeroCtrl:AddFuryCostReduceEntry(e.buffId,t[1],1)
end
function e.DoFire1ActionSkill(e)
local t=e.CurrHeroCtrl
local e=e:GetBuffData()
local a=a:GetHeroBuffFloor(t,303112302)
if a>0 then
local a=a*e[6]
local a={e[5],a}
t:AddBuff(t,e[3],e[4],a)
end
end
function e.OnRemoveFuryCostReduceE(e,e)
end
return t

