local s=require("Modules/Battle/BattleUtil")
local i={43206,43207,43208,43209}
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,h)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if h.buffTriggerTime==BuffTriggerTime.attacked then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfColumn)
if#a>0 then
for i=1,#a do
local s=t[1]
local n=t[2]
local o=0
if a[i].HeroId==e.CurrHeroCtrl.HeroId then
o=1
end
local t={t[3],o,e.CurrHeroCtrl.HeroBattleInfo.MaxHP}
a[i]:AddBuff(e.CurrHeroCtrl,s,n,t)
end
end
elseif h.buffTriggerTime==BuffTriggerTime.now then
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[12]==1 then
local h=t[10]
local r=t[11]
local d={}
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(h)
if a then
n.TriggerHighSkill(e,t,o)
else
local a=0
for t=1,#i do
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i[t])
if e then
a=a+1
end
end
if a>=#i then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,h,r,d)
n.TriggerHighSkill(e,t,o)
elseif a>0 then
local e=e.teamId
local i=t[4]
local t={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e,
enemyCount=a,
skillParam={t[5],t[6]},
}
s:AddTriggerTeamAttackTask(e,i,t,o)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.TriggerHighSkill(t,e,a)
local t=t.teamId
local o=e[7]
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=t,
skillParam={e[8],e[9]},
}
s:AddTriggerTeamAttackTask(t,o,e,a)
end
return n

