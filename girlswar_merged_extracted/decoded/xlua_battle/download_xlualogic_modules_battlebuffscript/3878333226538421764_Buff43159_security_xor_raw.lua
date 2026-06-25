local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,n,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=t.CurrHeroCtrl.HeroId
if t==i.HeroId
and(o.attackType==AttackType.BigSkill or o.attackType==AttackType.SmallSkill)then
if e[10]==1 then
local t=o.reduceHpValue
local t=math.floor(t*e[1]*MillionCoe)
e[11]=e[11]+t
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play then
e[10]=1
e[11]=0
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd then
if e[10]==1 then
local a=e[11]
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*e[2]*MillionCoe)
a=math.min(a,o)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId,true)
if(t.CurrHeroCtrl and e[3]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eRandom,1)
if a then
for o=1,#a do
local n=e[4]
local i=e[5]
local e={e[6],e[7],e[8],e[9]}
a[o]:AddBuff(t.CurrHeroCtrl,n,i,e)
end
end
end
end
e[10]=0
e[11]=0
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

