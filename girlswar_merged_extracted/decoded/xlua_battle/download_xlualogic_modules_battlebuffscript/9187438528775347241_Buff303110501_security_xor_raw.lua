local o=require("Modules/Battle/BattleUtil")
local n=require("Modules/Battle/Formula")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=t[3]
local a=t[4]
local i={t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i)
local o=t[7]
local i=t[8]
local a={t[9],t[10]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
local o=t[11]
local a=t[12]
local i={t[13],t[14]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i,t[15])
e.CurrHeroCtrl.minFinalAtk=n:CalculateHeroFinalAtk(e.CurrHeroCtrl)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart
or a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>e.CurrHeroCtrl.appearBattleBigRound then
if o.IsBigRoundStart(a.buffTriggerTime,e.CurrHeroCtrl)then
local t=t[11]
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,t,1)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddSwordMaster(e,i)
local t=e:GetBuffData()
local a=t[1]
local t=t[2]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o,i)
end
function a.RemoveSwordMaster(e)
local t=e:GetBuffData()
local t=t[1]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
function a.CheckAddSwordMaster(t,o,a)
local e=t:GetBuffData()
if e[17]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[17]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[16]=0
end
if e[16]>=a then
return
end
e[16]=e[16]+1
i.AddSwordMaster(t,o)
end
function a.AddPursuitAttackIchinotaka(e,n,i)
local t=e.CurrHeroCtrl.HeroId
local a=31105304
local i={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillParam=i
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
local e={
triggerSkillAtkType=n
}
o:AddTriggerAttackTask(t,a,i,e)
end
end
function a.AddPursuitAttackIchinotakaCritial(e,n,i,s)
local a=e.CurrHeroCtrl.HeroId
local t=31105306
local i={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
realhurt=n,
defHeroId=i,
maxTimes=s,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
o:AddTriggerAttackTask(a,t,i,e)
end
end
function a.HandleOnDoAction(e,n,t)
local a=t.skillDid
if a==31105304 then
local a=n[1]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local a=0
if e then
a=e:GetFloors()
end
local e=t.skillData
local e=e.skillParam
if a<e[1]then
return false
end
return true
elseif a==31105306 then
local t=t.skillData
local a=t.maxTimes
local t=t.defHeroId
if i.CheckTriggerDeadQuick(e,a)==false then
return false
end
local t=o:GetTargetHeroCtrl(t)
if t==nil then
return false
end
i.AddDeadQuickFinishCount(e,1)
return true
end
return false
end
function a.CheckTriggerDeadQuick(t,e)
local t=t:GetBuffData()
if t[18]>=e then
return false
end
return true
end
function a.AddDeadQuickFinishCount(e,t)
local e=e:GetBuffData()
e[18]=e[18]+t
end
return i

