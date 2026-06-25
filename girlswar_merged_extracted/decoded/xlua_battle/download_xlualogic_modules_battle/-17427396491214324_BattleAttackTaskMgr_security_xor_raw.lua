local s=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local e=Class("BattleAttackTaskMgr",{})
local a={
Ready=0,
WaitBigSkill=1,
RunningBigSkill=2,
WaitNormalSkill=3,
RunningNormalSkill=4,
WaitPetFightSkill=5,
RunningPetFightSkill=6,
WaitTeamFightSkill=7,
RunningTeamFightSkill=8,
}
function e:Create()
local e=e:New()
e:Init()
return e
end
function e:Init()
self:ResetData()
end
function e:ResetData()
self._attackTaskArr={}
self._curAttackTask=nil
self._curState=a.Ready
self._isRunning=false
end
function e:Dispose()
self:ResetData()
end
function e:ChangeState(e)
self._curState=e
end
function e:IsWork()
return self._isRunning==true
end
function e:Resume()
if self._curState==a.WaitBigSkill then
self:ExcuteTask(self._curAttackTask,false)
end
end
function e:AddTask(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if e.insertLevel==nil or e.insertLevel==ETriggerSkillInsertLevel.OtherAttack then
table.insert(self._attackTaskArr,e)
else
local t=false
for a=1,#self._attackTaskArr do
local o=self._attackTaskArr[a].insertLevel
if o==nil or e.insertLevel>o then
table.insert(self._attackTaskArr,a,e)
t=true
break
end
end
if t==false then
table.insert(self._attackTaskArr,e)
end
end
self:CheckStartTask()
end
function e:CheckStartTask()
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
return
end
self._isRunning=true
self:CheckExcuteNextTask()
end
function e:CheckExcuteNextTask()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
self:AllTaskComplete()
return
end
if self._curAttackTask~=nil then
return
end
self:ExcuteNextTask()
end
function e:ExcuteNextTask()
self:ChangeState(a.Ready)
local e=self:GetNextAttackTask()
if e~=nil then
self:ExcuteTask(e,true)
else
self:AllTaskComplete()
end
end
function e:ExcuteTask(e,o)
local a=false
self._curAttackTask=e
local t=ModulesInit.ProcedureNormalBattle.HeroDic[e.heroId]
if t~=nil then
if e.skillData and e.skillData.needResetBeforeAction==true then
local a=e.skillData
if a and a.buffId then
local a=a.buffId
e=t:ResetBeforeAction(e)
end
end
if e then
self._curAttackTask=e
if e.actionType==EBattleActionType.BigSkill then
a=self:CheckExcuteBigTask(t,e,o)
elseif e.actionType==EBattleActionType.NormalOrSmallSkill then
a=self:CheckExcuteNormalTask(t,e)
elseif e.actionType==EBattleActionType.PetFightSkill then
a=self:CheckExcutePetFightTask(t,e)
end
end
else
if e.teamId then
local t=ModulesInit.ProcedureNormalBattle.GetTeamsByTeamId(e.teamId)
if t then
a=self:CheckExcuteTeamFightTask(t,e)
end
end
end
if a==false then
self._curAttackTask=nil
self:CheckExcuteNextTask()
end
end
function e:AllTaskComplete()
self:ResetData()
ModulesInit.ProcedureNormalBattle.HandleAttackTaskComplete()
end
function e:HandleTaskComplete(e)
if e then
e:CheckRestoreUnderControlTransferSkin()
end
ModulesInit.ProcedureNormalBattle.RefreshHeroHud()
self:ChangeState(a.Ready)
self._curAttackTask=nil
if(ModulesInit.ProcedureNormalBattle.CheckBattleEnd())then
ModulesInit.ProcedureNormalBattle.BattleRoundEndCheckBuff()
self:AllTaskComplete()
return
end
self:CheckExcuteNextTask()
end
function e:CheckExcuteBigTask(t,e,r)
local o=e and e.skillDid
local n=true
local h=false
if e and e.skillData then
if e.skillData.costMp~=nil then
n=e.skillData.costMp
end
if e.skillData.ignoreControl~=nil then
h=e.skillData.ignoreControl
end
end
local i=o
if i==nil or i==0 then
i=t.BigSkillId or 0
end
if t~=nil and t:GetCanBigAttack(o~=nil,n,h)then
local i,h=t:DoActionBeforeSkill(i,e)
if i then
if t:GetCanBigAttack(o~=nil,n)==false or h==true then
local e=true
local a=s.GetEntity(o)
if a then
e=false
end
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil and e==true)then
FightDataReportMgr:AddBattleAction(t.HeroId,ModulesInit.ProcedureNormalBattle.GetSelectFireHeroId(),1)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
local i,o=t:CheckDoAction(e)
if i==false then
return false
end
if o~=nil then
e.skillData=o
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle and r)then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_ATTACK_READY"})
if t:GetBigAttackWaiting()==true then
self:ChangeState(a.WaitBigSkill)
return true
end
end
self:ExcuteBigTask(t,e)
return true
end
return false
end
function e:ExcuteBigTask(t,e)
self:ChangeState(a.RunningBigSkill)
if e.fireHeroId~=nil then
ModulesInit.ProcedureNormalBattle.SetSelectFireHeroWithId(e.fireHeroId)
end
t:BigAttack(e,function()
self:HandleTaskComplete(t)
end
)
end
function e:CheckExcuteNormalTask(e,t)
local a=t and t.skillDid
local o=a
if o==nil or o==0 then
if e.CurrRoundCanTriggerSmallSkill then
o=e.SmallSkillId or 0
else
o=e.NormalSkillId or 0
end
end
local i=false
if t and t.skillData then
if t.skillData.ignoreControl~=nil then
i=t.skillData.ignoreControl
end
end
if e~=nil and e:GetCanNormalAttack(false,a~=nil,i)then
local o,i=e:DoActionBeforeSkill(o,t)
if o then
if e:GetCanNormalAttack(false,a~=nil)==false or i==true then
local t=true
local o=s.GetEntity(a)
if o then
t=false
end
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil and t==true)then
FightDataReportMgr:AddBattleAction(e.HeroId,ModulesInit.ProcedureNormalBattle.GetSelectFireHeroId(),2)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
local o,a=e:CheckDoAction(t)
if o==false then
return false
end
if a~=nil then
t.skillData=a
end
self:ExcuteNormalTask(e,t)
return true
end
return false
end
function e:ExcuteNormalTask(t,e)
self:ChangeState(a.RunningNormalSkill)
if e.fireHeroId~=nil then
ModulesInit.ProcedureNormalBattle.SetSelectFireHeroWithId(e.fireHeroId)
end
t:NormalAttack(e,
function()
self:HandleTaskComplete(t)
end
)
end
function e:CheckExcutePetFightTask(t,e)
local o=e and e.skillDid
local a=o
if a==nil or a==0 then
a=t.PetFightSkillId
end
if t~=nil and t:GetCanPetFightAttack(a,e.triggerTime,o~=nil)then
local i,n=t:DoActionBeforeSkill(a,e)
if i then
if t:GetCanPetFightAttack(a,e.triggerTime,o~=nil)==false or n==true then
return false
end
end
local o,a=t:CheckDoAction(e)
if o==false then
return false
end
if a~=nil then
e.skillData=a
end
self:ExcutePetFightTask(t,e)
return true
end
return false
end
function e:ExcutePetFightTask(t,e)
self:ChangeState(a.RunningPetFightSkill)
if e.fireHeroId~=nil then
ModulesInit.ProcedureNormalBattle.SetSelectFireHeroWithId(e.fireHeroId)
end
t:PetFightAttack(e,
function()
self:HandleTaskComplete(t)
end
)
end
function e:CheckExcuteTeamFightTask(t,e)
if t==nil then
return false
end
local a=e and e.skillDid
local a=a
if a and a>0 then
local o,a=t:CheckDoAction(e)
if o==false then
return false
end
if a~=nil then
e.skillData=a
end
self:ExcuteTeamFightTask(t,e)
return true
end
return false
end
function e:ExcuteTeamFightTask(t,e)
self:ChangeState(a.RunningTeamFightSkill)
if e.fireHeroId~=nil then
ModulesInit.ProcedureNormalBattle.SetSelectFireHeroWithId(e.fireHeroId)
end
t:TeamFightAttack(e,
function()
self:HandleTaskComplete()
end
)
end
function e:GetNextAttackTask()
local e=nil
if#self._attackTaskArr>0 then
e=table.remove(self._attackTaskArr,1)
end
return e
end
function e:GetAttackTaskBySkillDidAndHeroId(a,o,t)
for e=1,#self._attackTaskArr do
local e=self._attackTaskArr[e]
if e.skillDid==a and e.heroId==o then
local a=true
if t and e.skillData then
for t,o in pairs(t)do
if e.skillData[t]~=o then
a=false
break
end
end
end
if a then
return e
end
end
end
return nil
end
function e:GetAttackTaskBySkillDidAndTeamId(t,a)
for e=1,#self._attackTaskArr do
local e=self._attackTaskArr[e]
if e.skillDid==t and e.teamId==a then
return e
end
end
return nil
end
return e 
