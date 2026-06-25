local n=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o,s,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=t.GetLeftCount(e,a)
if o<=0 then
return false
end
local i=e.CurrHeroCtrl.HeroId
local o=a[1]
local e=t.GetSkillData(e,a)
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,i)
if t==nil then
n:AddTriggerAttackTask(i,o,e,s)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetSkillData(e,t)
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
defHeroIds={}
}
return e
end
function e.GetLeftCount(t,e)
local e=math.max(0,e[3]-e[4])
return e
end
function e.HandleOnDoAction(i,e)
local n=t.GetLeftCount(i,e)
if n<=0 then
return false
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i.CurrHeroCtrl,BattleHeroType.ourAll)
if(o==nil)then
return false
end
local a={}
for t=1,#o do
local t=o[t]
local o=t:CurrHPPer()
if o<e[2]*MillionCoe then
table.insert(a,t.HeroId)
end
end
local s=#a
if s<=0 then
return false
end
local o={}
if s<=n then
e[4]=e[4]+s
o=a
else
e[4]=e[3]
o=RandomTableWithSeed(a,n)
end
local e=t.GetSkillData(i,e)
e.defHeroIds=o
return true,e
end
return t

