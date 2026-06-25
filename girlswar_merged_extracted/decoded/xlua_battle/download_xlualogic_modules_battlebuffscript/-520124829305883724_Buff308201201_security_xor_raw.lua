local r=require("Modules/Battle/BattleUtil")
local a={}
local o=a
local h={308201202,308201203,308201204}
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,s,n,a,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif i.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if a.teamId~=t.CurrHeroCtrl:GetTeamId()and a.triggerSkillType==AttackType.BigSkill then
e[2]=e[2]+1
if e[2]>=e[4]then
e[2]=0
o.AddAttackTask(t,ETriggerSkillAtkType.Normal,false)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.allHeroAfterSufferDmg then
if n.IsOurHero==t.CurrHeroCtrl.IsOurHero
or a.actionType~="buff"then
return
end
o.CheckDamage(t,e,a.hurtValue)
elseif i.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if n.IsOurHero==t.CurrHeroCtrl.IsOurHero
or s.HeroId==t.CurrHeroCtrl.HeroId then
return
end
local a=a.reduceHpValue
o.CheckDamage(t,e,a)
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if#e>=26 then
local r=e[9]
local a=e[10]
local s={}
for t=11,15 do
table.insert(s,e[t])
end
local d=e[16]
local a=e[17]
local n={}
for t=18,22 do
table.insert(n,e[t])
end
local l=e[23]
local a=e[24]
local i={}
for t=25,26 do
table.insert(i,e[t])
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=#e
for a=1,a do
local a=e[a]
local o={}
for e=1,#h do
local t=h[e]
local e=a.HeroBattleInfo:GetBuff(t)
if e then
local e={
buffId=t,
round=e:GetRound(),
floors=e:GetFloors(),
}
table.insert(o,e)
a.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
for e=1,#o do
local e=o[e]
if e.buffId==308201202 then
a:AddBuff(t.CurrHeroCtrl,d,e.round,n,e.floors)
elseif e.buffId==308201203 then
a:AddBuff(t.CurrHeroCtrl,l,e.round,i,e.floors)
elseif e.buffId==308201204 then
a:AddBuff(t.CurrHeroCtrl,r,e.round,s,e.floors)
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.allHeroAfterSufferDmg
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddAttackTask(e,i,t)
local a=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroId
local a=a[1]
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
triggerType=i,
byHp=t,
byAttack=t==false,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if e==nil then
r:AddTriggerAttackTask(o,a,i,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
elseif e.skillData then
if e.skillData.byHp==false and t==true then
e.skillData.byHp=true
elseif e.skillData.byAttack==false and t==false then
e.skillData.byAttack=true
end
end
end
function a.CheckDamage(t,e,a)
if e[5]>0 and e[6]>0 then
e[3]=e[3]+a
local a=t.CurrHeroCtrl:GetEnemyTeamMaxHP()
if e[3]>=e[5]*a*MillionCoe then
e[3]=0
if e[6]>=RandomMgr:GetBattleRandom()then
o.AddAttackTask(t,ETriggerSkillAtkType.Normal,true)
end
end
end
end
return o

