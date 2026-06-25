local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(a,e,t,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if e[9]>=e[8]then
return
end
local i=e[3]
local n={}
local o={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.enemyAll)
if(t)then
for a=1,#t do
local t=t[a]
if t:CurrHPPer()<e[1]*MillionCoe then
local e=t.HeroBattleInfo:GetBuff(i)
if e then
table.insert(n,t)
else
table.insert(o,t)
end
end
end
end
local t=nil
if#n>0 then
local e=RandomTableWithSeed(n,1)
t=e[1]
end
if t==nil and#o>0 then
local e=RandomTableWithSeed(o,1)
t=e[1]
end
if t then
local r=e[2]
local h=e[4]
local o={}
for t=5,8 do
table.insert(o,e[t])
end
local n=true
local s=t.HeroBattleInfo:GetBuff(i)
if s then
if s:GetRound()>=h then
n=false
end
end
if n then
local t=t:CheckAddBuff(r,a.CurrHeroCtrl,i,h,o)
if t then
e[9]=e[9]+1
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return d

