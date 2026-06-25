local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,n,n,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
local a=t[2]
for i=1,#a do
local a=a[i]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
o.AddResurgenceHero(e,t,a)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.addMyMate then
if a then
local i=t[2]
for n=1,#i do
local i=i[n]
if i==a.HeroId then
o.AddResurgenceHero(e,t,a)
break
end
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddResurgenceHero(t,e,o)
local a=e[3]
local i=e[4]
local e={e[5],e[6],e[7],e[8],e[1],t.CurrHeroCtrl.HeroId}
o:AddBuff(t.CurrHeroCtrl,a,i,e)
end
return o

