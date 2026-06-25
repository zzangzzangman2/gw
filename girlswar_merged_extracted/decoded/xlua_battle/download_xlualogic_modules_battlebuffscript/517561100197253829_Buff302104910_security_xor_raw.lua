local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for a,t in ipairs(t)do
local a=302104921
local o=t.HeroBattleInfo:GetBuff(a)
if o then
if o.releaseHeroId==e.CurrHeroCtrl.HeroId then
t.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(302104905)
if a then
local a=a:GetBuffData()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for i,o in ipairs(o)do
local i=t[1]
local n=o.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n.releaseHeroId)
if e==nil then
o.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
local n=t[2]
local t={t[3],t[4],t[5],a[9],a[10],a[11],a[12],0}
o:AddBuff(e.CurrHeroCtrl,i,n,t)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

