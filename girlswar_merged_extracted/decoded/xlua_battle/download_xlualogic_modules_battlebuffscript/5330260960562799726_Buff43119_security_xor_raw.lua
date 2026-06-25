local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,n,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e[1]
local o=e[2]
local e={e[3],e[4],e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43122)
if a==nil then
local a=i.triggerSkillAtkType
if o:IsDependAtkType(a)==false then
local i=e[7]
local a=e[8]
local n=e[9]
local e=o:GetUnderControlTransferSkinAllEnemyList(t.CurrHeroCtrl,a,true)
if#e>0 then
local e=o:FindMostBigAtk(e)
if e then
e:CheckAddBuff(i,t.CurrHeroCtrl,a,n,0)
end
end
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

