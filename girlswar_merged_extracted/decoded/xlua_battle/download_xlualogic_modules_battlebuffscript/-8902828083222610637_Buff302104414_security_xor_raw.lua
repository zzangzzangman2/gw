local n={}
local s=n
function n.GetCanAdd(e,e)
return true
end
function n.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if n and#n>0 then
local i=0
local a=0
local o=0
for t=1,#n do
local t=n[t]
if t.profession==e[2]then
i=i+1
elseif t.profession==e[8]then
a=a+1
elseif t.profession==e[15]then
o=o+1
end
end
if i>0 then
i=math.min(i,e[7])
local a=e[3]
local o=e[4]
local e={e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e,i)
end
if a>0 then
a=math.min(a,e[13])
local n=e[9]
local o=e[10]
local i={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,o,i,a)
t.CurrHeroCtrl:AddFuryWithBuff(a*e[14])
end
if o>0 then
o=math.min(o,e[20])
local a=e[16]
local i=e[17]
local e={e[18],e[19]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,e,o)
end
end
t.isExec=true
end
function n.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function n.SetLogicData(e,e)
end
return s

