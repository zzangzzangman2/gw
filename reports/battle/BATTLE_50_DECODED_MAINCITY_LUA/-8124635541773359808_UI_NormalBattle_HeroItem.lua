local e={}
function e:New(t)
local e={
ownerUIForm=nil,
heroCtrl=nil,
heroItemTrans=nil,
tweenAnimation=nil,
tweenAnimationIconBG=nil,
IsDisEnable=false,
imgIconBG=nil,
imgIconBGAnim=nil,
imgHeadIcon=nil,
im_frame=nil,
im_zhiye=nil,
im_quality=nil,
imgHPBG=nil,
imgFury=nil,
im_pow=nil,
im_power_beans_bg=nil,
im_power_beans=nil,
btnAttack=nil,
UIEffect_AllSkillNew=nil,
UIEffect_AllSkillNewTrans=nil,
UIEffect_BigSkill=nil,
UIEffect_BigSkillTrans=nil,
im_BigSkill=nil,
UIEffect_SmallSkill=nil,
im_SmallSkill=nil,
txtBeControl=nil,
UIEffect_meili=nil,
UIEffect_normalSkill=nil,
UIEffect_Fury_Container=nil,
UIEffect_Fury=nil,
ui_touxiangsg=nil,
starts={},
IsLongPress=false,
onSkill_BattleUI_Hide=nil,
onSkill_BattleUI_Show=nil,
needHideEffect={},
OnPressDown=nil,
OnPressUp=nil,
MouseDown=nil,
MouseUp=nil,
OnShowClickEffect=nil,
attackLimitType=EBattleAttackLimitType.None,
}
setmetatable(e,self)
self.__index=self
e.ownerUIForm=t
return e
end
function e:Load(e,o,a,t)
self.heroCtrl=e
self.IsLongPress=false
self.heroCtrl.OnFuryChange=function()
self:OnFuryChange()
end
self.heroCtrl.OnBeansStatFuryChange=function(e,t)
self:OnBeansStatFuryChange(e,t)
end
self.heroCtrl.OnShowBeans=function(e)
self:OnShowBeans(e)
end
GameEntry.Pool:GameObjectSpawn(
SysPrefabId.UI_NormalBattle_HeroItem,
nil,
function(e,i,i)
self.heroItemTrans=e
self.tweenAnimation=e:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
self.tweenAnimation.endValueFloat=self.tweenAnimation.endValueFloat*UIScale
self.tweenAnimationIconBG=e:Find("imgIconBG/tweener"):GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
self.tweenAnimationIconBG.endValueFloat=self.tweenAnimationIconBG.endValueFloat*UIScale
self.heroItemTrans:SetParent(o)
self.heroItemTrans.anchoredPosition=Vector2(a-((t-1)*120),0)
self.heroItemTrans.localScale=self.heroItemTrans.localScale*UIScale
self.imgIconBG=e:Find("imgIconBG"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self.imgIconBGAnim=e:Find("imgIconBG"):GetComponent(typeof(CS.UnityEngine.Animator))
self.imgHeadIcon=e:Find("imgIconBG/tweener/imgHeadIcon"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.im_frame=e:Find("imgIconBG/tweener/im_frame"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.im_zhiye=e:Find("imgIconBG/tweener/im_zhiye"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.im_quality=e:Find("imgIconBG/tweener/im_quality"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.imgHPBG=e:Find("HeadBar/imgHPBG"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self.imgFury=e:Find("HeadBar/imgHPBG/imgFury"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self.im_pow=e:Find("HeadBar/im_pow"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self.im_power_beans_bg=e:Find("HeadBar/im_power_beans_bg"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self.im_power_beans=e:Find("HeadBar/im_power_beans_bg/im_power_beans"):GetComponent(typeof(CS.UnityEngine.UI.Image))
self:OnShowBeans(false)
self.imgMask=e:Find("imgMask"):GetComponent(typeof(CS.UnityEngine.UI.Image))
for t=1,7 do
table.add(self.starts,e:Find(string.format("imgIconBG/tweener/starts/im_start%s",t)))
end
self.UIEffect_AllSkillNew=e:Find("imgIconBG/tweener/UIEffect_AllSkillNew")
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
self:LoadAllSkillNewEffect()
self.UIEffect_BigSkill=e:Find("imgIconBG/tweener/UIEffect_BigSkill")
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
self:LoadBigSkillEffect()
self.im_BigSkill=e:Find("imgIconBG/tweener/im_BigSkill")
LuaUtils.SetActive(self.im_BigSkill,false)
self.UIEffect_SmallSkill=e:Find("imgIconBG/tweener/UIEffect_SmallSkill")
LuaUtils.SetActive(self.UIEffect_SmallSkill,false)
self.im_SmallSkill=e:Find("imgIconBG/tweener/im_SmallSkill")
LuaUtils.SetActive(self.im_SmallSkill,false)
self.txtBeControl=e:Find("txtBeControl"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetActive(self.txtBeControl.transform,false)
self.UIEffect_normalSkill=e:Find("imgIconBG/tweener/UIEffect_normalSkill")
LuaUtils.SetActive(self.UIEffect_normalSkill,false)
self.UIEffect_meili=e:Find("imgIconBG/tweener/UIEffect_meili")
LuaUtils.SetActive(self.UIEffect_meili,false)
self.ui_touxiangsg=e:Find("imgIconBG/tweener/ui_touxiangsg")
self.UIEffect_Fury_Container=e:Find("HeadBar/imgHPBG/UIEffect_Fury_Container")
LuaUtils.SetActive(self.UIEffect_Fury_Container,false)
self.UIEffect_Fury=e:Find("HeadBar/imgHPBG/UIEffect_Fury_Container/UIEffect_Fury")
if(self.UIEffect_Fury~=nil)then
LuaUtils.SetActive(self.UIEffect_Fury,false)
end
if(self.heroCtrl.HeroBattleInfo.CurrFury/self.heroCtrl.HeroBattleInfo.Fury>=1)then
if(self.UIEffect_Fury~=nil)then
LuaUtils.SetActive(self.UIEffect_Fury,false)
end
end
self.btnAttack=e:Find("btnAttack"):GetComponent(typeof(CS.YouYou.ClickBase))
local t="head_tran_"..t
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_NormalBattle,t,self.heroItemTrans)
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_NormalBattle,t.."_touch",e:Find("btnAttack"))
self.btnAttack.LongPress=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
if self.attackLimitType~=EBattleAttackLimitType.None and self.attackLimitType~=EBattleAttackLimitType.BigSkill then
return
end
self:LongPress()
end
self.btnAttack.Click=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
if self.attackLimitType~=EBattleAttackLimitType.None and self.attackLimitType~=EBattleAttackLimitType.NormalAttack then
return
end
self:Click()
end
self.btnAttack.MouseUpIn=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
if self.attackLimitType~=EBattleAttackLimitType.None then
return
end
self:MouseUpIn()
end
self.btnAttack.MouseUpOut=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
if self.attackLimitType~=EBattleAttackLimitType.None and self.attackLimitType~=EBattleAttackLimitType.BigSkill then
return
end
self:MouseUpOut()
end
self.btnAttack.MouseDown=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
self:MouseDown()
end
self.btnAttack.MouseUp=function()
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
return
end
self:MouseUp()
end
self:ShowHeroInfo()
self:HideBeControlText()
self:HideAllEffectStatusAndShowMask()
end
)
end
function e:OnBeansStatFuryChange(e,t)
local e=e/t
self.im_power_beans.fillAmount=e
LuaUtils.SetActive(self.im_pow.transform,e>=1)
end
function e:OnShowBeans(e)
LuaUtils.SetActive(self.im_power_beans_bg.transform,e)
LuaUtils.SetActive(self.im_pow.transform,false)
end
function e:OnFuryChange()
local e=self.heroCtrl.HeroBattleInfo.CurrFury/self.heroCtrl.HeroBattleInfo.Fury
if(not IsNil(self.imgFury))then
self.imgFury.fillAmount=e
end
if(e>=1)then
if(not IsNil(self.UIEffect_Fury))then
self.UIEffect_Fury.gameObject:YouYouSetActive(true)
end
else
if(not IsNil(self.UIEffect_Fury))then
self.UIEffect_Fury.gameObject:YouYouSetActive(false)
end
end
if(not self.IsDisEnable)then
if(e==1)then
self.heroCtrl:CheckBattleRoundBigAndSmallSkillStatus()
end
end
end
function e:LoadAllSkillNewEffect()
if(not self.heroCtrl or not self.heroCtrl.DTmodelRow)then
return
end
if self.heroCtrl.DTmodelRow.bigSkillEffectAll==0 then
return
end
GameEntry.Pool:GameObjectSpawn(
self.heroCtrl.DTmodelRow.bigSkillEffectAll,
nil,
function(e,t,t)
self.UIEffect_AllSkillNewTrans=e
LuaUtils.SetParentAtZero(e,self.UIEffect_AllSkillNew)
end)
end
function e:LoadBigSkillEffect()
if(not self.heroCtrl or not self.heroCtrl.DTmodelRow)then
return
end
if self.heroCtrl.DTmodelRow.bigSkillEffect==0 then
return
end
GameEntry.Pool:GameObjectSpawn(
self.heroCtrl.DTmodelRow.bigSkillEffect,
nil,
function(e,t,t)
self.UIEffect_BigSkillTrans=e
LuaUtils.SetParentAtZero(e,self.UIEffect_BigSkill)
end)
end
function e:OnOpen()
self.onSkill_BattleUI_Hide=function()
self:HideAllEffectStatus()
end
self.onSkill_BattleUI_Show=function()
self:ShowAllEffectStatus()
end
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Hide,self.onSkill_BattleUI_Hide)
EventSystem.AddListener(CommonEventId.Skill_BattleUI_Show,self.onSkill_BattleUI_Show)
end
function e:OnClose()
self:HideAllEffectStatusAndShowMask()
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Hide,self.onSkill_BattleUI_Hide)
EventSystem.RemoveListener(CommonEventId.Skill_BattleUI_Show,self.onSkill_BattleUI_Show)
end
function e:ShowBeControlText(e)
LuaUtils.SetTextMeshText(self.txtBeControl,GameTools.GetLocalize(e,LanguageCategory.LangBattle))
LuaUtils.SetActive(self.txtBeControl.transform,true)
end
function e:HideBeControlText()
LuaUtils.SetActive(self.txtBeControl.transform,false)
end
function e:ChangeHero(e)
self.heroCtrl=e
self.heroCtrl.OnFuryChange=function()
self:OnFuryChange()
end
self:ShowHeroInfo()
self.IsDisEnable=false
self:ToImage_Black(true)
self:HideBeControlText()
end
function e:UnLoadItemTrans()
if(self.heroItemTrans~=nil)then
GameEntry.Pool:GameObjectDespawn(self.heroItemTrans)
self.heroItemTrans=nil
end
end
function e:ShowOrHideBattleBeginEffect(e)
if self.ui_touxiangsg then
LuaUtils.SetActive(self.ui_touxiangsg,e)
end
end
function e:ShowHeroInfo()
self.imgHeadIcon:LoadSprite("UIHeroHead/"..self.heroCtrl.DTmodelRow.head,false)
if self.heroCtrl:IsMonsterRole()then
self.im_quality:LoadSprite(string.format("UICommonOther/%s",CardQuailtyFont[self.heroCtrl.DTMonsterRow.star]),true)
UIUtil.HandlerHeroQualityImgEff(self.im_quality,self.heroCtrl.DTMonsterRow.star,false)
else
self.im_quality:LoadSprite(string.format("UICommonOther/%s",CardQuailtyFont[self.heroCtrl.DTHeroRow.star]),true)
UIUtil.HandlerHeroQualityImgEff(self.im_quality,self.heroCtrl.DTHeroRow.star,false)
end
local e=BreakCardQuailtyBgs[self.heroCtrl.lockLevel]
if e==nil then
e=BreakCardQuailtyBgs[1]
end
self.im_frame:LoadSprite(string.format("UICommonOther/%s",e),false)
self.im_zhiye:LoadSprite(string.format("UICommonOther/%s",ProfessionIcons[self.heroCtrl.profession]),false)
self.imgFury.fillAmount=self.heroCtrl.HeroBattleInfo.CurrFury/self.heroCtrl.HeroBattleInfo.Fury
local t=self.heroCtrl.rankLevel
local e=#self.starts
for e=1,e do
if e<=t then
LuaUtils.SetActive(self.starts[e],true)
else
LuaUtils.SetActive(self.starts[e],false)
end
end
self:ToImage_Black(true)
self:ShowOrHideBattleBeginEffect(false)
end
function e:Dispose()
if(not IsNil(self.UIEffect_AllSkillNewTrans))then
GameEntry.Pool:GameObjectDespawn(self.UIEffect_AllSkillNewTrans)
self.UIEffect_AllSkillNewTrans=nil
end
if(not IsNil(self.UIEffect_BigSkillTrans))then
GameEntry.Pool:GameObjectDespawn(self.UIEffect_BigSkillTrans)
self.UIEffect_BigSkillTrans=nil
end
self:UnLoadItemTrans()
end
function e:ShowHeadMask(e)
if(e)then
self.IsDisEnable=true
self:ToImage_Black(true)
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:ResetIconBGTweener()
LuaUtils.SetActive(self.im_BigSkill,false)
LuaUtils.SetActive(self.UIEffect_SmallSkill,false)
LuaUtils.SetActive(self.im_SmallSkill,false)
LuaUtils.SetActive(self.UIEffect_normalSkill,false)
LuaUtils.SetActive(self.UIEffect_meili,false)
self:SetHeadIconTipScale(false)
ModulesInit.ProcedureNormalBattle:SetGuideScaleView(false)
else
self:HideBigSkillStatus()
end
end
function e:ShowExplosiveEffect()
LuaUtils.SetActive(self.UIEffect_meili,true)
end
function e:ResetIconBGTweener()
if(not IsNil(self.tweenAnimationIconBG))then
self.tweenAnimationIconBG:DOPause()
LuaUtils.SetLocalScale(self.tweenAnimationIconBG.transform,1,1,1)
end
end
function e:HideHeadMask()
if(self.IsDisEnable and not ModulesInit.ProcedureNormalBattle.FightPlayData and ModulesInit.ProcedureNormalBattle.IsOpenShowHeadContainer)then
GameEntry.Effect:ShowUIEffect(
SysEffectId.UI_AvatarScan,
self.ownerUIForm.Depth+30,
EffectKeepType.AutoRelease,
self.imgHeadIcon.transform.position.x,
self.imgHeadIcon.transform.position.y,
self.imgHeadIcon.transform.position.z
)
end
self.IsDisEnable=false
self:ToImage_Black(false)
end
function e:HideBigSkillStatus()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:ResetIconBGTweener()
LuaUtils.SetActive(self.im_BigSkill,false)
LuaUtils.SetActive(self.im_SmallSkill,false)
local e=self.heroCtrl:GetCanNormalAttack(true)
if(e and self.heroCtrl.CurrRoundCanTriggerSmallSkill)then
LuaUtils.SetActive(self.UIEffect_SmallSkill,true)
LuaUtils.SetActive(self.im_SmallSkill,true)
elseif(e)then
LuaUtils.SetActive(self.UIEffect_normalSkill,true)
end
end
function e:ToGray(e)
if(e)then
self.imgIconBG.material=GameInit.Gray
self.imgHeadIcon.material=GameInit.Gray
self.im_frame.material=GameInit.Gray
self.im_quality.material=GameInit.Gray
self.im_zhiye.material=GameInit.Gray
self.imgHPBG.material=GameInit.Gray
self.imgFury.material=GameInit.Gray
else
self:ToColorBack()
end
end
function e:ToImage_Black(e)
if(IsNil(self.imgMask))then
return
end
if(e)then
LuaUtils.SetActive(self.imgMask.transform,true)
else
LuaUtils.SetActive(self.imgMask.transform,false)
self:ToColorBack()
end
end
function e:ToColorBack()
self.IsDisEnable=false
self.imgIconBG.material=nil
self.imgHeadIcon.material=nil
self.im_frame.material=nil
self.im_quality.material=nil
self.im_zhiye.material=nil
self.imgHPBG.material=nil
self.imgFury.material=nil
end
function e:HideAllEffectStatusAndShowMask()
if(not IsNil(self.UIEffect_AllSkillNew))then
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
end
if(not IsNil(self.UIEffect_BigSkill))then
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:ResetIconBGTweener()
if(not IsNil(self.im_BigSkill))then
LuaUtils.SetActive(self.im_BigSkill,false)
end
if(not IsNil(self.UIEffect_SmallSkill))then
LuaUtils.SetActive(self.UIEffect_SmallSkill,false)
end
if(not IsNil(self.im_SmallSkill))then
LuaUtils.SetActive(self.im_SmallSkill,false)
end
if(not IsNil(self.UIEffect_normalSkill))then
LuaUtils.SetActive(self.UIEffect_normalSkill,false)
end
if(not IsNil(self.UIEffect_meili))then
LuaUtils.SetActive(self.UIEffect_meili,false)
end
self.IsDisEnable=true
self:ToImage_Black(true)
self:SetHeadIconTipScale(false)
end
function e:SetEffectStatus(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if self.heroItemTrans==nil then
return
end
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
self:ResetIconBGTweener()
LuaUtils.SetActive(self.im_BigSkill,false)
LuaUtils.SetActive(self.UIEffect_SmallSkill,false)
LuaUtils.SetActive(self.im_SmallSkill,false)
LuaUtils.SetActive(self.UIEffect_normalSkill,false)
LuaUtils.SetActive(self.UIEffect_meili,false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e==HeroHeadItemTriggerEffectType.All)then
LuaUtils.SetActive(self.UIEffect_AllSkillNew,true)
LuaUtils.SetActive(self.im_BigSkill,true)
LuaUtils.SetActive(self.im_SmallSkill,true)
self.tweenAnimationIconBG:DORestart()
local e="BIG_SKILL_READYFINISH_"..self.heroCtrl.battleStationIndex
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event=e})
elseif(e==HeroHeadItemTriggerEffectType.BigSkill)then
LuaUtils.SetActive(self.UIEffect_BigSkill,true)
LuaUtils.SetActive(self.im_BigSkill,true)
self.tweenAnimationIconBG:DORestart()
local e="BIG_SKILL_READYFINISH_"..self.heroCtrl.battleStationIndex
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event=e})
elseif(e==HeroHeadItemTriggerEffectType.SmallSkill)then
LuaUtils.SetActive(self.UIEffect_SmallSkill,true)
LuaUtils.SetActive(self.im_SmallSkill,true)
local e="NORMAL_SKILL_ACK_"..self.heroCtrl.battleStationIndex
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event=e})
elseif(e==HeroHeadItemTriggerEffectType.NormalSkill)then
LuaUtils.SetActive(self.UIEffect_normalSkill,true)
local e="NORMAL_SKILL_ACK_"..self.heroCtrl.battleStationIndex
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event=e})
end
if e==HeroHeadItemTriggerEffectType.None then
else
self:HideHeadMask()
end
end
function e:SetHeadIconTipScale(e)
LuaUtils.SetLocalScale(self.imgIconBGAnim.transform,0.6,0.6,0.6)
self.imgIconBGAnim.enabled=e
LuaUtils.AnimtorPlay(self.imgIconBGAnim,"ani_head",0,0)
end
function e:HideAllEffectStatus()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(not IsNil(self.UIEffect_AllSkillNew)and self.UIEffect_AllSkillNew.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_AllSkillNew,false)
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_AllSkillNew
end
if(not IsNil(self.UIEffect_BigSkill)and self.UIEffect_BigSkill.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_BigSkill,false)
self:ResetIconBGTweener()
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_BigSkill
end
if(not IsNil(self.UIEffect_SmallSkill)and self.UIEffect_SmallSkill.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_SmallSkill,false)
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_SmallSkill
end
if(not IsNil(self.UIEffect_normalSkill)and self.UIEffect_normalSkill.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_normalSkill,false)
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_normalSkill
end
if(not IsNil(self.UIEffect_meili)and self.UIEffect_meili.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_meili,false)
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_meili
end
if(not IsNil(self.UIEffect_Fury_Container)and self.UIEffect_Fury_Container.gameObject.activeSelf)then
LuaUtils.SetActive(self.UIEffect_Fury_Container,false)
self.needHideEffect[#self.needHideEffect+1]=self.UIEffect_Fury_Container
end
end
function e:ShowAllEffectStatus()
for e=#self.needHideEffect,1,-1 do
local t=self.needHideEffect[e]
if not IsNil(t)then
LuaUtils.SetActive(t,true)
table.remove(self.needHideEffect,e)
end
end
end
function e:LongPress()
if(not ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking))then
return
end
self.IsLongPress=true
if((self.UIEffect_AllSkillNew.gameObject.activeSelf or self.UIEffect_BigSkill.gameObject.activeSelf)and self.OnPressDown)then
self.OnPressDown()
end
end
function e:Click()
if(self.IsDisEnable)then
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)and ModulesInit.ProcedureNormalBattle.CurrIsAttacking)then
return
end
if(self.btnAttack.IsOutAfterClick==true)then
return
end
if(not self.IsDisEnable and self.heroCtrl:GetCanNormalAttackManual())then
self.IsDisEnable=true
if(self.OnShowClickEffect)then
self.OnShowClickEffect(self.heroItemTrans)
end
end
self.heroCtrl:NormalAttackManual()
ModulesInit.ProcedureNormalBattle:SetHeadIconTipScale(false)
ModulesInit.ProcedureNormalBattle:SetGuideScaleView(false)
end
function e:MouseUpIn()
self.IsLongPress=false
if(self.OnPressUp)then
self.OnPressUp()
end
end
function e:MouseUpOut()
if(self.IsLongPress)then
self.heroCtrl:BigAttackManual()
ModulesInit.ProcedureNormalBattle:SetGuideScaleView(false)
if ModulesInit.GuideMgr.isGuide then
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="OUR_BIG_SKILL_PULL"})
self:SetHeroPlayAttackLimit(EBattleAttackLimitType.None)
end
end
self.IsLongPress=false
if(self.OnPressUp)then
self.OnPressUp()
end
end
function e:MouseDown()
if(self.IsDisEnable)then
return
end
self.tweenAnimation:DOPlayForward()
end
function e:MouseUp()
self.tweenAnimation:DOPlayBackwards()
end
function e:SetHeroPlayAttackLimit(e)
self.attackLimitType=e
end
return e

