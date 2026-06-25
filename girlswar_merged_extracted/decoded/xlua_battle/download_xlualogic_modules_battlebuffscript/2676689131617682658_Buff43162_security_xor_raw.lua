local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,i,o,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=t.CurrHeroCtrl.HeroId
if a==i.HeroId then
local n=e[6]
local i=e[7]
local a={}
o:AddBuff(t.CurrHeroCtrl,n,i,a)
local a=e[10]
if e[11]==1 then
a=e[5]
end
local i=e[8]
local e=e[9]
local n={}
local e=o:CheckAddBuff(a,t.CurrHeroCtrl,i,e,n)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[11]=0
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
if t and#t>0 then
for a=1,#t do
local t=t[a]
if t.HeroBattleInfo:HasControlBuff()then
e[11]=1
break
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
e[11]=0
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
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
return s

