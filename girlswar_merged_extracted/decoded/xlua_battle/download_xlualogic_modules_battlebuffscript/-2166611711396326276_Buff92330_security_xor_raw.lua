local n=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local i=t.addBuffId
local h=t.triggerSkillAtkType
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if(n:IsCtlBuffWithResponse(i)and t)then
if o.CheckCondition(e,a)==false then
return
end
if(a[1]>=RandomMgr:GetBattleRandom())then
local s=e.CurrHeroCtrl.HeroId
local o=a[2]
local i
local r=t:GetBuffData()
i=table.deepCopy(r)
local t={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
ignoreControl=true,
defHeroIds={t.releaseHeroId},
ctrlBuffId=t.buffId,
ctrlBuffRound=t.round,
ctrlBuffData=i,
trigerBuffData=a,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,s)
if e==nil then
local e={
triggerSkillAtkType=h
}
n:AddTriggerAttackTask(s,o,t,e)
end
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(t,e)
if e[9]~=nil and ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e[9]<e[3]then
return false
end
return true
end
function t.HandleOnDoAction(t,e,a)
if o.CheckCondition(t,e)==false then
return false
end
e[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
return true
end
return o

