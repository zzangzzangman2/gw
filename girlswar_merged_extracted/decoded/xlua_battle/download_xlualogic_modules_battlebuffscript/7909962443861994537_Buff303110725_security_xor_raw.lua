local i=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckAttackAll(e)
local e=e:GetBuffData()
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[4]=0
end
if e[4]>=e[1]then
return false
end
return true
end
function e.CheckUpSmallSkillRate(e)
local e=e:GetBuffData()
if e[7]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[7]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[6]=0
end
if e[6]>=e[3]then
return false
end
e[6]=e[6]+1
e[8]=e[8]+1
return true
end
function e.GetUpSmallSkillRate(e)
local e=e:GetBuffData()
return e[2]*e[8]
end
function e.AddAttackTask(e,t,t)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local t=31107321
local o={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
i:AddTriggerAttackTask(a,t,o,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.HandleOnDoAction(t,a)
local e=true
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for t=1,#e do
if e[t].HeroBattleInfo:GetBuff(303110709)==nil then
return false
end
end
if o.CheckAttackAll(t)==false then
return false
end
a[4]=a[4]+1
return true
end
return o

