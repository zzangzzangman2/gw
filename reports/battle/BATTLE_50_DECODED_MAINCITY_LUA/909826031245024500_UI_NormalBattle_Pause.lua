function OnInit(e,e)
BT_jixu.onClick:AddListener(
function()
ModulesInit.ProcedureNormalBattle.ResumeGame()
GameTools.CloseUIForm(UIFormId.UI_NormalBattle_Pause)
end
)
BT_chetui.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_NormalBattle_Pause)
ModulesInit.ProcedureNormalBattle.Dispose(false)
GameTools:SetTimeScale(SetTimeScaleType.Battle,1)
ModulesInit.ProcedureNormalBattle.SetBattleEnd(true)
if ModulesInit.ProcedureNormalBattle.IsTestMode==true then
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
return
end
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.trial)then
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.Tower)
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign)then
GameEntry.UI:OpenUIForm(
UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Cloud,
loadResFinish=function()
ModulesInit.ExpeditionManager.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
}
)
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.elite)then
ModulesInit.EliteMgr:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.burningBuild)then
ModulesInit.ActBurningBuildMgr:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.carnival)then
ModulesInit.ActCarnivalManager:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.newCarnival)then
ModulesInit.ActCarnivalNewManager:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.bigBoss)then
ModulesInit.ActBigBossMgr:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze)then
ModulesInit.MazeMgr:backToMaze()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.cityWar)then
ModulesInit.SkyCityMgr:LeaveBattleBackSkyCityView()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.richMan)then
ModulesInit.SkyCityMgr:LeaveBattleBackRichmanView()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.friendArena)then
ModulesInit.FriendManage:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.thiefCrusade)then
ModulesInit.CrusadeAgainstMgr.isOpenCrusadeAgainst=true
ModulesInit.ExpeditionManager.isForm=true
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end})
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.unionCraft)then
ModulesInit.CSGuildWarManager:EnterWarProcedure()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.guildTrials)then
ModulesInit.GuildTrialsMgr:GoBack()
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.GoldHoliday)then
ModulesInit.ActGoldHolidayMgr:GoBack()
else
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
end
)
end
function OnOpen(e)
ModulesInit.ProcedureNormalBattle.PauseGame()
end
function OnClose()
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

