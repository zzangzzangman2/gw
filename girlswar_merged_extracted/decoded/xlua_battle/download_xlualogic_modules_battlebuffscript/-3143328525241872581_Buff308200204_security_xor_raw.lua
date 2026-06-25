local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
elseif a.buffTriggerTime==BuffTriggerTime.normalAttacked
or a.buffTriggerTime==BuffTriggerTime.smallSkillAttacked then
local n=t[3]
local o=t[4]
local i=t[5]
local a={}
for o=6,9 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:CheckAddBuff(n,e.CurrHeroCtrl,o,i,a,1)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.normalAttacked
or e==BuffTriggerTime.smallSkillAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

