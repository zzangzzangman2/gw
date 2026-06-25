local a=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,s,n,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
t.ChooseFriend(e)
elseif a.buffTriggerTime==BuffTriggerTime.teamHeroDead then
if(n.HeroId==o[10])then
t.ChooseFriend(e)
end
elseif a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if i.heroId==o[10]and i.triggerSkillType==AttackType.BigSkill then
local a=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable()
local a=a[1]
o[11]=a or 0
t.AddAttackTask(e)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.allHeroSkillAttackComplete)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ChooseFriend(o)
local e=o:GetBuffData()
e[10]=0
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o.CurrHeroCtrl,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
if#t>0 then
local i={}
for e=1,#t do
if t[e]:IsDeathOrWaitState()==false then
table.insert(i,t[e])
end
end
local t=a:FindMostBigAtk(i)
if t then
e[10]=t.HeroId
local n=e[3]
local i=e[4]
local a={}
for o=5,9 do
table.insert(a,e[o])
end
t:AddBuff(o.CurrHeroCtrl,n,i,a)
end
end
end
function e.GetFriend(e)
local e=e:GetBuffData()
return a:GetTargetHeroCtrl(e[10])
end
function e.GetTargetEnemy(e)
local e=e:GetBuffData()
return a:GetTargetHeroCtrl(e[11])
end
function e.AddAttackTask(e,t)
local t=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroId
local t=t[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if i==nil then
a:AddTriggerAttackTask(o,t,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.HandleOnDoAction(e,a,a)
local a=t.GetTargetEnemy(e)
local e=t.GetFriend(e)
if(a==nil and e==nil)then
return false
end
return true
end
return t

