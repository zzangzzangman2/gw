local e=false
local t=nil
function OnInit(e,e)
LuaUtils.SetActive(UI_BattleBoxPage.transform,true)
local e=UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Init()
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Hide,OnSkill_BattleUI_Hide)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Show,OnSkill_BattleUI_Show)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Reset,OnSkill_BattleUI_Reset)
EventSystem.AddListener(CommonEventId.Skill_HideHero_Begin,OnSkill_HideHero_Begin)
EventSystem.AddListener(CommonEventId.Skill_HideHero_End,OnSkill_HideHero_End)
e=false
SetBattleCanvasGroupAlpha(1)
t=t or{}
if ModulesInit.ProcedureNormalBattle.dropBoxData and#ModulesInit.ProcedureNormalBattle.dropBoxData>0 then
LuaUtils.SetActive(UI_BattleBoxPage.transform,true)
local e=UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Open({})
else
LuaUtils.SetActive(UI_BattleBoxPage.transform,false)
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Hide,OnSkill_BattleUI_Hide)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Show,OnSkill_BattleUI_Show)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Reset,OnSkill_BattleUI_Reset)
EventSystem.RemoveListener(CommonEventId.Skill_HideHero_Begin,OnSkill_HideHero_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_HideHero_End,OnSkill_HideHero_End)
StopUIShowTweener()
if ModulesInit.ProcedureNormalBattle.dropBoxData and#ModulesInit.ProcedureNormalBattle.dropBoxData>0 then
local e=UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
end
end
function Refresh()
end
function OnBeforeDestroy()
end
function OnWillClose()
end
function OnSkill_BattleUI_Hide(t)
if(ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd)then
return
end
if e==true then
return
end
e=true
StopUIShowTweener()
SetBattleCanvasGroupAlpha(0)
end
function SetBattleCanvasGroupAlpha(t)
local e=root_battle:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
e.alpha=t
end
function OnSkill_BattleUI_Show(t)
if(ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd)then
return
end
if e==false then
return
end
e=false
StopUIShowTweener()
if(t.ShowOrHideType==CS.MyCommonEnum.ShowOrHideType.Immediately)then
SetBattleCanvasGroupAlpha(1)
else
SetBattleCanvasGroupAlphaWithAnim(0.5,1,t.FadeIn)
end
end
function OnSkill_BattleUI_Reset()
e=false
StopUIShowTweener()
SetBattleCanvasGroupAlpha(1)
end
function OnSkill_HideHero_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd)then
return
end
local t=t.DynamicTarget
if CheckShow3DUIVisibleByDynamicTarget(t)then
if e==true then
return
end
e=true
StopUIShowTweener()
SetBattleCanvasGroupAlpha(0)
end
end
function OnSkill_HideHero_End(t)
if(ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd)then
return
end
local a=t.DynamicTarget
if CheckShow3DUIVisibleByDynamicTarget(a)then
if e==false then
return
end
e=false
StopUIShowTweener()
if(t.FadeIn==0)then
SetBattleCanvasGroupAlpha(0)
else
SetBattleCanvasGroupAlphaWithAnim(0.5,1,t.FadeIn)
end
end
end
function CheckShow3DUIVisibleByDynamicTarget(e)
if e==CS.MyCommonEnum.DynamicTarget.OurAll
or e==CS.MyCommonEnum.DynamicTarget.EnemyAll
or e==CS.MyCommonEnum.DynamicTarget.EnemyOther
or e==CS.MyCommonEnum.DynamicTarget.AllOthers
or e==CS.MyCommonEnum.DynamicTarget.OurOther then
return true
elseif e==CS.MyCommonEnum.DynamicTarget.OurOne
or e==CS.MyCommonEnum.DynamicTarget.EnemyOne
or e==CS.MyCommonEnum.DynamicTarget.OneToEnemyOne
then
end
return false
end
function SetBattleCanvasGroupAlphaWithAnim(e,a,o)
t=CS.DG.Tweening.DOTween.To(
function()
return e
end,
function(t)
e=t
end,
a,
o
):OnUpdate(
function()
SetBattleCanvasGroupAlpha(e)
end
)
end
function StopUIShowTweener()
if t then
t:Kill()
t=nil
end
end

