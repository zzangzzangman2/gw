local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,n,n,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local a=i.triggerSkillAtkType
if o:IsNormalSkillAtkType(a)then
local a=43252
local o=o:GetHeroMostBuffFloor(e.CurrHeroCtrl,BattleHeroType.enemyAll,a)
if o then
local a=43251
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffFrostMarks(e,o,t[5])
end
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

