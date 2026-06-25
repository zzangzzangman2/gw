local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,s,h,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
n.AddBuffHuntingMark(e)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[14],t[15])
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local a=t[5]
local a=h.HeroBattleInfo:GetBuff(a)
if a then
local a=t[8]
local o=t[9]
local t={t[10],t[11],t[12],t[13]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
n.AddBuffHuntingMark(e,h)
end
elseif a.buffTriggerTime==BuffTriggerTime.evade then
if s and i.isPetTrigger==false and i.isTeamAttack~=true then
local a=1
local n=303110901
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if a then
local h=a:GetFloors()
local a=t[18]
if h>=a then
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,n,a)
local n=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.SmallSkillId
local h={
defHeroIds={s.HeroId},
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local s=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,n)
if s==nil then
o:AddTriggerAttackTask(n,a,h,i)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[19])
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.evade)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffHuntingMark(e)
local a=e:GetBuffData()
local i=a[5]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#t do
local e=t[e].HeroBattleInfo:GetBuff(i)
if e then
return
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eBack)
local t,o=o:FindMostSmallDef(t)
if t then
local a=a[6]
local o={}
t:AddBuff(e.CurrHeroCtrl,i,a,o)
end
end
function a.GetRateHuntingMark(e,t)
local e=e:GetBuffData()
local a=e[5]
local t=t.HeroBattleInfo:GetBuff(a)
if t then
return e[7]
end
return 0
end
function a.AddBuffBloodPower(e,o)
local t=e:GetBuffData()
local a=t[16]
local i=t[17]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,t,o)
end
return n

