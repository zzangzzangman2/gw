local e={}
local l=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnAddBuffGrowth(t,i)
local e=t:GetBuffData()
local a=0
local o=e[21]
for t=2,4 do
local e=e[t]
if i>=e and o[e]~=true then
a=a+1
o[e]=true
end
end
if a<=0 then
return
end
local n=e[5]
local i=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o,a)
local n=e[9]
local i=e[10]
local o={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o,a)
local i=e[13]
local n=e[14]
local h={e[15],e[16]}
local s=e[17]
local d=e[18]
local r={e[19],e[20]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#e>0 then
for o=1,#e do
e[o]:AddBuff(t.CurrHeroCtrl,i,n,h,a)
e[o]:AddBuff(t.CurrHeroCtrl,s,d,r,a)
end
end
end
return l

