local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
i.RemoveAllConvertTarget(e,t)
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[3],a[4])
i.CheckAddBuffBeauty(e)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif t.buffTriggerTime==BuffTriggerTime.removeMyMate
or t.buffTriggerTime==BuffTriggerTime.addEnemy
or t.buffTriggerTime==BuffTriggerTime.allHeroAfterSufferDmg then
i.CheckAddBuffBeauty(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.removeMyMate
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.allHeroAfterSufferDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckAddBuffBeauty(e)
local i=e:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
local o={}
local n={}
for t=1,#a do
local t=a[t]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
if t.HeroBattleInfo.CurrHP<e.CurrHeroCtrl.HeroBattleInfo.CurrHP then
table.insert(o,t)
else
if t.heroDid==e.CurrHeroCtrl.heroDid then
o={}
n={}
break
end
table.insert(n,t)
end
end
end
local t=i[5]
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if#o>0 or#a==1 then
if s==nil then
local o=i[6]
local a={i[7],i[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,t,o,a)
end
for t=1,#o do
local t=o[t]
t:AddConvertTarget(e.buffId,e.CurrHeroCtrl.HeroId)
end
for t=1,#n do
local t=n[t]
t:RemoveConvertTarget(e.buffId,e.CurrHeroCtrl.HeroId)
end
else
if s~=nil then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
for t=1,#a do
local t=a[t]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
t:RemoveConvertTarget(e.buffId,e.CurrHeroCtrl.HeroId)
end
end
end
end
end
function t.RemoveAllConvertTarget(e,t)
for a=1,#t do
local t=t[a]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
t:RemoveConvertTarget(e.buffId,e.CurrHeroCtrl.HeroId)
end
end
end
function t.OnConvertTarget(e,t)
local t=e:GetBuffData()
e.CurrHeroCtrl:AddFuryWithBuff(t[9])
end
return i

