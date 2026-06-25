local r=require("Modules/Battle/BattleUtil")
local t={}
local d=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.shield,t[1])
e.isExec=true
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleShieldRemoveBefore(e,h)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e:GetBuffData()
if a[2]<=0 then
return
end
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(h)
if o==nil then
return
end
if o.IsOurHero==e.CurrHeroCtrl.IsOurHero then
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleJiuseluExplodeEffect,e.x,e.y,50,3,0,false,function()
end)
end
local n=81005399
local i=e.teamId
local t={}
local s=a[1]
if o:IsPet()==false then
if ModulesInit.ProcedureNormalBattle.CheckTargetCondition(o)then
local e=math.floor(s*a[2]*MillionCoe)
local e={
heroId=h,
realhurt=e,
}
table.insert(t,e)
end
else
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(i,BattleHeroType.enemyAll)
local o=math.floor(s*a[3]*MillionCoe)
local a=#e
for a=1,a do
local e=e[a]
local e={
heroId=e.HeroId,
realhurt=o,
}
table.insert(t,e)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(n,i)
if a then
local e=a.skillData
local a=e.defHeroDatas
local e={}
for a=1,#t do
local t=t[a]
local a=t.heroId
e[a]=t
end
for t=1,#a do
local t=a[t]
local a=t.heroId
if e[a]then
t.realhurt=t.realhurt+e[a].realhurt
e[a]=nil
end
end
for o=1,#t do
local t=t[o]
local o=t.heroId
if e[o]then
table.insert(a,t)
end
end
return
end
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e.teamId,
defHeroDatas=t,
insertLevel=ETriggerSkillInsertLevel.DisruptAttack,
}
r:AddTriggerTeamAttackTask(i,n,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
return d

