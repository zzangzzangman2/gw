local i=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
h.AddAttackTask(e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal},"isNormal")
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMaxFinalAtk)
if a then
local o=t[16]
if o~=a.HeroId then
local i=t[8]
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if o then
o.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
t[16]=a.HeroId
local n=t[9]
local o={}
for e=10,15 do
table.insert(o,t[e])
end
table.insert(o,{})
a:AddBuff(e.CurrHeroCtrl,i,n,o)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddAttackTask(e,n,o)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local t=t[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
triggerType=o
}
local s=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a,e)
if s==nil then
i:AddTriggerAttackTask(a,t,e,n)
else
if s.skillData.triggerType~=o then
i:AddTriggerAttackTask(a,t,e,n)
end
end
end
return h

