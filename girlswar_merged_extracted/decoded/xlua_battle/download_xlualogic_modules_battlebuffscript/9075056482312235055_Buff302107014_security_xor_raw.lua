local i=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,o,t,t,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local t=o[1]
if e.CurrHeroCtrl then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t.injureId,t.injureValue)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay then
local t=o[2]
for a=1,#t do
local t=t[a]
if t.curAttackInBigGround~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t.curAttackInBigGround=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t.curAttackCount=0
end
if t.curAttackCount<t.totalAttackCount then
t.curAttackCount=t.curAttackCount+1
local t=t.srcHeroId
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if a then
local a=a.BigSkillId
local o=ETriggerSkillAtkType.AsistAttack
if t==e.CurrHeroCtrl.HeroId then
o=ETriggerSkillAtkType.PursuitAttack
end
local o={
triggerSkillAtkType=o,
costMp=false,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
i:AddTriggerAttackTask(t,a,o,n)
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddNewHero(a,t)
local e=a:GetBuffData()
table.insert(e[2],t)
local e=e[1]
if e and e.injureResValue
and t and t.injureResValue then
if e.injureResValue<t.injureResValue then
e=t
if a.CurrHeroCtrl then
a.CurrHeroCtrl:CheckAddBuffValue(a.buffId,e.injureResId,e.injureResValue)
end
end
end
end
return n

