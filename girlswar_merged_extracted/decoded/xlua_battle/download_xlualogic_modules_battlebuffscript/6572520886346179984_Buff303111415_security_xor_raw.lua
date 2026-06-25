local s=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local a=t[5]
local o=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif a.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if o.IsOurHero~=e.CurrHeroCtrl.IsOurHero then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for a=1,#e do
local o=e[a].HeroId
local i=t[9]*MillionCoe
if e[a]:CurrHPPer()>=i or t[11][o]==nil then
t[11][o]=true
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
local a={}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#o do
local i=0
local i=o[e].HeroId
local n=t[9]*MillionCoe
if o[e]:CurrHPPer()<n and t[11][i]==true then
table.insert(a,i)
end
end
if#a>0 then
local a=RandomTableWithSeed(a,1)
local a=a[1]
t[11][a]=false
local o=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 then
local a={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
defHeroId=a,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if e==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
s:AddTriggerAttackTask(o,t,a,e)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=303111405
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffShadowHunt(e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.allHeroSkillAttackComplete
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

