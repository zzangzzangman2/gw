local n=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.DoAddFury
or a.buffTriggerTime==BuffTriggerTime.DoAddFuryWithReset then
if e.CurrHeroCtrl:IsFullFuryWithFury(o.oldFury)==false and e.CurrHeroCtrl:IsFullFury()then
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
t[8]=e.CurrHeroCtrl.HeroBattleInfo.CurrHP
elseif a.buffTriggerTime==BuffTriggerTime.skillComplete then
local a=t[8]-e.CurrHeroCtrl.HeroBattleInfo.CurrHP
if a>0 then
local t=e.CurrHeroCtrl:GetHPPerByHp(a)*t[4]*OneMillion/t[3]
t=math.floor(t)
if t>0 then
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.DoAddFury
or e==BuffTriggerTime.DoAddFuryWithReset
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.skillComplete)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddPursuitAttack(e,s)
local i=e:GetBuffData()
if(i[5]<RandomMgr:GetBattleRandom())then
return
end
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 and o.CheckCondition(e,i)then
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
defHeroIds=s
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
n:AddTriggerAttackTask(a,t,e,o)
end
end
end
function t.CheckCondition(t,e)
if e[7]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[7]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[6]=0
end
if e[6]<e[1]then
return true
end
return false
end
function t.HandleOnDoAction(t,e)
if o.CheckCondition(t,e)==false then
return false
end
e[6]=e[6]+1
return true
end
return o

