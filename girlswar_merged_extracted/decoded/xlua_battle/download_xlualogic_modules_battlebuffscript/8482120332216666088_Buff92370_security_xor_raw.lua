local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,s,a,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.skillPlay
or o.buffTriggerTime==BuffTriggerTime.skill2Play
or o.buffTriggerTime==BuffTriggerTime.skill3Play then
e[11]=0
e[12]={}
e[13]=0
return
end
if e[13]==0 then
e[13]=1
local t=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroTable()
for a=1,#t do
local t=t[a]
if t.HeroBattleInfo:HasControlBuff()then
e[11]=1
break
end
end
local a=(e[11]==0)and e[7]or e[1]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(a>=RandomMgr:GetBattleRandom())then
e[12]={}
local t=RandomTableWithSeed(t,e[2])
for a=1,#t do
local t=t[a].HeroId
table.insert(e[12],t)
end
end
end
if type(e[12])=="table"and#e[12]>0 then
for o=1,#e[12]do
local o=e[12][o]
if a.HeroId==o then
local n=e[3]
local o=e[4]
local i={e[5],e[6]}
local i=a:AddBuff(t.CurrHeroCtrl,n,o,i)
if i then
local e=e[10]
a:AddBuff(t.CurrHeroCtrl,e,o,{})
end
end
end
end
if a.HeroBattleInfo:HasControlBuff()then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[8]
a.value=e[9]
s.HeroBattleInfo:AddTempBuffValue(a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)
or(e==BuffTriggerTime.skillPlay)
or(e==BuffTriggerTime.skill2Play)
or(e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

