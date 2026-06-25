local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart
or a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if o.IsBigRoundStart(a.buffTriggerTime,t.CurrHeroCtrl)then
local n=ModulesInit.ProcedureNormalBattle.GetOurCount(t.CurrHeroCtrl)
local i=ModulesInit.ProcedureNormalBattle.GetEnemyCount(t.CurrHeroCtrl)
if i>n then
local n=e[1]
local i=e[2]
local a={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,a)
local s=e[3]
local i=e[4]
local n={e[5],e[6]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for e=1,#a do
a[e]:AddBuff(t.CurrHeroCtrl,s,i,n)
end
local i=e[7]
local n=e[8]
local e={e[9],e[10]}
table.insert(e,0)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
if#a>0 then
local a=o:FindMostBigAtk(a)
if a then
a:AddBuff(t.CurrHeroCtrl,i,n,e)
end
end
elseif i<n then
local i=e[11]
local a=e[12]
local o={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
local n=e[13]
local o=e[14]
local i={e[15],e[16]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for e=1,#a do
a[e]:AddBuff(t.CurrHeroCtrl,n,o,i)
end
local o=e[17]
local i=e[18]
local a={e[19]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eRandom,1)
if#e>0 then
local e=e[1]
if e then
e:AddBuff(t.CurrHeroCtrl,o,i,a)
end
end
else
local o=e[20]
local a=e[21]
local i={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local i=e[22]
local o=e[23]
local n={e[24],e[25]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#a do
a[e]:AddBuff(t.CurrHeroCtrl,i,o,n)
end
local n=e[26]
local i=e[27]
local o={e[28]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for a=1,#e do
e[a]:AddBuff(t.CurrHeroCtrl,n,i,o)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

