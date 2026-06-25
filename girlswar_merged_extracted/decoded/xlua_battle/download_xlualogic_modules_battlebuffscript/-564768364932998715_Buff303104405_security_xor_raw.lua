local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
o.AddBuffReduceAllEnemyAtk(e)
elseif a.buffTriggerTime==BuffTriggerTime.addEnemy
or a.buffTriggerTime==BuffTriggerTime.removeMyMate then
o.AddBuffReduceAllEnemyAtk(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffReduceAllEnemyAtk(a)
local t=a:GetBuffData()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.enemyAll)
if e and#e>0 then
local o=t[1]
local i=t[2]
local n={t[3],t[4]}
for t=1,#e do
local e=e[t]
e:AddBuff(a.CurrHeroCtrl,o,i,n)
end
end
end
function t.AddbuffBadScore(a,i,o)
local e=a:GetBuffData()
local s=e[9]
local n=e[10]
local t={}
for a=11,14 do
table.insert(t,e[a])
end
i:AddBuff(a.CurrHeroCtrl,s,n,t,o)
end
return o

