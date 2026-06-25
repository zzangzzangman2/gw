local e=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(a,e,i,o,i,t)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.skill3Play
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skillPlay then
e[11]=0
elseif t.buffTriggerTime==BuffTriggerTime.attack then
if e[11]==0 then
e[11]=o.HeroId
end
elseif t.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or t.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if e[11]~=0 then
local t=e[11]
e[11]=0
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if o then
local n=e[2]
local i=e[3]
local t={}
for a=3,10 do
table.insert(t,e[a])
end
table.insert(t,0)
local e=e[1]
o:AddBuff(a.CurrHeroCtrl,n,i,t,e)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

