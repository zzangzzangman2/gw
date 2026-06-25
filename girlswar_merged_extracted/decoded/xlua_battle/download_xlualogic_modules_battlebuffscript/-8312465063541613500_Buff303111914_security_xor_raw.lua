local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,n,a,a,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local h=t-1
local i=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.enemyAll,nil,nil,true)
local a=0
local t=nil
for e,o in ipairs(i)do
local e=o:GetTotalDamageInBigRound(h,EBattleTurnType.OurTurn)
if t==nil or e>a then
t=o
a=e
end
end
if a==0 then
local e=RandomTableWithSeed(i,1)
t=e[1]
end
if t then
local a=303111907
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffLiquidation(e,t,n[1])
end
end
local t=303111921
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddBuffLiquidation(a)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=303111915
for a=1,#t do
local a=t[a]
local t=a.HeroBattleInfo:GetBuff(o)
if t then
local t=t:GetFloors()
if t>0 then
s.AddBuffSolarEclipse(e,a,t)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffSolarEclipse(o,a,n)
local e=o:GetBuffData()
local i={303111916,303111917,303111918,303111919,303111920}
local t={}
local s={}
for e=1,#i do
local e=i[e]
local a=a.HeroBattleInfo:GetBuff(e)
if a==nil then
table.insert(t,e)
else
table.insert(s,e)
end
end
local i={}
if#t<n then
local e=n-#t
i=RandomTableWithSeed(s,e)
table.appendList(i,t)
elseif#t==n then
i=t
else
i=RandomTableWithSeed(t,n)
end
local t=e[2]
for n=1,#i do
local i=i[n]
if i==303111916 then
local n=e[3]
local s=e[4]
local i={}
for t=5,8 do
table.insert(i,e[t])
end
a:CheckAddBuff(t,o.CurrHeroCtrl,n,s,i)
elseif i==303111917 then
local s=e[9]
local n=e[10]
local i={}
for t=11,14 do
table.insert(i,e[t])
end
a:CheckAddBuff(t,o.CurrHeroCtrl,s,n,i)
elseif i==303111918 then
local i=e[15]
local n=e[16]
local e={}
a:CheckAddBuff(t,o.CurrHeroCtrl,i,n,e)
elseif i==303111919 then
local n=e[17]
local e=e[18]
local i={}
a:CheckAddBuff(t,o.CurrHeroCtrl,n,e,i)
elseif i==303111920 then
local i=e[19]
local n=e[20]
local e={}
a:CheckAddBuff(t,o.CurrHeroCtrl,i,n,e)
end
end
end
return s

