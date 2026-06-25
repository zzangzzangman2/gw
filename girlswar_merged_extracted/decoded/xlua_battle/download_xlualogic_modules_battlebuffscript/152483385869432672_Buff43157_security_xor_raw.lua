local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,i,o,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attack then
if e[2]>0 then
local a=(1-o:CurrHPPer())*OneMillion/e[2]
local o=math.floor(e[4]*a)
if o>0 then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[3]
a.value=o
i.HeroBattleInfo:AddTempBuffValue(a)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
if e[5]==1 then
e[6]=e[6]+1
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[5]=1
e[6]=0
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[5]==1 then
if e[6]>0 then
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e[1]*e[6])
end
end
e[5]=0
e[6]=0
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

