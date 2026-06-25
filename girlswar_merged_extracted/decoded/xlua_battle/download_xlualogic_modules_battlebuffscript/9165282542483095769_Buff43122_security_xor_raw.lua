local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,s,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=e[1]
local a=e[2]
local h=e[3]
local n={e[4],e[5],e[6],e[7]}
local e=s.triggerSkillAtkType
if o:IsDependAtkType(e)==false then
local e=o:GetUnderControlTransferSkinAllEnemyList(t.CurrHeroCtrl,a,true)
if#e>0 then
local e=o:FindMostBigAtk(e)
if e then
e:CheckAddBuff(i,t.CurrHeroCtrl,a,h,n)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

