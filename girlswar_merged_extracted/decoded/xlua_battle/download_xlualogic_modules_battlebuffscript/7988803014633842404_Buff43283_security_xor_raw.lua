local o=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,n,h,s,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
a.ResetData(e,n)
elseif t.buffTriggerTime==BuffTriggerTime.attack then
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if e then
if o:IsNormalSkillAtkType(i.triggerSkillAtkType)then
s:SetMustBeCritOnce(true)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ResetData(e,t,a)
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if o and a~=true then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[3])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[6])
else
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[5])
end
end
return a

