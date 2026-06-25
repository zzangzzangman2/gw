local e={92452,92453,92454}
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=t[2]
local o={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#a do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(n)
if t==nil then
table.insert(o,e)
end
end
local i={}
if#o>0 then
i=RandomTableWithSeed(o,1)
elseif#a>0 then
i=RandomTableWithSeed(a,1)
end
local a=i[1]
if a then
local i=t[3]
local o={}
local s=t[1]
for e=4,17 do
table.insert(o,t[e])
end
a:AddBuff(e.CurrHeroCtrl,n,i,o,s)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

