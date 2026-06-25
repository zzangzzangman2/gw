local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local a=t[2]
local o={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
elseif a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local a=303112106
local a=o:GetHeroBuffFloor(e.CurrHeroCtrl,a)
if a>0 then
local a=e.CurrHeroCtrl.HeroId
local e=31121102
local i={}
for e=9,18 do
table.insert(i,t[e])
end
local t={
buffId=303112118,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillParam=i
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if i==nil then
o:AddTriggerAttackTask(a,e,t,n)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.HandleOnDoAction(e,t)
local t=303112106
local e=o:GetHeroBuffFloor(e.CurrHeroCtrl,t)
if e>0 then
return true
end
return false
end
return n

