local n=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e.CurrHeroCtrl:GetAllTeamPet()
for o=1,#a do
local a=a[o]
local n=t[1]
local i=t[2]
local o={t[3],t[4]}
a:AddBuff(e.CurrHeroCtrl,n,i,o)
local o=t[5]
local i=t[6]
local t={t[7],t[8]}
a:AddBuff(e.CurrHeroCtrl,o,i,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
o.AddAttackTask(e,s)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddAttackTask(e,t)
local a=e:GetBuffData()
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
disableDefFuryhealth=true,
}
n:AddFightPetAttackTask(e.CurrHeroCtrl,a,t)
end
return o

