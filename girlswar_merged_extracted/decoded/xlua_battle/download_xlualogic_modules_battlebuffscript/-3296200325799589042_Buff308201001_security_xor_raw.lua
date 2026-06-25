local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e.CurrHeroCtrl.HeroId
local t=t[1]
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
defHeroId=0
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
n:AddTriggerAttackTask(a,t,o,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.ChooseTarget(i)
local t=i:GetBuffData()
local e=nil
local a=t[8]
if a~=0 then
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if e==nil then
if t[7]<=0 then
return nil
end
else
if e:CheckHeroCanDoAction()==false then
return nil
end
end
end
if e==nil then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i.CurrHeroCtrl,BattleHeroType.eBack)
if(o==nil or#o<=0)then
return nil
end
if t[4]>0 or t[5]>0 or t[6]>0 then
local i=n:SortHeroByFinalHighAtk(o)
local o={}
local a=0
for e=1,#i do
a=a+t[4+e-1]
local e={
weight=a,
enemy=i[e],
}
table.insert(o,e)
end
local a=RandomMgr:GetBattleRandomWithRange(1,a)
for t=1,#o do
local t=o[t]
if a<=t.weight then
e=t.enemy
break
end
end
end
if e==nil then
local t=RandomTableWithSeed(o,1)
e=t[1]
end
if e then
local o=t[2]
local a=t[3]
local t={}
e:AddBuff(i.CurrHeroCtrl,o,a,t)
end
end
if e then
t[8]=e.HeroId
end
return e
end
function a.HandleOnDoAction(a,t,e)
local a=s.ChooseTarget(a)
if a==nil then
return false
end
e.skillData.defHeroId=a.HeroId
if e.skillDid==82010491 then
t[9]=t[9]+1
end
return true
end
function a.AddAttackTask(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local t=82010491
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
defHeroId=0
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
n:AddTriggerAttackTask(a,t,o,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return s

