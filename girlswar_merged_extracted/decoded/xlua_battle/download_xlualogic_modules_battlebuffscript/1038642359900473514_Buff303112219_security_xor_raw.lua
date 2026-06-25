local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,o,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[5]=0
elseif a.buffTriggerTime==BuffTriggerTime.attack then
if e[5]==nil then
return
end
if e[5]>=1 then
return
end
if o==nil then
return
end
local a=t:GetFloors()
local n=t.CurrHeroCtrl
local t=e[1]
local i=e[2]
local a={e[3],e[4]*a}
o:AddBuff(n,t,i,a)
e[5]=e[5]+1
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.attack then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

