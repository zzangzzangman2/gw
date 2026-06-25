local ce=require("DataNode/DataTable/Create/player/DTLevelUpDBModel")
local ge=require("DataNode/DataTable/Create/harem/DTLoverVoiceDBModel")
local e=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local N=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local ne=require("DataNode/DataTable/Create/harem/DTLoverItemDBModel")
local be=require("Modules/MainInterface/UI_MainPageActItem")
local ve=require("Modules/MainInterface/UI_MainPageFaceActItem")
local qe=require('DataNode/DataTable/Create/player/DTDogEmojiDBModel')
local xe=require('DataNode/DataTable/Create/player/DTEventEmojiDBModel')
local je=require('DataNode/DataTable/Create/hero/DTHeroVoiceDBModel')
local e=require('DataNode/DataTable/Create/maps/DTMapsDBModel')
local e=require("DataNode/DataManager/DataMgr/DataUtil")
local ie=require('DataNode/DataTable/Create/harem/DTLoverUnlockDBModel')
local ze=require('DataNode/DataTable/Create/activity/DTMarryGachaDBModel')
local pe=require("DataNode/DataTable/Create/activity/DTSelfMarryCfgDBModel")
local ke=require('DataNode/DataTable/Create/item/DTItemDBModel')
local ye=require("DataNode/DataTable/Create/worldMap/DTMainInletDBModel")
local we=require('DataNode/DataTable/Create/function/DTFunctionDBModel')
local e=require('Common/cs_coroutine')
local fe=require("DataNode/DataTable/Create/shouhu/DTMainQuestDBModel")
local D=require("Common/UWAGPMMgr")
local me=require("DataNode/DataTable/Create/activity/DTTemporaryBuffDBModel")
local e
local e
local e
local a
local r
local H
local e=nil
local Z=nil
local h=nil
local m=nil
local X=false
local R=nil
local E=true
local t
local ee
local se=false
local u={
IDLE=1,
SPECIAL=2,
INTERACTION=3,
FAVORABILITY=4,
WATCH=5
}
local c
local o
local te
local e={}
local s=1
local i={}
local n
local n
local I={}
local b
local V
local W
local n=false
local J
local F=false
local v=nil
local U=nil
local w=nil
local l=nil
local M=false
local g=false
local S=nil
local le={
btn_act_1,btn_act_2,btn_act_3,btn_act_4,btn_act_5,btn_act_6,btn_act_7,btn_act_8
}
local ue={
btn_face_item_1,btn_face_item_2,btn_face_item_3,btn_face_item_4,btn_face_item_5,btn_face_item_6,btn_face_item_7
}
local Y={
{text="ui_new_main_tips1",bgImg="UIMainInterface2/zhuye_maoxian"},
{text="ui_new_main_tips2",bgImg="UIMainInterface2/zhuye_pvp"},
{text="ui_new_main_tips3",bgImg="UIMainInterface2/zhuye_xinshou"},
}
local d={
}
local p={}
local y={}
local z={}
local he
local re=-1
local de=-1
local q=0
local j=0
local ae,O=0
local oe,A=0
local K,T=0
local d=nil
local Q=150
local B=false
local L=nil
local _={}
local x=false
local G=0
local f=true
local k
local C=false
local P=false
function OnInit(e,t)
ModulesInit.UIPosMgr:setWorldPos(ModulesInit.UIPosMgr.EPosType.Bag,btnToggle2.transform.position)
InitLeftNode()
InitRightNode()
btn_left.onClick:AddListener(onBtnLeft)
btn_right.onClick:AddListener(onBtnRight)
local t=UI_touchSpine:GetComponent(typeof(CS.YouYou.UIDragEvent))
t.onClick=onBtnSpine
ee=UI_heroSpine.transform.position
InitActBtn()
InitFaceActBtn()
GameFunction:GetFunctionOpenLists()
if GameTools:IsReview()then
LuaUtils.SetActive(btn_qinmi.transform,false)
LuaUtils.SetActive(node_renwu.transform,false)
LuaUtils.SetActive(btn_twitter.transform,false)
LuaUtils.SetActive(btn_discord.transform,false)
LuaUtils.SetActive(btn_beijing.transform,false)
LuaUtils.SetActive(btn_naver.transform,false)
local e=e:Find("right/node_bottom/toogles/toggle3")
LuaUtils.SetActive(e,false)
LuaUtils.SetActive(mian_wanfa_item_3.transform,false)
LuaUtils.SetActive(mian_wanfa_item_4.transform,false)
else
end
local e=e:GetComponent(typeof(CS.UnityEngine.Animator))
e.keepAnimatorControllerStateOnDisable=true
UIUtil.AddTouchEventMulti(autoHelper_Root.transform,onClickDownAutoHelper,onClickUpAutoHelper,OnBeginDragAutoHelper,onDragingAutoHelper,OnEndDragAutoHelper)
end
function InitLeftNode()
btn_yincang.onClick:AddListener(onBtnHideUI)
btn_beijing.onClick:AddListener(onBtnBgSet)
btn_marry.onClick:AddListener(onBtnMarry)
btn_qinmi.onClick:AddListener(onBtnFavorability)
btn_watch.onClick:AddListener(onBtnWatch)
vip_Btn.onClick:AddListener(onBtnVip)
youjian_Btn.onClick:AddListener(onBtnMail)
haoyou_Btn.onClick:AddListener(onBtnFriend)
paihangbang_Btn.onClick:AddListener(onBtnRank)
funhandbook_Btn.onClick:AddListener(onBtnFunHandBook)
btn_head.onClick:AddListener(onBtnHead)
bg_juese.onClick:AddListener(onBtnHead)
btn_download.onClick:AddListener(OnShowBgDownload)
btn_baiqipao.onClick:AddListener(onChat)
btn_naver.onClick:AddListener(function()
LuaUtils.OpenUrl(Constant.naver_url)
end)
btn_twitter.onClick:AddListener(function()
LuaUtils.OpenUrl(Constant.twitter_url)
end)
btn_discord.onClick:AddListener(function()
LuaUtils.OpenUrl(Constant.discord_url)
end)
btn_taskNotice.onClick:AddListener(OnClickTaskNoticeBtn)
faceGiftNode.onClick:AddListener(function()
ActMgr:CheckJumpViewById(ModulesInit.FaceGiftManager.ACT_ID,{isOpenFrame=true})
end)
btn_qinmi2.onClick:AddListener(onBtnFavorability)
btn_watch2.onClick:AddListener(onBtnWatch)
btn_show_fanhui.onClick:AddListener(onBtnShow)
llvChat:InitListView(0,onChatList)
btn_temporary_buff.onClick:AddListener(OnBtnOpenTemporaryBuffView)
llv_activity_pageview:InitListView(0,OnGetItemByIndex)
llv_activity_pageview.mOnBeginDragAction=OnActivityBeginDrag
llv_activity_pageview.mOnDragingAction=OnActivityDrag
llv_activity_pageview.mOnEndDragAction=OnActivityEndDrag
bannerBgBtn.onClick:AddListener(function()
n=false
LuaUtils.SetActive(showBannerDescNode.transform,n)
LuaUtils.SetActive(bg_dibu.transform,n)
CheckOnOpenBannerHideAutoHelper()
end)
ScrollViewActBanner:InitListView(0,OnGetBannerItemByIndex)
ScrollViewActBanner.mOnEndDragAction=OnActBannerScrollEnd
ae,oe,K=LuaUtils.GetLocalPos(root_taskNotice.transform)
O,A,T=LuaUtils.GetLocalPos(root_noticeTween.transform)
end
function InitRightNode()
btn_renwu.onClick:AddListener(OnQuestBtnClick)
btn_jia_gold.onClick:AddListener(onBtnAddGold)
btn_jia_holy.onClick:AddListener(onBtnAddHoly)
btn_shangdian.onClick:AddListener(onBtnShop)
worldwanfaBtn.onClick:AddListener(onBtnWorld)
local e=mian_wanfa_item_1:GetComponents()
e["wanfaBtn"].onClick:AddListener(onBtnAdventure)
local e=mian_wanfa_item_2:GetComponents()
e["wanfaBtn"].onClick:AddListener(onBtnJinji)
local e=mian_wanfa_item_3:GetComponents()
e["wanfaBtn"].onClick:AddListener(onBtnLimit)
local e=mian_wanfa_item_4:GetComponents()
e["wanfaBtn"].onClick:AddListener(onBtnActJump)
btnToggle1.onClick:AddListener(onBtnCamp)
btnToggle2.onClick:AddListener(onBtnBag)
btnToggle3.onClick:AddListener(onBtnShouhu)
btnToggle4.onClick:AddListener(onBtnHufu)
btnToggle5.onClick:AddListener(onBtnGuild)
btnToggle6.onClick:AddListener(onBtnCity)
btnToggle7.onClick:AddListener(onBtnSummonPet)
LuaUtils.SetTextMeshText(lab_renwu_text,GameTools.GetLocalize("Funtionname_10025",LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(lab_shangdian_text,GameTools.GetLocalize("Funtionname_10056",LanguageCategory.LangCommon))
end
function OnFormBack(e)
x=true
onNewShowChange()
OnNewHeroAtlas()
onMailAnimationCheck()
refreshLeftActView()
LuaUtils.SetActive(guide_mask.transform,false)
GameTools:PlayMainBGM()
end
function OnEnable(e)
if e then
refreshChat()
else
LuaUtils.SetActive(p_changeBgHero,false)
end
end
function StopLoopImageHandler(e)
se=e
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.AddListener(CommonEventId.OnPlayerChangeName,refreshLeft)
EventSystem.AddListener(CommonEventId.OnMainBgChange,onMainBgChange)
EventSystem.AddListener(CommonEventId.OnNewChatMsg,receiveNewMsg)
EventSystem.AddListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.AddListener(CommonEventId.FormationSyncChange,refreshPlayerHeadView)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,onRedPointChange)
EventSystem.AddListener(CommonEventId.QuestDataChange,OnQuestDataChange)
EventSystem.AddListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
EventSystem.AddListener(CommonEventId.PlayerLevelUp,PlayerLevelUp)
EventSystem.AddListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnEnterForeground,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.OnAtlasAndExhibitionRefresh,OnNewHeroAtlas)
EventSystem.AddListener(CommonEventId.OnRefreshBgDownload,OnRefreshBgDownload)
EventSystem.AddListener(CommonEventId.OnFavorabilityRefresh,onMainBgChange)
EventSystem.AddListener(CommonEventId.OnCloseChat,OnCloseChatView)
EventSystem.AddListener(CommonEventId.NaverStageSync,OnNaverStageSync)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.OnActFirstDayRewardStatus,OnActFirstDayRewardStatus)
EventSystem.AddListener(CommonEventId.OnEquipCountChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.BagSizeChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.OnItemInfoChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.OnCloseDockAndCurrUI,onCloseDockAndCurrUI)
EventSystem.AddListener(CommonEventId.OnHideDockAndCurrUI,onHideDockAndCurrUI)
EventSystem.AddListener(SysEventId.OnLoadingClosed,OnLoadingClosed)
EventSystem.AddListener(CommonEventId.OnGuideFinishRefreshDock,OnGuideFinishRefreshDock)
EventSystem.AddListener(CommonEventId.OnRespHeroCompose,OnRespHeroCompose)
EventSystem.AddListener(CommonEventId.NewDay,OnNewDay)
EventSystem.AddListener(CommonEventId.OnStartGuide,OnStartGuide)
EventSystem.AddListener(CommonEventId.OnClickNewMarketNotice,OnClickNewMarketNotice)
EventSystem.AddListener(CommonEventId.OnMainBannerStatusRefresh,StopLoopImageHandler)
EventSystem.AddListener(CommonEventId.OnCloseLuaView,onCloseLuaView)
EventSystem.AddListener(CommonEventId.EVENT_FSB_MAP_CAN_REQ_SERVER,RefrshFSBStatus)
EventSystem.AddListener(CommonEventId.OnHideMainPageHero,OnHideMainPageHero)
EventSystem.AddListener(CommonEventId.OnRefreshTaskNoticeData,refreshTaskNoticeView)
EventSystem.AddListener(CommonEventId.OnGetTaskNoticeRewardSuccessful,OnTaskNoticeGetReward)
EventSystem.AddListener(CommonEventId.OnAutoHelperRedRefresh,RefereshAutoHelperView)
EventSystem.AddListener(CommonEventId.OnActFoolsDollRefreshInfo,OnActFoolsDollRefreshInfo)
EventSystem.AddListener(CommonEventId.OnSynPlayerLimitBuffList,OnSynPlayerLimitBuffList)
EventSystem.AddListener(CommonEventId.OnTestLive2dById,OnTestLive2dById)
GameTools.isWillCloseMainPage=false
f=true
C=false
P=false
if e and e.forbidViewList then
ViewMgr:clostEnableLayerView(e.forbidViewList)
else
ViewMgr:clostEnableLayerView()
end
ModulesInit.MainPageLimitMgr:InitData()
HeroMgr:RefreshCanComposeHeroDic()
ActMgr:checkInitLocalSaveData()
t=PlayerMgr.PlayerInfo.showHeroIndex
s=1
b=0
V=false
W=false
j=5
x=false
G=0
refresh()
LuaUtils.SetActive(guide_mask.transform,false)
if ModulesInit.StoryManager.isStoryCreateName then
ModulesInit.StoryManager.isStoryCreateName=false
if ModulesInit.GuideMgr.isOpenGuide then
if GameFunction:CheckNewGuideByFunc231217()then
LuaUtils.SetActive(guide_mask.transform,true)
ModulesInit.GuideMgr.createNameStatus=true
ModulesInit.GuideMgr:CheckMainGuide(true)
end
end
end
CheckShowLoginView()
LuaUtils.SetActive(llvChat.transform,GameFunction.IsFunctionUnLock(GameFunctionType.Chat))
OnNewHeroAtlas()
UpdateForumBtnStage()
if GameFunction.IsFunctionUnLock(GameFunctionType.Marry)then
ModulesInit.MarryManager:SendQueryMarryVoiceListRequest()
end
OpenMainEnterView()
if e and e.stopPlayEnterAnim then
LuaUtils.AnimtorPlay(UI_MainInterface,"UI_MainInterface_idle",0,0)
else
LuaUtils.AnimtorPlay(UI_MainInterface,"UI_MainInterface_in",0,0)
end
RefereshAutoHelperView()
InitFoolsDollSpineBtnShow()
SetFestival()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.RemoveListener(CommonEventId.OnPlayerChangeName,refreshLeft)
EventSystem.RemoveListener(CommonEventId.OnMainBgChange,onMainBgChange)
EventSystem.RemoveListener(CommonEventId.OnNewChatMsg,receiveNewMsg)
EventSystem.RemoveListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.RemoveListener(CommonEventId.FormationSyncChange,refreshPlayerHeadView)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,onRedPointChange)
EventSystem.RemoveListener(CommonEventId.QuestDataChange,OnQuestDataChange)
EventSystem.RemoveListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
EventSystem.RemoveListener(CommonEventId.PlayerLevelUp,PlayerLevelUp)
EventSystem.RemoveListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnEnterForeground,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.OnAtlasAndExhibitionRefresh,OnNewHeroAtlas)
EventSystem.RemoveListener(CommonEventId.OnRefreshBgDownload,OnRefreshBgDownload)
EventSystem.RemoveListener(CommonEventId.OnFavorabilityRefresh,onMainBgChange)
EventSystem.RemoveListener(CommonEventId.OnCloseChat,OnCloseChatView)
EventSystem.RemoveListener(CommonEventId.NaverStageSync,OnNaverStageSync)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.OnActFirstDayRewardStatus,OnActFirstDayRewardStatus)
EventSystem.RemoveListener(CommonEventId.OnEquipCountChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.BagSizeChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.OnItemInfoChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.OnStartGuide,OnStartGuide)
EventSystem.RemoveListener(CommonEventId.OnClickNewMarketNotice,OnClickNewMarketNotice)
EventSystem.RemoveListener(CommonEventId.OnCloseDockAndCurrUI,onCloseDockAndCurrUI)
EventSystem.RemoveListener(CommonEventId.OnHideDockAndCurrUI,onHideDockAndCurrUI)
EventSystem.RemoveListener(SysEventId.OnLoadingClosed,OnLoadingClosed)
EventSystem.RemoveListener(CommonEventId.OnGuideFinishRefreshDock,OnGuideFinishRefreshDock)
EventSystem.RemoveListener(CommonEventId.OnRespHeroCompose,OnRespHeroCompose)
EventSystem.RemoveListener(CommonEventId.NewDay,OnNewDay)
EventSystem.RemoveListener(CommonEventId.OnMainBannerStatusRefresh,StopLoopImageHandler)
EventSystem.RemoveListener(CommonEventId.OnCloseLuaView,onCloseLuaView)
EventSystem.RemoveListener(CommonEventId.EVENT_FSB_MAP_CAN_REQ_SERVER,RefrshFSBStatus)
EventSystem.RemoveListener(CommonEventId.OnHideMainPageHero,OnHideMainPageHero)
EventSystem.RemoveListener(CommonEventId.OnRefreshTaskNoticeData,refreshTaskNoticeView)
EventSystem.RemoveListener(CommonEventId.OnGetTaskNoticeRewardSuccessful,OnTaskNoticeGetReward)
EventSystem.RemoveListener(CommonEventId.OnAutoHelperRedRefresh,RefereshAutoHelperView)
EventSystem.RemoveListener(CommonEventId.OnActFoolsDollRefreshInfo,OnActFoolsDollRefreshInfo)
EventSystem.RemoveListener(CommonEventId.OnSynPlayerLimitBuffList,OnSynPlayerLimitBuffList)
EventSystem.RemoveListener(CommonEventId.OnTestLive2dById,OnTestLive2dById)
g=false
CloseGuideShou()
if a or r then
UIUtil.SpinePoolDespawnAll(a,r)
end
GameEntry.Audio:StopAllAudio()
if te then
GameEntry.Audio:RemoveCallBack(te)
te=nil
end
a=nil
r=nil
DisposeMarryHeroModel()
CloseActBtn()
CloseFaceActBtn()
llv_activity_pageview.ContainerTrans.transform:DOKill()
if R then
R:Kill()
R=nil
end
E=true
n=false
if J then
J:Stop()
J=nil
end
StopToggleSequence()
CloseTaskNoticeSeq()
StopSequence()
RemoveFoolsDollSpineBtn()
end
function OpenMainEnterView()
if ModulesInit.MainPageMgr.isFormEarthRoot then
local e=ModulesInit.EarthMgr:GetCurRunningMapId()
if e==ModulesInit.MainPageMgr.playMainMapId then
if not ModulesInit.PhotoArtistMgr:getDataById(ModulesInit.MainPageMgr.playMainSaveId)then
UIUtil.forceShowUI(UIFormId.UI_ChapterCityShow)
end
end
end
end
function onCloseDockAndCurrUI(e)
local e=e and e.forbidViewList or{}
local function o(a)
for t=1,#e do
if e[t]==a then
return true
end
end
return false
end
if o(UIFormId.UI_MainPage)==false then
GameTools.CloseUIForm(UIFormId.UI_MainPage)
end
ViewMgr:clostEnableLayerView(e)
end
function OnStartGuide()
if ModulesInit.GuideMgr.isGuide and ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.EarthChapter_1_3_Draw then
EventSystem.SendEvent(CommonEventId.OnEventActInfoChange)
end
if ModulesInit.GuideMgr.isGuide then
local e=ModulesInit.GuideMgr:CurrGuidEnterActId()
if e then
EventSystem.SendEvent(CommonEventId.OnEventActInfoChange)
end
end
end
function onHideDockAndCurrUI(e)
if e then
GameEntry.UI:HideUIForm(UIFormId.UI_MainPage)
else
GameEntry.UI:ShowUIForm(UIFormId.UI_MainPage)
end
end
function OnLoadingClosed()
PlayerMgr.loginLoadComplete=true

CheckShowLoginView(true)
end
function CheckShowLoginView(e)

if PlayerMgr.loginComplete==false then
return
end
CS.YouYou.PayManager.RemoveOldTrans()

if PlayerMgr.loginLoadComplete then
local e=ModulesInit.GuideMgr:CheckMainGuide(e)
if e then
local e=ModulesInit.GuideMgr:CheckIsJumBattleUnit()

LuaUtils.SetActive(guide_mask.transform,e)
if e==false then
GameTools:PlayMainBGM()
end
else

LuaUtils.SetActive(guide_mask.transform,false)
GameTools:PlayMainBGM()
end
ModulesInit.MainPageLimitMgr.enGameMainOnGuide=true
SetToggleLayoutGroupView2()
StopToggleSequence()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.8)
e:AppendCallback(
function()
SetToggleLayoutGroupView()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_MAINPAGE_SUC"})
S=nil
end
)
S=e
CheckGuideHandShow()
CheckAutoPop()
end
end
function OnGuideFinishRefreshDock()
CheckGuideHandShow()
SetToggleLayoutGroupView()
end
function SetToggleLayoutGroupView2()
local t=toogles.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local a=toogles.transform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
local e=node_act_btn.transform:GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
e.enabled=true
a.enabled=true
t.enabled=true
end
function SetToggleLayoutGroupView()
end
function CloseGuideShou()
M=false
LuaUtils.SetActive(fanhui_guide_shou.transform,false)
if w then
w:Stop()
w=nil
end
if l then
l:Kill()
l=nil
end
end
function CheckGuideHandShow()
if not PlayerMgr.loginLoadComplete then
return
end
CloseGuideShou()
if(not ModulesInit.GuideMgr.isGuide)and ModulesInit.ExpeditionManager:MapIsThrough(ModulesInit.GuideMgr.firstGuideTipsMapId)==false then
GuideTimerAction()
end
end
function OnRespHeroCompose()
RefreshBomRedPoint()
end
function OnNewDay()
ModulesInit.ActNewMarketNoticeMgr:OnNewDay()
SetLimitPageView()
NewDayReqDollMsg()
end
function GuideTimerAction()
LuaUtils.SetActive(fanhui_guide_shou.transform,false)
if(not ModulesInit.GuideMgr.isGuide)and ModulesInit.ExpeditionManager:MapIsThrough(ModulesInit.GuideMgr.firstGuideTipsMapId)==false then
if w then
w:Stop()
w=nil
end
w=ModulesInit.TimeActionMgr:CreateTimeAction()
w:Init(6,2,1,nil,function()
M=true
LuaUtils.SetActive(fanhui_guide_shou.transform,true)
if l then
l:Kill()
l=nil
end
l=CS.DG.Tweening.DOTween.Sequence()
l:AppendInterval(3)
l:AppendCallback(function()
M=false
LuaUtils.SetActive(fanhui_guide_shou.transform,false)
GuideTimerAction()
end)
end,nil):Run()
end
end
function cleanFaceTime()
if Z then
Z:Stop()
Z=nil
end
end
function UpdateForumBtnStage()
if LuaUtils.GetActive(btn_naver.transform)then
local e=btn_naver.transform:GetComponent(typeof(CS.YouYou.UISpineCtr))
if PlayerMgr:ForumIsOpen(Forum.Naver)then
e:PlayAnimation(0,'A',true)
else
e:PlayAnimation(0,'B',true)
end
end
if LuaUtils.GetActive(btn_discord.transform)then
local e=btn_discord.transform:GetComponent(typeof(CS.YouYou.UISpineCtr))
if PlayerMgr:ForumIsOpen(Forum.Naver)then
e:PlayAnimation(0,'A',true)
else
e:PlayAnimation(0,'B',true)
end
end
end
function OnNaverStageSync()
UpdateForumBtnStage()
end
function OnNewHeroAtlas()
LuaUtils.SetActive(im_beigingRed.transform,false)
local e=HeroMgr:GetActiviedShowHeroData()
if e and#e>0 then
for t,e in ipairs(e)do
if not ModulesInit.HeroShowMgr.GetPictureDisplayClick(e.heroDid,1)
or not ModulesInit.HeroShowMgr.GetPictureDisplayClick(e.heroDid,0)then
LuaUtils.SetActive(im_beigingRed.transform,true)
break
end
end
end
end
function OnEventNetReconnectSuccess()
refresh(nil,true)
ModulesInit.FullServerBattleMgr:ReconnectSuccess()
NewDayReqDollMsg()
end
function OnHideMainPageHero(e)
local e=e.isHide or false
SetHideHeroSp(e)
end
function SetHideHeroSp(e)
local e=not e
LuaUtils.SetActive(UI_heroSpine.transform,e)
end
function OnLuaViewChange(t)
local e=t and t.isViewOpen
local e=ViewMgr:checkIsTopShowView(UIFormId.UI_MainPage)
f=e
if h and m then
if h then
local a=h:GetComponent(typeof(CS.YouYou.LuaUnit))
local e=a.scriptEnv
if f then
if t and not t.isDisable then
if e.ContinuePlayLive2dAnimator then
e:ContinuePlayLive2dAnimator()
end
if e.AddCubismMaskController then
e:AddCubismMaskController()
end
end
if X then
local e=a.scriptEnv
e.SwitchExpression(MarryExpressionGroup.selfExpression,true)
end
else
if e.StopLive2dAnimator then
e:StopLive2dAnimator()
end
if e.RemoveCubismMaskController then
e:RemoveCubismMaskController()
end
end
end
end
if PlayerMgr.loginComplete==false then
return
end
if f then
if ModulesInit.MainPageLimitMgr.enGameMainOnGuide then
local e=ModulesInit.GuideMgr:CheckIsJumBattleUnit()
if e==false then
GameTools:PlayMainBGM()
LuaUtils.SetActive(guide_mask.transform,false)
end
end
if t.uIFormId~=UIFormId.UI_ActSeaFishingInvitation_View then
PlayerMgr:sendPlayerMainPage()
end
if C==true then
refreshLeft()
end
if P==true then
refreshRight()
end
end
end
function onCloseLuaView(e)
if PlayerMgr.loginComplete==false then
return
end
if e==ModulesInit.AutoPopViewMgr._lastUIFormId then
return
end
local a=ModulesInit.AutoPopViewMgr.ignoreCloseViewIdList[e]
local t=ViewMgr:checkIsTopShowView(UIFormId.UI_MainPage)
if not a and not GameEntry.UI:IsExists(ModulesInit.AutoPopViewMgr._lastUIFormId)and t then
g=false
end

end
function CheckAutoPop()
if not ModulesInit.MainPageMgr.isCheckPopView then return end
if not g then return end
if GameTools.isWillCloseMainPage then return end
if PlayerMgr.loginComplete and PlayerMgr.loginLoadComplete then
local e=ViewMgr:checkIsTopShowView(UIFormId.UI_MainPage)
if e then

ModulesInit.AutoPopViewMgr:start()
end
end
end
function OnUpdate()
if PlayerMgr.loginComplete==false then return end
if f==false then
return
end
if ModulesInit.ActSelfMarketMgr.startReqTime>0 then
local e=TimeUtil.GetServerTimeStamp()
if e-ModulesInit.ActSelfMarketMgr.startReqTime>=5 then
ModulesInit.ActSelfMarketMgr.startReqTime=0
if ModulesInit.ActSelfMarketMgr.isGameState~=5 and ModulesInit.ActSelfMarketMgr.isGameState~=6 then
GameInit.LogErrorAndUpdate("ActSelfMarketMgr isGameState = "..tostring(ModulesInit.ActSelfMarketMgr.isGameState))
end
end
end
if not se then
if W==false and#i>1 then
b=b+Time.deltaTime
if b>5 then
b=0
OnSnapNearestChanged(1)
end
end
if not g then
g=true
CheckAutoPop()
end
end
if M and ModulesInit.GuideMgr.isGuide then
CloseGuideShou()
end
if ModulesInit.ActFirstDayRewardMgr.GetRewardStatus()==ModulesInit.ActFirstDayRewardMgr.REWARD_STATUS.DISABLE and
ModulesInit.ActFirstDayRewardMgr:GetRewardTime()<TimeUtil.GetServerTimeStamp()then
ModulesInit.ActFirstDayRewardMgr:SetRewardStatus(ModulesInit.ActFirstDayRewardMgr.REWARD_STATUS.ABLE)
end
local e=false
if j~=nil then
j=j+Time.deltaTime
if j>5 then
j=0
local e=ViewMgr:checkIsTopShowView(self.UIFormId)
if e then
checkRefreshFaceActView()
SetActJumpPageView()
end
UpdateStateInfo()
end
end
local e=false
if q~=nil then
if q>1 then
q=q-1
e=true
end
q=q+Time.deltaTime
end
if e then
SetLimitPageView()
refreshFaceActTime()
end
UpdateRefreshRedPoint()
end
function OnBeforeDestroy()
end
function refresh(t,e)
refreshLeft(false)
refreshRight(false)
refreshDownLoadView()
refreshTaskNoticeView()
if not e then
refreshMiddle(t,false)
end
x=true
onNewShowChange(false)
onMailAnimationCheck(false)
end
function refreshDownLoadView()
local e=GameEntry.UI:IsExists(UIFormId.UI_PlayBgDownload)
local t=e
if e==false then
local a=CS.YouYou.PlayDownloadMgr:GetInstance():CheckAndStartDownload()
local t=LuaUtils.GetPlayerPrefsBool("CAN_HOT_UPDATE_AWARD",false)
e=a or(PlayerMgr.PlayerExtInfo.hotUpdateAward==false and t==true)
end
if GameTools:IsReview(true)then
LuaUtils.SetActive(btn_download.transform,e and GameTools:IsReview(true)==false)
else
LuaUtils.SetActive(btn_download.transform,e)
EventSystem.SendEvent(CommonEventId.OnUpdateBgDownload)
end
end
function OnRefreshBgDownload(e)
if e then
if e.isDownloadStop~=nil then
LuaUtils.SetActive(im_start.transform,e.isDownloadStop==false)
LuaUtils.SetActive(im_stop.transform,e.isDownloadStop)
LuaUtils.SetActive(p_download_redpoint.transform,e.isDownloadStop)
end
if e.downloadComplete~=nil then
LuaUtils.SetActive(p_download_redpoint.transform,e.downloadComplete)
LuaUtils.SetActive(im_start.transform,true)
LuaUtils.SetActive(im_stop.transform,false)
LuaUtils.SetTextMeshText(tmp_bubble_pro,"100%")
LuaUtils.SetActive(p_download_redpoint.transform,true)
end
if e.pro~=nil then
LuaUtils.SetTextMeshText(tmp_bubble_pro,math.floor(e.pro*100).."%")
if e.pro>=1 then
LuaUtils.SetActive(p_download_redpoint.transform,true)
LuaUtils.SetActive(im_start.transform,true)
LuaUtils.SetActive(im_stop.transform,false)
end
end
if e.HideBubble~=nil then
LuaUtils.SetActive(btn_download.transform,e.HideBubble==false and GameTools:IsReview(true)==false)
else
if GameTools:IsReview(true)then
LuaUtils.SetActive(btn_download.transform,false)
end
end
end
end
function CloseTaskNoticeSeq()
LuaUtils.SetActive(root_noticeTween.transform,false)
if d~=nil then
d:Kill()
d=nil
end
end
function refreshTaskNoticeView()
local e=ModulesInit.TaskNoticeMgr:IsFunctionOpen()
LuaUtils.SetActive(root_taskNotice.transform,e)
if e then
if llv_activity_pageview.gameObject.activeSelf then
LuaUtils.SetLocalPos(root_taskNotice.transform,ae,oe,K)
LuaUtils.SetLocalPos(root_noticeTween.transform,O,A,T)
else
LuaUtils.SetLocalPos(root_taskNotice.transform,ae,oe+Q,K)
LuaUtils.SetLocalPos(root_noticeTween.transform,O,A+Q,T)
end
local i=root_taskNotice:GetComponents()
local e=ModulesInit.TaskNoticeMgr:CurTaskProgressTxt()
local a=string.len(e)
local t=utf8.len(e)
local a=(a-t)/2
local t=t-a
local o=a/0.6+t*1+4
o=math.floor(o+0.5)
local t=ModulesInit.TaskNoticeMgr:IsCurTaskProgressSuccess()
if t then
e="<color=#00FF7B>（ "..e.." ）</color>"
else
e="<color=#FF4136>（ "..e.." ）</color>"
end
local t=ModulesInit.TaskNoticeMgr:CurTaskDesc()
local a=string.len(t)
local n=utf8.len(t)
local a=(a-n)/2
local n=n-a
local a=a/0.6+n*1
a=math.floor(a+0.5)
if a%21+o<=21 then
t=t..e
else
t=t.."\n"..e
end
LuaUtils.SetTextMeshText(i["txt_taskName"],t)
local e=i["spine_bg"]
local t=ModulesInit.TaskNoticeMgr.curTaskID_Status==ModulesInit.TaskNoticeMgr.TaskStatus.CanReward
if t then
e:PlayAnimation(0,'B',true)
else
e:PlayAnimation(0,'A',true)
end
end
end
function OnTaskNoticeGetReward(e)
GameTools:PlayAudioLua(729)
RefreshTaskNoticePropItemView(e.id)
PlayTaskNoticeRewardTween()
end
function RefreshTaskNoticePropItemView(e)
local t={}
local e=fe.GetEntity(e)
if e then
t=e.reward
end
local a=root_noticeTween:GetComponents()
for e=1,LuaUtils.GetChildrenCount(a["reward_group"])do
if t[e]then
local o=UIUtil.GetChild(a["reward_group"],e-1)
local a=LuaUtils.GetLuaComBinder(o)
local a=a:GetComponents()
LuaUtils.SetActive(o,true)
local o=t[e][1]
local e=t[e][2]
local t=ModulesInit.BagManager:GetBaseInfo(o,true)
LuaUtils.SetImageSprite(a["img_icon"],t.icon,false)
LuaUtils.SetLabelText(a["text_num"],"+"..e)
else
LuaUtils.SetActive(UIUtil.GetChild(a["reward_group"],e-1),false)
end
end
end
function PlayTaskNoticeRewardTween()
CloseTaskNoticeSeq()
local e=root_noticeTween.transform
local t=root_noticeTween:GetComponents()
local t=0.3
local h=0.2
local a=0.2
local n=26
local s=t/(t+a)
if llv_activity_pageview.gameObject.activeSelf then
LuaUtils.SetLocalPos(e,O,A,T)
else
LuaUtils.SetLocalPos(e,O,A+Q,T)
end
LuaUtils.SetLocalScale(e,0,1,1)
LuaUtils.SetActive(e,true)
local o=e:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
o.alpha=1
local r,i,r=LuaUtils.GetLocalPos(e)
local s=(i+n)*s
local i=i+n
d=CS.DG.Tweening.DOTween.Sequence()
d:Append(e:DOScale(1,h))
d:Append(e:DOLocalMoveY(s,t))
d:Append(e:DOLocalMoveY(i,a))
d:Join(o:DOFade(0,a))
d:SetDelay(0.1)
d:OnComplete(function()
CloseTaskNoticeSeq()
end)
end
function UpdateStateInfo()
if PlayerMgr.PlayerInfo and((PlayerMgr.PlayerInfo.guildId and PlayerMgr.PlayerInfo.guildId>0))then
local t=TimeUtil.GetServerToDHMS().hour
local e=TimeUtil.GetServerToDHMS().minute
local o=tonumber(Constant.citywar_declareStartHour)
local a=tonumber(Constant.citywar_declareStartMinute)
if t==o and e>=a and e<(a+1)then
ModulesInit.SkyCityMgr:GetAllSkyState2()
end
local o=tonumber(Constant.citywar_declareEndHour)
local a=tonumber(Constant.citywar_declareEndMinute)
if t==o and e>=a and e<(a+1)then
ModulesInit.SkyCityMgr:GetAllSkyState2()
end
local o=tonumber(Constant.citywar_battleEndHour)
local a=tonumber(Constant.citywar_battleEndMinute)
if t==o and e>=a and e<(a+1)then
ModulesInit.SkyCityMgr:GetAllSkyState2()
end
local o=tonumber(Constant.citywar_bullyBattleEndHour)
local a=tonumber(Constant.citywar_bullyBattleEndMinute)
if t==o and e>=a and e<(a+1)then
ModulesInit.SkyCityMgr:GetAllSkyState2()
end
end
RefreshFlowerStatusLock()
RefrshFSBStatus()
RefrshFSBYStatus()
end
function RefrshFSBStatus()
if ModulesInit.FullServerBattleMgr:isShowPreheat()then return end
if not ModulesInit.FullServerBattleMgr:IsCanReqServer()then return end
if PlayerMgr.PlayerInfo and((PlayerMgr.PlayerInfo.guildId and PlayerMgr.PlayerInfo.guildId>0))then
if ModulesInit.FullServerBattleMgr.FSBInfo==nil then
ModulesInit.FullServerBattleMgr:getFSBState(false)
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo.statusOverTime>0 then
local e=ModulesInit.FullServerBattleMgr.FSBInfo.statusOverTime-TimeUtil.GetServerTimeStamp()
if e<=-3 then
ModulesInit.FullServerBattleMgr:getFSBState(false)
end
end
local t=ActMgr:IsOpen(ModulesInit.FullServerBattleMgr.ACT_GIFT_BAG_ID)
local e=ModulesInit.FullServerBattleMgr.giftBagEndTime-TimeUtil.serverTimeStep
if t and e<=0 then
NetManager.SendEmpty(ProtoId.PRT_FSB_GIFT_INFO_REQ)
end
ModulesInit.ActIslandGiftMgr:TryOpenGiftViewFSBY(ModulesInit.FullServerBattleMgr,true)
elseif PlayerMgr.PlayerInfo then
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)then
ModulesInit.FullServerBattleMgr:reqFSBStatus()
end
end
end
function RefrshFSBYStatus()
if not ModulesInit.FullServerBattleYearMgr:IsOpen()then return end
if PlayerMgr.PlayerInfo and((PlayerMgr.PlayerInfo.guildId and PlayerMgr.PlayerInfo.guildId>0))then
if ModulesInit.FullServerBattleYearMgr.FSBInfo==nil then
ModulesInit.FullServerBattleYearMgr:getFSBState(false)
return
end
if ModulesInit.FullServerBattleYearMgr.FSBInfo.statusOverTime>0 then
local e=ModulesInit.FullServerBattleYearMgr.FSBInfo.statusOverTime-TimeUtil.GetServerTimeStamp()
if e<=-2 then
ModulesInit.FullServerBattleYearMgr:getFSBState(false)
end
end
local e=ActMgr:IsOpen(ModulesInit.FullServerBattleYearMgr.ACT_GIFT_BAG_ID)
local t=ModulesInit.FullServerBattleYearMgr.giftBagEndTime-TimeUtil.serverTimeStep
if e and t<=0 then
NetManager.SendEmpty(ProtoId.PRT_FSBY_GIFT_INFO_REQ)
end
end
end
function UpdateTitanFunc()
end
function InitActBtn()
p={}
for e=1,#le do
local e=le[e]
local e=be:Create(e)
table.insert(p,e)
end
end
function CloseActBtn()
for e=1,#p do
p[e]:OnClose()
end
end
function InitFaceActBtn()
y={}
for e=1,#ue do
local e=ue[e]
local e=ve:Create(e)
table.insert(y,e)
end
end
function CloseFaceActBtn()
for e=1,#y do
y[e]:OnClose()
end
end
function refreshAct()
refreshMainAct()
refreshFaceAct()
refreshLeftActView()
SetLimitPageView()
SetActJumpPageView()
end
function refreshMainAct()
local t=ActMgr:GetActInMain()
for e=1,#p do
p[e]:SetActive(false)
end
local e={}
for a,t in pairs(t)do
local t=t
for a=1,#t do
table.insert(e,t[a])
end
end
table.sort(e,function(t,e)
return t.actType<e.actType
end)
for a=1,#e do
local t=p[a]
local e=e[a]
if e~=nil then
t:SetActive(true)
t:Refresh(e)
else
t:SetActive(false)
end
end
end
function refreshFaceAct()
local t=ActMgr:GetActInMainFace()
for e=1,#y do
y[e]:SetActive(false)
end
local e={}
for a,t in pairs(t)do
local t=t
for a=1,#t do
table.insert(e,t[a])
end
end
table.sort(e,function(e,t)
return e.actType<t.actType
end)
for a=1,#e do
local t=y[a]
if t then
local e=e[a]
if e~=nil then
t:SetActive(true)
t:Refresh(e)
else
t:SetActive(false)
end
end
end
checkRefreshFaceActView()
end
function checkRefreshFaceActView()
if ActMgr:IsOpen(ModulesInit.FaceGiftManager.ACT_ID)then
local e=ActMgr:GetActServerData(ModulesInit.FaceGiftManager.ACT_ID)
if e and e.show then
local e,t=ModulesInit.FaceGiftManager:GetEnterShowGift()
if e then
LuaUtils.SetActive(faceGiftNode.transform,true)
refreshFaceActView(e)
else
LuaUtils.SetActive(faceGiftNode.transform,false)
end
else
LuaUtils.SetActive(faceGiftNode.transform,false)
end
else
LuaUtils.SetActive(faceGiftNode.transform,false)
end
end
function refreshFaceActView(e)
local e=ModulesInit.FaceGiftManager:GetGiftCfg(e.giftDid)
LuaUtils.SetImageSprite(im_face_icon,string.format('UIMainInterface/%s',e.mainIconNew))
LuaUtils.SetTextMeshText(txt_face_name,GameTools.GetLocalize(e.name,LanguageCategory.LangCommon))
refreshFaceActTime()
end
function refreshFaceActTime()
local e,t=ModulesInit.FaceGiftManager:GetEnterShowGift()
if e then
local e=e.endTimestamp-TimeUtil.serverTimeStep
if e>0 then
LuaUtils.SetTextMeshText(txt_face_time,TimeUtil.toDHMSStr2(e))
else
LuaUtils.SetTextMeshText(txt_face_time,'')
end
end
end
function OnPlayInfoChange()
if f==false then
C=true
return
end
refreshLeft()
end
function refreshLeft(e)
C=false

refreshPlayerHeadView()
refreshChat()
refreshLeftActView()
refreshOpenUnlockView()
LuaUtils.SetActive(im_youjian_bg.transform,GameTools:IsReview()==false)
LuaUtils.SetActive(im_haoyou_bg.transform,GameTools:IsReview()==false)
LuaUtils.SetActive(im_paihangbang_bg.transform,GameTools:IsReview()==false and GameFunction.IsFunctionUnLock(GameFunctionType.Rank))
LuaUtils.SetActive(im_funhandbook_bg.transform,GameTools:IsReview()==false and GameFunction.IsFunctionUnLock(GameFunctionType.FunHandBook))
if GameTools:IsReview()==false then
SetFuncShowStatus(node_renwu,GameFunctionType.Quest)
else
LuaUtils.SetActive(node_renwu.transform,false)
end
if GameTools:IsReview()==false or GameEntry.IsCommittee then
SetFuncShowStatus(btn_shangdian,GameFunctionType.shop)
else
LuaUtils.SetActive(btn_shangdian.transform,false)
end
end
function refreshOpenUnlockView()
LuaUtils.SetActive(openUnlockTips.transform,false)
local t,e=GameFunction:GetNoticeOpenData()
if t then
LuaUtils.SetActive(openUnlockTips.transform,true)
LuaUtils.SetTextMeshText(text_unLockTips,GameTools.GetLocalize(e.Desc,LanguageCategory.LangCommon))
end
end
function refreshPlayerHeadView()
UIUtil.SetPlayerIconFrame(head_yuan150,{head=PlayerMgr.PlayerInfo.head,headFrame=PlayerMgr.PlayerInfo.headFrame})
local e=ce.GetEntity(PlayerMgr.PlayerInfo.level)
if e==nil then
im_jingyan.fillAmount=1
else
local e=e.exp
local t=ModulesInit.BagManager:GetItemCountById(PROTO_ENUM.ENUM_CURRENCY.EXP)
im_jingyan.fillAmount=t/e
end
LuaUtils.SetTextMeshText(text_level_num,PlayerMgr.PlayerInfo.level)
local e=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_MAIN)
LuaUtils.SetTextMeshText(text_fight_num,UIUtil.toBigNum2(e))
LuaUtils.SetTextMeshText(text_player_name,PlayerMgr.PlayerInfo.name)
LuaUtils.SetActive(bg_guanzhi.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
PlayerMgr.PlayerInfo.officer and PlayerMgr.PlayerInfo.officer>0 then
LuaUtils.SetActive(bg_guanzhi.transform,true)
local e=bg_guanzhi.transform:GetComponent(typeof(CS.YouYou.YouYouImage))
GameTools:SetImageSprite(e,UIUtil.GetOfficerCapPath(PlayerMgr.PlayerInfo.officer))
local e=ModulesInit.OfficerMgr:getOfficeLevelShow(PlayerMgr.PlayerInfo.officer)
LuaUtils.SetTextMeshText(text_guan_num,e)
end
LuaUtils.SetActive(im_redpoint_name.transform,ChangeNameStatus())
LuaUtils.SetTextMeshText(text_vip_num,tostring(PlayerMgr.PlayerInfo.vip))
end
function ChangeNameStatus()
local e=false
local t=string.match(PlayerMgr.PlayerInfo.name,Constant.newbie_create_name.."+%d")
if t and PlayerMgr.PlayerInfo.changeNameCount<=0 then
e=true
end
return e
end
function refreshLeftActView()
local t=ActMgr:GetBannerAct()
e={}
for a,t in ipairs(t or{})do
if t.actId==405 then
local a=require("Modules/Act/ActSSR/ActJieYuanSRMgr")
local a=a:staticGetActAllCfgHeroArr(t.actId)
for o=1,#a do
local t={
actId=t.actId,
actHeroDid=a[o],
}
table.insert(e,t)
end
elseif t.actId==180 then
local t=pe.GetEntity(1).heroId
local t={
actId=180,
actHeroDid=t,
}
table.insert(e,t)
elseif t.actId==511 then
local t=ModulesInit.ActSelfMarryBackMgr:GetHeroId()
local t={
actId=511,
actHeroDid=t,
}
table.insert(e,t)
elseif t.actId==421 then
local t=ze.GetEntity(1).hero
local t={
actId=421,
actHeroDid=t,
}
table.insert(e,t)
elseif t.actId==427 then
local t={
actId=427,
actHeroDid=1098,
}
table.insert(e,t)
elseif t.actId==428 then
local t={
actId=428,
actHeroDid=1099,
}
table.insert(e,t)
elseif t.actId==239 then
if ActMgr:IsActShowInMain(t.actId)then
local t={
actId=t.actId,
actHeroDid=1,
}
table.insert(e,t)
end
else
local t={
actId=t.actId,
actHeroDid=1,
}
table.insert(e,t)
end
end
i={}
local t=#e
if t==1 then
table.insert(i,e[1])
table.insert(i,e[1])
table.insert(i,e[1])
else
table.insert(i,e[#e])
table.insert(i,e[1])
table.insert(i,e[2])
end
LuaUtils.SetActive(llv_activity_pageview.transform,t>0)
if t<=0 or GameTools:IsReview()or not n then
LuaUtils.SetActive(showBannerDescNode.transform,false)
LuaUtils.SetActive(bg_dibu.transform,false)
end
if t>0 then
local e=llv_activity_pageview:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
e.enabled=t>1
llv_activity_pageview:SetListItemCount(3,false)
llv_activity_pageview:RefreshAllShownItem()
llv_activity_pageview:MovePanelToItemIndex(1)
ScrollViewActBanner:SetListItemCount(t,false)
ScrollViewActBanner:RefreshAllShownItem()
end
local e=14
local e=math.min(t,e)
if#I~=e then
LuaUtils.DestroyChildren(bg_dot.transform)
I={}
for e=1,e do
local e=LuaUtils.Instantiate(im_dot_activity.transform)
LuaUtils.SetParent(e,bg_dot.transform)
LuaUtils.SetActive(e,true)
table.insert(I,e)
end
end
RefreshTemporaryBuffBtnShow()
refreshDot()
refreshBannerRed()
end
function refreshBannerRed()
LuaUtils.SetActive(img_actBanner_nun_bg.transform,false)
local t=0
for a=1,#e do
if ActMgr:CheckRedPoint(e[a].actId)then
t=t+1
end
end
if t>0 then
LuaUtils.SetActive(img_actBanner_nun_bg.transform,true)
LuaUtils.SetLabelText(text_actBanner_nun,t)
end
end
function OnPlayCurrencyRefresh()
if f==false then
P=true
return
end
refreshRight()
end
function refreshRight()
P=false
refreshRightGoldView()
refreshRightMiddleView()
refreshRightBottomView()
end
function refreshRightGoldView()
local e=ModulesInit.BagManager:GetItemCountById(PROTO_ENUM.ENUM_CURRENCY.GOLD)
LuaUtils.SetTextMeshText(text_num_gold,UIUtil.toBigNum(e))
local e=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.GOLD)
GameTools:SetImageSprite(im_icon_gold,e.icon,true)
local e=ModulesInit.BagManager:GetItemCountById(PROTO_ENUM.ENUM_CURRENCY.HOLY_CRYSTAL)
LuaUtils.SetTextMeshText(text_num_holy,UIUtil.toBigNum3(e))
local t=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.HOLY_CRYSTAL)
GameTools:SetImageSprite(im_icon_holy,t.icon,true)
if e<0 then
LuaUtils.SetActive(node_negative,true)
else
LuaUtils.SetActive(node_negative,false)
end
end
function refreshRightMiddleView()
local e=mian_wanfa_item_1:GetComponents()
LuaUtils.SetImageSprite(e["wanfaBgImg"],Y[1].bgImg)
LuaUtils.SetTextMeshText(e["text_name"],GameTools.GetLocalize(Y[1].text,LanguageCategory.LangCommon))
local e=mian_wanfa_item_2:GetComponents()
LuaUtils.SetImageSprite(e["wanfaBgImg"],Y[2].bgImg)
LuaUtils.SetTextMeshText(e["text_name"],GameTools.GetLocalize(Y[2].text,LanguageCategory.LangCommon))
SetLimitPageView()
SetActJumpPageView()
end
function OnActFirstDayRewardStatus()
SetLimitPageView()
end
function SetLimitPageView()
local a,t=ModulesInit.MainPageLimitMgr:checkCanShowLimitPage()
if re==a and de==t then
return
end
re=a
de=t
local e=mian_wanfa_item_3:GetComponents()
if a==nil then
LuaUtils.SetActive(mian_wanfa_item_3.transform,false)
else
if GameEntry.IsReview then
return
end
LuaUtils.SetActive(mian_wanfa_item_3.transform,true)
local t=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(t)
local a=ModulesInit.MainPageLimitMgr:GetLimitWanfaImg(t)
LuaUtils.SetImageSprite(e["wanfaBgImg"],a)
local a=ModulesInit.MainPageLimitMgr:GetLimitTitleText(t)
LuaUtils.SetTextMeshText(e["text_name"],a)
LuaUtils.SetActive(e["text_wanfaTips"].transform,false)
LuaUtils.SetActive(e["im_bg"].transform,false)
local t=ModulesInit.MainPageLimitMgr:GetLimitTipText(t)
if t~=""then
LuaUtils.SetActive(e["text_wanfaTips"].transform,true)
LuaUtils.SetTextMeshText(e["text_wanfaTips"],t)
LuaUtils.SetActive(e["im_bg"].transform,true)
end
end
end
function SetActJumpPageView()
local e=ModulesInit.MainPageLimitMgr:checkCanShowActJumpPage()
local t=mian_wanfa_item_4:GetComponents()
if e==nil then
LuaUtils.SetActive(mian_wanfa_item_4.transform,false)
else
if GameEntry.IsReview then
return
end
LuaUtils.SetActive(mian_wanfa_item_4.transform,true)
LuaUtils.SetImageSprite(t["wanfaBgImg"],e.showIcon)
LuaUtils.SetTextMeshText(t["text_name"],GameTools.GetLocalize(e.activityName,LanguageCategory.LangCommon))
local a=GameTools.GetLocalize(e.buttonKey,LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(t["text_wanfaTips"],a)
LuaUtils.SetActive(t["un_MainInterface_fire"].transform,e.activityId==ModulesInit.FullServerBattleYearMgr.ACT_ID)
end
end
function GetMainInletTopFunc()
local e={}
local t=ye.GetList()
for o=1,#t do
local i=0
if t[o].mainType==1 then
local a=we.GetEntity(t[o].functionId)
if a then
if GameFunction.IsFunctionUnLock(a.id)then
i=1
end
else
i=1
end
local a=#e+1
e[a]={}
e[a].sortId=i
e[a].cfg=t[o]
end
end
table.sort(
e,
function(e,t)
if e.sortId==t.sortId then
return t.cfg.list>e.cfg.list
else
return e.sortId>t.sortId
end
end
)
return e[1].cfg.functionId
end
function SetFuncShowStatus(e,t,n)
LuaUtils.SetActive(e.transform,false)
local o=GameFunction.IsConditionShow(t)
local a,t,i=GameFunction.IsFunctionUnLock(t,false)
local t="text_wanfaTips"
if n then
t='toggle_node/text_wanfaTips'
end
if o or a then
LuaUtils.SetActive(e.transform,true)
if o and not a then
SetActBtnGray(e.transform,true)
local a=e.transform:Find(t)
if IsNil(a)then
ErrInfoCollectMgr:AddInfo("default","UI_MainPage---","SetFuncShowStatus------"..tostring(t))
return true
end
LuaUtils.SetChildLabelTextMeshText(e.transform,t,i)
LuaUtils.SetActive(a.transform,true)
else
SetActBtnGray(e.transform,false)
local e=e.transform:Find(t)
if IsNil(e)then
ErrInfoCollectMgr:AddInfo("default","UI_MainPage---","SetFuncShowStatus------"..tostring(t))
return true
end
LuaUtils.SetActive(e.transform,false)
end
return true
end
return false
end
function SetActBtnGray(a,t)
local e=LuaUtils.GetLuaComBinder(a.transform)
if e then
local e=e:GetComponents()
if e and e["spine_root"]then
UIUtil.SetSpineRenderGray(e["spine_root"].transform,t)
end
end
UIUtil.SetSpriteRenderGray(a,t)
end
function refreshRightBottomView()
for e=4,7 do
LuaUtils.SetActive(selfEnv["toggle"..e],false)
end
local e=0
if GameTools:IsReview()==false then
local t=GetMainInletTopFunc()
local t=SetFuncShowStatus(selfEnv["toggle3"],t,true)
if t then
e=e+1
end
end
local t=SetFuncShowStatus(selfEnv["toggle5"],GameFunctionType.Guild,true)
if t then
e=e+1
end
local t=SetFuncShowStatus(selfEnv["toggle6"],GameFunctionType.City,true)
if t then
e=e+1
end
local t=SetFuncShowStatus(selfEnv["toggle4"],GameFunctionType.Amulet,true)
if t then
e=e+1
end
if SummonPetMgr:GetSummonPetUnlock()then
e=e+1
LuaUtils.SetActive(selfEnv["toggle7"],true)
end
LuaUtils.SetRectTransformSizeDelta(bg_bottom.transform,320+e*110,52)
end
function refreshMiddle(o,e)
local e=PlayerMgr.mainShowHeroList[t]
if e==nil then
e=PlayerMgr.mainShowHeroList[1]
end
local n=false
F=false
local i=e.heroDid
DynamicModuleRes.CheckResAndDownload({
[1]={i},
},function()
if e.isUnderwear then
n=true
UIUtil.GetPlayerUnderwearSpine(
i,
UI_heroSpine.transform,
"haremPara",
function(e)
a=e
r=nil
DisposeMarryHeroModel()
spinePoolDespawn()
if o then
o()
end
playLoopUnderwearSpine(e)
end
)
LuaUtils.SetActive(UI_touchSpine.transform,true)
elseif e.isMarry then
F=true
LuaUtils.SetActive(UI_touchSpine.transform,false)
UIUtil.SpinePoolDespawnAll(a,r)
a=nil
r=nil
SetMarryHeroModel(i)
if o then
o()
end
startTime()
elseif e.isSelfMarry then
F=true
LuaUtils.SetActive(UI_touchSpine.transform,false)
UIUtil.SpinePoolDespawnAll(a,r)
a=nil
r=nil
SetMarryHeroModel(i,true)
if o then
o()
end
startTime()
else
UIUtil.GetPlayerBigSpineAll(
i,
UI_heroSpine,
"homePara",
function(e,t)
a=e
r=t
DisposeMarryHeroModel()
spinePoolDespawn()
c=u.IDLE
if o then
o()
end
end
)
LuaUtils.SetActive(UI_touchSpine.transform,true)
local e=UIUtil.GetPaintingBg(i)
GameTools:LoadSpriteWithFullPath(UI_bg,e,true)
end
LuaUtils.SetActive(btn_marry.transform,false)
LuaUtils.SetActive(btn_qinmi.transform,false)
LuaUtils.SetActive(btn_qinmi2.transform,false)
LuaUtils.SetActive(btn_watch2.transform,false)
LuaUtils.SetActive(btn_watch.transform,false)
if n then
local a
local o=ie.GetList()
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
for o,t in ipairs(o)do
if t.heroId==e.heroDid and t.newUnlock==4 then
a=t.newUnlockPara
break
end
end
else
for o,t in ipairs(o)do
if t.heroId==e.heroDid and t.unlock==4 then
a=t.unlockPara
break
end
end
end
local o
if a then
o=ne.GetEntity(a)
end
if o then
local e="UIHaogandu/"..o.itemIcon
GameTools:SetImageSprite(im_lover,e,false)
GameTools:SetImageSprite(im_lover2,e,false)
LuaUtils.SetActive(btn_qinmi.transform,true)
local e=PlayerMgr.mainShowHeroList[t]
local t=HeroMgr:GetHeroDataByHeroDId(e.heroDid)
local e=N.GetEntity(e.heroDid)
if t.loverGrade<Constant.harem_unlock_item then
UIUtil.SetGray(btn_qinmi.transform,true)
else
UIUtil.SetGray(btn_qinmi.transform,false)
LuaUtils.SetActive(btn_qinmi2.transform,true)
end
end
local a
local o=ie.GetList()
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
for o,t in ipairs(o)do
if t.heroId==e.heroDid and t.newUnlock==8 then
a=t
break
end
end
else
for o,t in ipairs(o)do
if t.heroId==e.heroDid and t.unlock==8 then
a=t
break
end
end
end
if a then
local e=PlayerMgr.mainShowHeroList[t]
local e=HeroMgr:GetHeroDataByHeroDId(e.heroDid)
if a.loverGrade<=e.loverGrade then
LuaUtils.SetActive(btn_watch.transform,true)
LuaUtils.SetActive(btn_watch2.transform,true)
end
end
end
if F then
LuaUtils.SetActive(btn_marry.transform,true)
end
LuaUtils.SetActive(btn_left.transform,#PlayerMgr.mainShowHeroList>1)
LuaUtils.SetActive(btn_right.transform,#PlayerMgr.mainShowHeroList>1)
end)
end
function SetMarryHeroModel(a,t)
DisposeMarryHeroModel()
local e=self.Depth-1
UIUtil.GetPlayerLive2dModel(a,UI_heroSpine,nil,function(a,o)
h=a
m=o
X=t
if m then
local a=h:Find("live2d_Canvas")
local a=a:GetComponent(typeof(CS.UnityEngine.Canvas))
a.sortingOrder=e
local a=m:GetComponent(typeof(CS.YouYou.Live2DHelper))
if a then
a:SetDepth(e)
local e=h:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Open()
if t then
local e=e.scriptEnv
e.SwitchExpression(MarryExpressionGroup.selfExpression,true)
end
end
if GameTools.isSetActiveMode then
local e=m:GetComponent(typeof(CS.UnityEngine.Animator))
e.keepAnimatorControllerStateOnDisable=true
end
else
local t=a:GetComponent(typeof(CS.UnityEngine.Canvas))
t.sortingOrder=e
end
end)
end
function DisposeMarryHeroModel()
if h and m then
if h then
local e=h:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
end
UIUtil.Live2dPoolDespawnAll(h,m)
h=nil
m=nil
X=nil
end
ModulesInit.VoiceManager.StopAudio()
end
function playLoopUnderwearSpine(e)
local a=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
local e
e=function(o)
local t="A"
if o=="A"then
t="A1"
end
return a:PlayAnimation(0,t,false,e)
end
c=u.IDLE
a:PlayAnimation(0,"A",false,e)
end
function UpdateRefreshRedPoint()
if x==true then
local e=Time.realtimeSinceStartup-G
if e>0.3 then
G=Time.realtimeSinceStartup
else
return
end
local e=ViewMgr:checkIsTopShowView(self.UIFormId)
if e then
RefreshRedPoint()

end
end
end
function RefreshRedPoint()
D:PushSample(D.ESampleType.UI_MainPage_RefreshRedPoint)
DoRefreshRedPoint()
D:PopSample(D.ESampleType.UI_MainPage_RefreshRedPoint)
end
function onRedPointChange()
x=true
end
function DoRefreshRedPoint()
x=false
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.FRIEND)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.FRIEND_GIFT)then
LuaUtils.SetActive(im_redpoint_haoyou.transform,true)
else
LuaUtils.SetActive(im_redpoint_haoyou.transform,false)
end
do
local i,o=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAIL_RED,true)
local e,t=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAIL_RED_SYS,true)
local n,a=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAIL_RED_SOCIAL,true)
if i or e or n then
LuaUtils.SetChildActive(im_youjian_bg.transform,'qipao',true)
local e=0
if o then
e=e+o.pointNum
end
if t then
e=e+t.pointNum
end
if a then
e=e+a.pointNum
end
LuaUtils.SetChildLabelText(im_youjian_bg.transform,'qipao/text_num',e)
else
LuaUtils.SetChildActive(im_youjian_bg.transform,'qipao',false)
end
end
do
if GameFunction.IsFunctionUnLock(GameFunctionType.Quest)then
local e=RedPointMgr:CheckQuestRed()
LuaUtils.SetChildActive(btn_renwu.transform,'im_red',e)
else
LuaUtils.SetChildActive(btn_renwu.transform,'im_red',false)
end
end
do
if RedPointMgr:checkVIPRedPoint()then
LuaUtils.SetActive(im_redpoint_vip.transform,true)
else
LuaUtils.SetActive(im_redpoint_vip.transform,false)
end
end
refreshAct()
RefreshShopRedPoint()
local t=mian_wanfa_item_1:GetComponents()
local e=false
LuaUtils.SetActive(t["im_new"],false)
LuaUtils.SetActive(t["im_redpoint"],false)
if CheckAdventure(true)then
local a=nil
if v then a=v.state end
e=RedPointMgr:checkAdventureNew(a)
LuaUtils.SetActive(t["im_new"],e)
if not e then
e=RedPointMgr:checkAdventureRedPoint()
LuaUtils.SetActive(t["im_redpoint"],e)
end
end
local t=mian_wanfa_item_2:GetComponents()
local e=false
LuaUtils.SetActive(t["im_redpoint"],false)
LuaUtils.SetActive(t["im_new"],false)
local a=nil
if v then a=v.state end
e=RedPointMgr:checkArenaNew(a)
LuaUtils.SetActive(t["im_new"],e)
if not e then
e=RedPointMgr:checkJingjiFrameRedPoint()
LuaUtils.SetActive(t["im_redpoint"],e)
end
RefreshBomRedPoint()
refreshBannerRed()
LuaUtils.SetActive(world_node_red.transform,RedPointMgr.checkFightRedPoint())
LuaUtils.SetActive(im_redpoint_line.transform,RedPointMgr:GetLineRedStatus())
local e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.FUNCTION_HAND_BOOK)or ModulesInit.FunctionHandBookMgr:CheckMainRed()
LuaUtils.SetActive(im_redpoint_funhandbook.transform,e)
end
function RefreshBomRedPoint()
local e=HeroMgr.canComposeHeroCount>0
LuaUtils.SetActive(im_camp_can_compose.transform,e)
if not e then
local e=RedPointMgr:checkCampRedPoint()
LuaUtils.SetActive(im_camp_red_point.transform,e)
local t=RedPointMgr:checkunderwearGiftRed()
LuaUtils.SetActive(im_camp_underwear_gift.transform,not e and t)
LuaUtils.SetActive(im_camp_shengji.transform,false)
if not t and not e and RedPointMgr:checkCampGreenUp()then
LuaUtils.SetActive(im_camp_shengji.transform,true and HeroMgr.canComposeHeroCount==0)
end
end
CheckBagTip()
LuaUtils.SetActive(btnToggle3.transform.parent:Find("im_red"),CheckShouhuBtnRedDot())
LuaUtils.SetActive(guild_red_point.transform,RedPointMgr:checkGuildRedPoint())
if GameFunction.IsFunctionUnLock(GameFunctionType.City,false)then
local e=false
LuaUtils.SetActive(im_city_buildable.transform,false)
LuaUtils.SetActive(im_city_qipaoup.transform,false)
LuaUtils.SetActive(im_city_full.transform,false)
LuaUtils.SetActive(city_red_point.transform,false)
e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_CAN_BUILD)
LuaUtils.SetActive(im_city_buildable.transform,e)
if not e then
e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_LEVEL_UP)
LuaUtils.SetActive(im_city_qipaoup.transform,e)
end
if not e then
e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_AWARD)
LuaUtils.SetActive(im_city_full.transform,e)
end
if not e then
e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_DOG)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_HAREM_POWER)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_DISPATCH_HERO)
or ActMgr:CheckRedPoint(123)
LuaUtils.SetActive(city_red_point.transform,e)
end
if not e then
e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_GRADUATED)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_EMPTY_PLACE)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_MATCH)
or(RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_EP)and ModulesInit.SchoolMgr:CheckGoldRed())
or#ModulesInit.SchoolMgr.graduateTable>0
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_JOB_AWARD)
or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SCHOOL_FREE_CLAZZ)
LuaUtils.SetActive(city_red_point.transform,e)
end
end
LuaUtils.SetActive(im_fuhu_red.transform,AmuletMgr:CheckRedPoint())
LuaUtils.SetActive(im_summonpet_red_point.transform,RedPointMgr:CheckSummonPetRedPoint())
end
function CheckShouhuBtnRedDot()
if GameFunction.IsFunctionUnLock(GameFunctionType.Gallery)and(RedPointMgr:checkTujianRedPoint()or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.HERO_SOLDER)or RedPointMgr:checkTujianVideoRedPoint())then
return true
end
local t,e=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAP_STORY_SESSION,true)
if GameFunction.IsFunctionUnLock(GameFunctionType.Tale)and(t and(e and e.pointNum==2))then
return true
end
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer)and RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.OFFICER_UPGRADE)then
return true
end
if GameFunction.IsFunctionUnLock(GameFunctionType.Marry)and(RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_HAREM_POWER)or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_UPGRADE)or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_COMPOSE))or RedPointMgr:checkMarrySkillRed()then
return true
end
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.HERO_WALL)then
return true
end
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CAMP_RED)then
return true
end
if RedPointMgr:checkDeityStatueRedPoint()then
return true
end
return false
end
function CheckBagTip()
local e=ModulesInit.BagManager:checkEquipBagIsFull()
LuaUtils.SetActive(spine_bag_full.transform,e)
if e then
local e=spine_bag_full:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:ClearTracks()
e:PlayAnimation(0,"idle",true)
LuaUtils.SetActive(im_bag_red.transform,false)
else
LuaUtils.SetActive(im_bag_red.transform,CheckItemAir())
end
end
function CheckItemAir()
local e=ModulesInit.BagManager:GetBagItemDidByType(ModulesInit.BagManager.TAB_TYPE.ITEM)
for t,e in pairs(e)do
local e=ke.GetEntity(e)
if e.isExclamation==1 then
return true
end
end
if HeroMgr.canComposeHeroCount>0 then
return true
end
return false
end
function onNewShowChange(e)
local e=RedPointMgr:checkCampNew()
LuaUtils.SetActive(im_camp_new.transform,e and HeroMgr.canComposeHeroCount==0)
local e=RedPointMgr:checkGuildCanJoin()
local t=RedPointMgr:checkGuildNew()
LuaUtils.SetActive(im_guild_can_join.transform,e)
LuaUtils.SetActive(im_guild_new.transform,not e and t)
LuaUtils.SetActive(im_summonpet_new.transform,RedPointMgr:checkSummonPetNew())
end
function onMailAnimationCheck(e)
local e=function()
local e=im_youjian_bg.transform:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
if e then
if not ModulesInit.MailManager:IsContainsNotReadInListByType(2)then
LuaUtils.SetLocalScale(im_youjian_bg.transform,1,1,1)
GameObject.Destroy(e)
end
end
end
if not ModulesInit.MailManager.mailData then
local t=ModulesInit.MailManager:SendMailListRequest()
t.onCompleted=function()
e()
end
else
e()
end
end
function CheckGuildInvite()
local e=SaveMgr.GetBoolForKey("GuideInviteFirstShow",false)
if not ModulesInit.GuideMgr.isGuide and not e and GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and PlayerMgr.PlayerInfo.level>=Constant.guild_create_level and PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
end
end
function startTime()
end
function changeBg(e)
if#PlayerMgr.mainShowHeroList>1 and e~=0 and E then
t=t+e
if t>#PlayerMgr.mainShowHeroList then
t=1
elseif t<1 then
t=#PlayerMgr.mainShowHeroList
end
UI_heroSpine.transform:DOKill()
local e=0.2
E=false
refreshMiddle(
function()
UI_heroSpine.transform.position=ee
if PlayerMgr.mainShowHeroList[t].isUnderwear==false then
playSpecialAction()
else
playFavorabilityAction("playBedtouchVoice")
end
LuaUtils.SetActive(p_changeBgHero.transform,false)
LuaUtils.SetActive(p_changeBgHero.transform,true)
local e,a=PlayerMgr:sendMainBgIndex(t)
e.onCompleted=function()
PlayerMgr.PlayerInfo.showHeroIndex=t
E=true
end
end
)
else
UI_heroSpine.transform.position=ee
E=not E
end
end
function playSpecialAction()
if r then
if o==nil then
o=0
end
local a=PlayerMgr.mainShowHeroList[t]

local e=a.heroDid
local t=UIUtil.GetHeroModelCfgData(e)
local e
if a.isUnderwear==false then
e=t.paintingVoice
else
e=t.painting2Voice
end
o=o+1
if o>#e[2]then
o=1
end
playMusic(e[1][o])
end
end
function playInteractionAction()
c=u.INTERACTION
if o==nil then
o=0
end
local a=PlayerMgr.mainShowHeroList[t]
local e=a.heroDid
local t=UIUtil.GetHeroModelCfgData(e)
local e
if a.isUnderwear==false then
e=t.paintingVoice
else
e=t.painting2Voice
end
o=o+1
if o>#e[1]then
o=1
end
playMusic(e[1][o])
end
function playWatchAction()
if a then
local e=a:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
e:ClearComplete()
e:PlayAnimation(
0,
"A3",
false,
handler(
a,
function(t)
if t==a then
e:PlayAnimation(0,"A",true)
playLoopUnderwearSpine(t)
c=u.IDLE
end
end
)
)
end
c=u.WATCH
local e=PlayerMgr.mainShowHeroList[t]
ModulesInit.VoiceManager.PlayHeroVoiceType(e.heroDid,HERO_VOICE_TYPE.WATCH)
end
function playFavorabilityAction(i)
if a then
local e=a:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
e:ClearComplete()
e:PlayAnimation(
0,
"A2",
false,
handler(
a,
function(t)
if t==a then
e:PlayAnimation(0,"A",true)
playLoopUnderwearSpine(t)
c=u.IDLE
end
end
)
)
end
c=u.FAVORABILITY
if o==nil then
o=0
end
local e=PlayerMgr.mainShowHeroList[t]
if i=="playItemVoice"then
local e=e.heroDid
local e=ne.GetEntity(e*100+91)
o=o+1
if o>#e.itemVoice then
o=1
end
playMusic(e.itemVoice[o])
else
ModulesInit.VoiceManager.PlayHeroVoiceType(e.heroDid,HERO_VOICE_TYPE.BEDTOUCH)
end
end
function playMusic(t,e)
local e=ViewMgr:getLastOpenView()
if e~=UIFormId.UI_MainPage and e~=UIFormId.UI_DrawMarquee and e~=UIFormId.UI_PlayBgDownload then
return
end
local e=ge.GetEntity(t)
if e==nil then return end
local t=je.GetEntity(e.voiceID)
if t==nil then return end
ModulesInit.VoiceManager.PlayHeroVoiceId(e.voiceID)
end
function spinePoolDespawn()
if h and m then
DisposeMarryHeroModel()
else
for e=1,LuaUtils.GetChildrenCount(UI_heroSpine)do
local e=UIUtil.GetChild(UI_heroSpine,e-1)
if e~=a then
UIUtil.SpinePoolDespawn(e)
end
end
end
end
function onMainBgChange()
t=PlayerMgr.PlayerInfo.showHeroIndex
refreshMiddle()
end
function OnGetItemByIndex(t,o)
o=o+1
local t=t:NewListViewItem("btn_huodong3")
local a=LuaUtils.GetLuaComBinder(t.transform)
local a=a:GetComponents()
local i=i[o]
local h=i.actId
local h,i=ActMgr:GetActivityBannerIcon(h,i.actHeroDid)
GameTools:SetImageSprite(a["im_banner"],h)
LuaUtils.SetActive(a["im_newstar"].transform,false)
if i and i~=0 then
local e=N.GetEntity(i)
local t=ModulesInit.ActSelfMarryMgr:IsMarryNewStar(i)
if e and e.newstarShow==1 or t then
LuaUtils.SetActive(a["im_newstar"].transform,true)
end
end
if t.IsInitHandlerCalled==false then
a["btn_huodong3"].onClick:AddListener(
handler(
t,
function(t)
n=not n
LuaUtils.SetActive(showBannerDescNode.transform,n)
LuaUtils.SetActive(bg_dibu.transform,n)
CheckOnOpenBannerHideAutoHelper()
if n then
ScrollViewActBanner:RefreshAllShownItem()
ScrollViewActBanner:MovePanelToItemIndex(s-1)
LuaUtils.SetActive(img_actBannerJiantouXia.transform,false)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,false)
if#e>3 then
if UIUtil.isScrollViewStart(ScrollViewActBanner)==true then
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
elseif UIUtil.isScrollViewEnd(ScrollViewActBanner)==true then
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
else
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
end
end
end
end
)
)
t.IsInitHandlerCalled=true
end
t.UserObjectData=o
return t
end
function OnGetBannerItemByIndex(t,i)
i=i+1
local o=t:NewListViewItem("tab_item")
local t=LuaUtils.GetLuaComBinder(o.transform)
local a=t:GetComponents()
local s=e[i]
local t=s.actId
local h,s=ActMgr:GetActivityBannerIcon2(t,s.actHeroDid)
local s=a['im_act'].transform:GetComponent(typeof(CS.YouYou.YouYouImage))
GameTools:SetImageSprite(s,h)
LuaUtils.SetActive(a["im_redpoint"].transform,ActMgr:CheckRedPoint(t))
LuaUtils.SetActive(a["text_actTime"].transform,false)
if t>=550 and t<=553 and ActMgr:IsOpen(t)then
local e=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketOpenTime(t)
local o=TimeUtil:GetServerTimeStamp()
if o<e then
LuaUtils.SetActive(a["text_actTime"].transform,true)
local t=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketNoticeCfg(t)
local e=TimeUtil.timeStampToMD(e)
local e=GameTools.GetLocalize(t.noticeTips,LanguageCategory.LangCommon,e)
LuaUtils.SetTextMeshText(a["text_actTime"],e)
else
LuaUtils.SetActive(a["text_actTime"].transform,false)
end
end
if o.IsInitHandlerCalled==false then
a["im_act"].onClick:AddListener(
handler(
o,
function(t)
n=false
LuaUtils.SetActive(showBannerDescNode.transform,n)
LuaUtils.SetActive(bg_dibu.transform,n)
CheckOnOpenBannerHideAutoHelper()
local t=e[t.UserObjectData]
local e=t.actId
local a,t=ActMgr:GetActivityBannerIcon2(e,t.actHeroDid)
if t and t~=0 then
if e==421 then
ActMgr:CheckJumpViewById(e,{heroDid=t})
else
ActMgr:CheckJumpViewById(e)
end
else
if e>=550 and e<=553 then
local t=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketOpenTime(e)
local a=TimeUtil.GetServerTimeStamp()
if a<t then
n=true
LuaUtils.SetActive(showBannerDescNode.transform,n)
ActMgr:ShowActCloseTip(e)
CheckOnOpenBannerHideAutoHelper()
else
ActMgr:CheckJumpViewById(e)
end
else
ActMgr:CheckJumpViewById(e)
end
end
end
)
)
o.IsInitHandlerCalled=true
end
o.UserObjectData=i
return o
end
function MaintoDHMSStr(t)
local e=""
if t.month<10 then
e=LuaUtils.StringFormat('0{0}/',t.month)
else
e=LuaUtils.StringFormat('{0}/',t.month)
end
if t.day<10 then
local a=GameTools.GetLocalize("UI.Equip.Common.11",LanguageCategory.LangCommon,t.day)
e=LuaUtils.StringFormat('{0}0{1} ',e,t.day)
else
e=LuaUtils.StringFormat('{0}{1} ',e,t.day)
end
if t.hour<10 then
e=LuaUtils.StringFormat('{0}0{1}:',e,t.hour)
else
e=LuaUtils.StringFormat('{0}{1}:',e,t.hour)
end
if t.minute<10 then
e=LuaUtils.StringFormat('{0}0{1}:',e,t.minute)
else
e=LuaUtils.StringFormat('{0}{1}:',e,t.minute)
end
if t.second<10 then
e=LuaUtils.StringFormat('{0}0{1}',e,t.second)
else
e=LuaUtils.StringFormat('{0}{1}',e,t.second)
end
return e
end
function OnSnapNearestChanged(a)
b=0
i={}
if#e<=1 then
return
end
local t
if a>0 then
s=s+1
t=llv_activity_pageview:GetShownItemByItemIndex(2)
else
s=s-1
t=llv_activity_pageview:GetShownItemByItemIndex(0)
end
if s<=0 then
s=#e
end
if s>#e then
s=1
end
if s==1 then
table.insert(i,e[#e])
table.insert(i,e[1])
table.insert(i,e[2]or e[1])
elseif s==#e then
table.insert(i,e[#e-1])
table.insert(i,e[#e])
table.insert(i,e[1])
else
table.insert(i,e[s-1])
table.insert(i,e[s])
table.insert(i,e[s+1])
end
llv_activity_pageview.ContainerTrans.transform:DOKill()
llv_activity_pageview.ContainerTrans.transform:DOLocalMoveX(-t.transform.localPosition.x,0.2):SetEase(CS.DG.Tweening.Ease.OutCubic)
V=true
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.2)
e:AppendCallback(
function()
llv_activity_pageview:RefreshAllShownItem()
llv_activity_pageview:MovePanelToItemIndex(1)
V=false
end
)
R=e
refreshDot()
end
function refreshDot()
local e=#I
if e>0 then
local t=(s-1)%e+1
for a,o in ipairs(I or{})do
local e
if a==t then
e="UIMainInterface/T_dangqianyemian"
else
e="UIMainInterface/T_dangqianyemian_1"
end
local t=o:GetComponent(typeof(CS.YouYou.YouYouImage))
if t then
GameTools:SetImageSprite(t,e)
end
end
end
end
function OnActivityBeginDrag()
W=true
end
function OnActivityDrag()
local t=llv_activity_pageview.ContainerTrans.localPosition.x
local a=llv_activity_pageview:GetShownItemByItemIndex(1)
local e=true
if t>0 then
e=false
elseif math.abs(t)>(a.transform.sizeDelta.x*2)then
e=false
end
local t=llv_activity_pageview:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
t.enabled=e
end
function OnActivityEndDrag()
W=false
if#i<=1 then
return
end
if V==true then
return
end
local t=llv_activity_pageview.ContainerTrans.localPosition.x
local e=llv_activity_pageview:GetShownItemByItemIndex(1)
if math.abs(t)>e.transform.sizeDelta.x then
OnSnapNearestChanged(1)
else
OnSnapNearestChanged(-1)
end
local e=llv_activity_pageview:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
e.enabled=true
end
function OnActBannerScrollEnd()
LuaUtils.SetActive(img_actBannerJiantouXia.transform,false)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,false)
if UIUtil.isScrollViewStart(ScrollViewActBanner)==true and#e>3 then
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
elseif UIUtil.isScrollViewEnd(ScrollViewActBanner)==true and#e>3 then
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
else
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
end
end
function getShowChatType()
local e=PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_WORLD
local t={}
if ChatMgr.LastChatType~=nil then
if ChatMgr.LastChatType~=PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_GUILD or PlayerMgr.PlayerInfo.guildId>0 then
e=ChatMgr.LastChatType
t=ChatMgr.LastChatTypeInfo
end
end
return e,t
end
function OnCloseChatView()
refreshChat()
end
function refreshChat()
local e,t=getShowChatType()
local a=ChatMgr:getMsgListByType(e,t.playerId)
LuaUtils.SetActive(p_chat_private.transform,e==PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_PRIVATE)
LuaUtils.SetActive(img_chat_type.transform,e~=PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_PRIVATE)
if e==PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_PRIVATE then
local a=UIUtil.GetPlayerIcon(t.icon)
local e=p_chat_private_head:GetComponent(typeof(CS.UnityEngine.UI.Image))
GameTools:SetImageSprite(e,a,false)
local e=UIUtil.GetPlayerFrame(t.frame)
if e then
GameTools:SetImageSprite(p_chat_private_frame,e,false)
else
GameTools:SetImageSprite(p_chat_private_frame,"UIHeroHead/UIHeroHead_1/headframe_01",false)
end
LuaUtils.SetLabelText(p_chat_private_name,t.name)
else
GameTools:SetImageSprite(img_chat_type,"UIMainInterface/chat_mainpage_title"..e,true)
end
if a then
z=a.content or{}
else
z={}
end
he=e
llvChat:SetListItemCount(#z)
llvChat:RefreshAllShownItem()
llvChat:MovePanelToItemIndex(#z)
end
function receiveNewMsg()
refreshChat()
end
function onChatList(t,s)
s=s+1
local h=he
local a=z[s]
local e=""
local o=ChatMgr.MSG_TYPE.CAT
local i
if a.msgTempDid==ChatMgr.TEMP_ID.LUCKY_WISH_REWARD or a.msgTempDid==ChatMgr.TEMP_ID.DRAW_LUCKY then
o=ChatMgr.MSG_TYPE.LUCKYREWARD
e=ChatMgr:getTempMsg2(a)
elseif a.msgTempDid==ChatMgr.TEMP_ID.GUILD_RECRUIT_CHAT then
o=ChatMgr.MSG_TYPE.OTHER
e=ChatMgr:getTempMsg(a)
elseif a.msgTempDid==ChatMgr.TEMP_ID.DRAGON_BOAT_FINISH then
o=ChatMgr.MSG_TYPE.OTHER
e=ModulesInit.DragonBoatMgr:GetFinishChatString(a.msgTempDid,a.msgTempArgs[1])
elseif a.msgTempDid==ChatMgr.TEMP_ID.SHARE_SUPER_FISH then
o=ChatMgr.MSG_TYPE.SUPER_FISH
local t,a=ModulesInit.ActActivityFishingMgr:AnalysisFishShareArgs(a.msgTempArgs)
e=GameTools.GetLocalize("act_actfishing_fishing_14",LanguageCategory.LangCommon,t.fishName,ModulesInit.ActActivityFishingMgr:GetFishQualityShow(t.fishQuality))
elseif a.msgTempDid~=0 then
e=ChatMgr:getTempMsg(a)
else
e,o=ChatMgr:analysisMainPageMsg(a.msg)
end
if o==ChatMgr.MSG_TYPE.CAT then
i=t:NewListViewItem("cat")
elseif o==ChatMgr.MSG_TYPE.OTHER then
i=t:NewListViewItem("other")
elseif o==ChatMgr.MSG_TYPE.DOG then
i=t:NewListViewItem("dog")
elseif o==ChatMgr.MSG_TYPE.AVG then
i=t:NewListViewItem("avg")
elseif o==ChatMgr.MSG_TYPE.LUCKYREWARD then
i=t:NewListViewItem("lucky")
elseif o==ChatMgr.MSG_TYPE.HEROEVENT then
i=t:NewListViewItem("heroEvent")
elseif o==ChatMgr.MSG_TYPE.SUPER_FISH then
i=t:NewListViewItem("superFish")
end
local n=a.senderName
if a.senderId==0 then
n=""
end
if h==PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_CROSS then
n="[S"..a.serverId.."]"..n
end
if i.IsInitHandlerCalled==false then
local e=LuaUtils.GetLuaComBinder(i.transform)
local e=e:GetComponents()
i.BiComs=e
i.IsInitHandlerCalled=true
if e["text_youjian"]then
local t=e["text_youjian"]:GetComponent(typeof(CS.YouYou.ClickRichText))
t.OnTClickRich=touchChatUrl
addTouchEvent(
e["text_youjian"].transform,
handler(
i,
function(e)
H=e
end
),
handler(
i,
function(e)
if H~=nil then
onChat()
end
end
),
function()
H=nil
end
)
end
end
i.UserObjectData=s
local t=i.BiComs
local h=ChatMgr.MAIN_SHOW_INFO[h]
LuaUtils.SetImageSprite(t["bg_name"],h.bg,false)
LuaUtils.SetLabelText(t["text_name"],GameTools.GetLocalize(h.txt,LanguageCategory.LangCommon))
if o==ChatMgr.MSG_TYPE.CAT or o==ChatMgr.MSG_TYPE.AVG or o==ChatMgr.MSG_TYPE.OTHER then
local h=t["text_youjian"]:GetComponent(typeof(CS.YouYou.ClickRichText))
h.UserObjectData=s
if a.senderId~=0 then
e=" <color=#238ADF>"..n..":</color>"..e
else
e=" "..e
end
LuaUtils.SetTextMeshText(t["text_youjian"],e)
if o==ChatMgr.MSG_TYPE.CAT or o==ChatMgr.MSG_TYPE.OTHER then
local e=t["text_youjian"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
local e=t["player"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
local e=t["bg_name"].transform.localPosition
e.y=0
local a=t["text_youjian"].transform.sizeDelta
if a.y>21 and a.y<40 then
e.y=-6
end
t["bg_name"].transform.localPosition=e
LuaUtils.RebuildLayout(i.transform)
end
elseif o==ChatMgr.MSG_TYPE.LUCKYREWARD then
if a.senderId~=0 then
e=" <color=#238ADF>"..n..":</color>"..e
else
e=" "..e
end
LuaUtils.SetTextMeshText(t["text_youjian"],e)
local e=t["text_youjian"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
local e=t["bg_name"].transform.localPosition
e.y=0
local a=t["text_youjian"].transform.sizeDelta
if a.y>21 and a.y<40 then
e.y=-6
elseif a.y>40 then
e.y=24
end
t["bg_name"].transform.localPosition=e
LuaUtils.RebuildLayout(i.transform)
elseif o==ChatMgr.MSG_TYPE.SUPER_FISH then
e=" <color=#238ADF>"..n..":</color>"..e
LuaUtils.SetTextMeshText(t["text_youjian"],e)
local e=t["text_youjian"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
local e=t["bg_name"].transform.localPosition
e.y=0
local a=t["text_youjian"].transform.sizeDelta
if a.y>21 and a.y<40 then
e.y=-6
elseif a.y>40 then
e.y=24
end
t["bg_name"].transform.localPosition=e
LuaUtils.RebuildLayout(i.transform)
elseif o==ChatMgr.MSG_TYPE.HEROEVENT then
local o=xe.GetEntity(e)
LuaUtils.AnimtorPlay(t["aniEmoji"],o.anim,0,0)
if a.senderId~=0 then
e=" <color=#238ADF>"..n..":</color>"
end
LuaUtils.SetTextMeshText(t["text_youjian"],e)
else
local o=qe.GetEntity(e)
LuaUtils.AnimtorPlay(t["aniEmoji"],o.anim,0,0)
if a.senderId~=0 then
e=" <color=#238ADF>"..n..":</color>"
end
LuaUtils.SetTextMeshText(t["text_youjian"],e)
end
return i
end
function touchChatUrl(e,t,t,t)
local e=e
local e=z[e]
local e=e.content
if e.msgTempDid==ChatMgr.TEMP_ID.ARENA_BATTLE_LOG then
local e=e.msgTempArgs
ChatMgr:gotoArenaBtttle(e)
elseif e.msgTempDid==ChatMgr.TEMP_ID.DRAGON_GROUP then
local e=e.msgTempArgs
ChatMgr:gotoDragonGroup(e)
elseif e.msgTempDid==ChatMgr.TEMP_ID.WORLDTREE_GROUP then
local e=e.msgTempArgs
ChatMgr:gotoWorldTreeGroup(e)
end
end
function addTouchEvent(a,i,o,t)
local e=llvChat:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
local n=function(...)
if t then
t()
end
e:OnBeginDrag(...)
llvChat:OnBeginDrag(...)
end
local t=function(...)
e:OnDrag(...)
llvChat:OnDrag(...)
H=nil
end
local e=function(...)
e:OnEndDrag(...)
llvChat:OnEndDrag(...)
end
UIUtil.AddTouchEventMulti(a,i,o,n,t,e)
end
function onChat()
local t,e=getShowChatType()
EventSystem.SendEvent(CommonEventId.OnShowChatView,{
type=t,
playerId=e.playerId,
icon=e.icon,
name=e.name,
serverId=e.serverId,
frame=e.frame,
time=e.time,
icon=e.icon,
})
end
function OnQuestDataChange(e)
end
function OnEventActInfoChange(e)
refreshAct()
refreshRight()
if GameFunction.IsFunctionUnLock(GameFunctionType.Chat)then
LuaUtils.SetActive(llvChat.transform,true)
else
LuaUtils.SetActive(llvChat.transform,false)
end
RefreshShopRedPoint()
end
function PlayerLevelUp()
refreshTaskNoticeView()
OnEventActInfoChange()
ModulesInit.MineMgr:CheckAndReqStatus()
CheckOnOpenBannerHideAutoHelper()
end
function RefreshShopRedPoint()
local e=ModulesInit.ActBlackFridayMgr:HasPrivilege()
LuaUtils.SetActive(node_friday.transform,e)
LuaUtils.SetActive(im_redpoint_shangdian.transform,RedPointMgr:checkVipShopPoint())
end
function SetHeroSpineGray(e)
if r then
UIUtil.SetSpineRenderGray(r,e)
end
if a then
local t=PlayerMgr.mainShowHeroList[t]
if t==nil then
t=PlayerMgr.mainShowHeroList[1]
end
local o=false
local t=t.heroDid
local o=N.GetEntity(t)
local t=a:Find("Painting_"..o.modelID.."_front")
if t then
UIUtil.SetSpineRenderGray(t,e)
end
local t=a:Find("Painting_"..o.modelID.."_back")
if t then
UIUtil.SetSpineRenderGray(t,e)
end
end
end
function OnEventRespError(e)
if e.protoCode==ProtoId.PRT_FLOWER_SIGN_REQ then
ReqFloweServerData()
end
end
function RefreshFlowerStatusLock()
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
if e then
if U==nil
or(U.upgrade and(U.upgradeEndTimestamp-TimeUtil.GetServerTimeStamp()<0))
or(v and(v.stateOverTime-TimeUtil.GetServerTimeStamp()<0))
then
ReqFloweServerData()
end
end
end
function ReqFloweServerData()
local e=ModulesInit.FlowerFightMgr:ReqFlowerEntranceInfo(function(e)
U=e
v=e.raceInfo
ModulesInit.MainPageLimitMgr.mFlowerServerInfo=e
ModulesInit.MainPageLimitMgr.mFlowerRaceInfo=e.raceInfo
end)
end
function onBtnHead()
GameEntry.UI:OpenUIForm(UIFormId.UI_SystemSet)
end
function onBtnVip()
GameEntry.UI:OpenUIForm(UIFormId.UI_VIPMaim)
end
function onBtnHideUI()
LuaUtils.AnimtorPlay(UI_MainInterface,"UI_MainInterface_out",0,0)
LuaUtils.SetActive(autoHelper_Root.transform,false)
LuaUtils.SetActive(btn_show.transform,true)
EventSystem.SendEvent(CommonEventId.DrawMarqueeMsgNotify,{hide=1})
end
function onBtnShow()
LuaUtils.AnimtorPlay(UI_MainInterface,"UI_MainInterface_in",0,0)
OnDelayDoCallBack(0.2,RefereshAutoHelperView)
LuaUtils.SetActive(btn_show.transform,false)
EventSystem.SendEvent(CommonEventId.DrawMarqueeMsgNotify,{hide=0})
end
function onBtnBgSet()
GameEntry.UI:OpenUIForm(UIFormId.UI_BgSet)
end
function onBtnMarry()
onBtnHideUI()
end
function onBtnFavorability()
local e=PlayerMgr.mainShowHeroList[t]
local t=HeroMgr:GetHeroDataByHeroDId(e.heroDid)
local e=N.GetEntity(e.heroDid)
if t.loverGrade<Constant.harem_unlock_item then
local t=GameTools.GetLocalize(e.heroName,LanguageCategory.LangBattle)
local a=GameTools.GetLocalize("gradename"..Constant.harem_unlock_item,LanguageCategory.LangCommon)
UIUtil.ShowMessageBox(
{
onOkBtnClick=function()
if GameFunction.IsFunctionUnLock(GameFunctionType.temp10029,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_FavorabilityHero,{heroDid=e.id})
end
end,
text=GameTools.GetLocalize("UI.Harem.GoodwillFeatures.22",LanguageCategory.LangCommon,t,a),
buttons=MessageBoxButtons.OKCancel,
okBtnContent=GameTools.GetLocalize("UI.Homepage.Tips.02",LanguageCategory.LangCommon)
}
)
else
playFavorabilityAction("playItemVoice")
ModulesInit.FavorabilityManage:CheckFuncHandBook()
end
end
function onBtnWatch()
local e=PlayerMgr.mainShowHeroList[t]
local t=HeroMgr:GetHeroDataByHeroDId(e.heroDid)
local e=N.GetEntity(e.heroDid)
if t.loverGrade<Constant.harem_unlock_item then
else
playWatchAction()
ModulesInit.FavorabilityManage:CheckFuncHandBook()
end
end
function onBtnAddGold()
GameEntry.UI:OpenUIForm(UIFormId.UI_GoldChange)
end
function onBtnAddHoly()
ActMgr:CheckJumpViewById(301)
end
function onBtnShop()
if GameFunction.IsFunctionUnLock(GameFunctionType.shop,true)then
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_MAINSHOP_SUC"})
GameEntry.UI:OpenUIForm(UIFormId.UI_ShopMain,{type=PROTO_ENUM.ENUM_SHOP_TYPE.SHOP_NORMAL})
end
end
function onBtnMail()
local e=ModulesInit.MailManager:SendMailListRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Mail)
end
LuaUtils.AdjustLogEvent("bukt33")
end
function onBtnFriend()
GameEntry.UI:OpenUIForm(UIFormId.UI_GoodFriend)
end
function onBtnRank()
if GameFunction.IsFunctionUnLock(GameFunctionType.Rank,true)then
local e=ModulesInit.RankListManager:SendFightRankTopRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_FightRank)
end
end
end
function onBtnFunHandBook()
if GameFunction.IsFunctionUnLock(GameFunctionType.FunHandBook,true)then
ModulesInit.FunctionHandBookMgr:RequestInfo(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_FunctionHandBook_Root)
end)
end
end
function onBtnTale()
if GameTools:IsReview()then
ModulesInit.StoryManager.PlayStory(3501100)
else
if GameFunction.IsFunctionUnLock(GameFunctionType.Tale)then
local e=ModulesInit.TaleManager:SendQueryStoryWordsLagRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Tale)
end
end
end
end
function onBtnLeft()
if#PlayerMgr.mainShowHeroList<=1 then
return
end
changeBg(1)
end
function onBtnRight()
if#PlayerMgr.mainShowHeroList<=1 then
return
end
changeBg(-1)
end
function onBtnSpine()
local e=PlayerMgr.mainShowHeroList[t]
if c==u.IDLE or c==u.INTERACTION then
playInteractionAction()
end
end
function OnQuestBtnClick()
if GameFunction.IsFunctionUnLock(GameFunctionType.Quest,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_QuestMain)
end
end
function OnShowBgDownload()
EventSystem.SendEvent(CommonEventId.OnShowBgDownload)
end
function OnClickTaskNoticeBtn()
local e=ModulesInit.TaskNoticeMgr:IsFunctionOpen()
if e then
if ModulesInit.TaskNoticeMgr.curTaskID_Status==ModulesInit.TaskNoticeMgr.TaskStatus.Opening then
GameEntry.UI:OpenUIForm(UIFormId.UI_TaskNoticePopView)
elseif ModulesInit.TaskNoticeMgr.curTaskID_Status==ModulesInit.TaskNoticeMgr.TaskStatus.CanReward then
ModulesInit.TaskNoticeMgr:ReqTaskGetReward(ModulesInit.TaskNoticeMgr.curTaskID)
else
UIUtil.ShowCommonTips("任务状态异常!")
end
end
end
function onBtnAdventure()
if CheckAdventure()then
JumpMgr.OnGameJumpUIAdventure()
end
end
function CheckAdventure(e)
if not GameFunction.IsFunctionUnLock(GameFunctionType.Trial)
and not GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)
and not GameFunction.IsFunctionUnLock(GameFunctionType.Maze)then
if not e then
GameFunction.IsFunctionUnLock(GameFunctionType.Trial,true)
end
return false
end
return true
end
function onBtnJinji()
if CheckJingji()then
JumpMgr.OnGameJumpUIJingjiRoot()
end
end
function CheckJingji()
if not GameFunction.IsFunctionUnLock(GameFunctionType.Arena)
and not GameFunction.IsFunctionUnLock(GameFunctionType.CrossArena)
and not GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
and not GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
and not GameFunction.IsFunctionUnLock(GameFunctionType.WarOfAttrition)
and(not GameFunction.IsFunctionUnLock(GameFunctionType.Guild)or PlayerMgr.PlayerInfo.guildId<=0)then
GameFunction.IsFunctionUnLock(GameFunctionType.Arena,true)
return false
end
return true
end
function onBtnLimit()
local e,t=ModulesInit.MainPageLimitMgr:checkCanShowLimitPage()
if e~=nil then
ModulesInit.MainPageLimitMgr:LimitClickHandler(t)
end
end
function onBtnActJump()
local e=ModulesInit.MainPageLimitMgr:GetCanMainActivityJump()
if e then
ActMgr:JumpViewById(e.activityId)
end
end
function OnClickNewMarketNotice(a)
n=true
LuaUtils.SetActive(showBannerDescNode.transform,n)
LuaUtils.SetActive(bg_dibu.transform,n)
CheckOnOpenBannerHideAutoHelper()
for t=1,#e do
if e[t].actId==a then
s=t
end
end
if n then
ScrollViewActBanner:RefreshAllShownItem()
ScrollViewActBanner:MovePanelToItemIndex(s-1)
LuaUtils.SetActive(img_actBannerJiantouXia.transform,false)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,false)
if#e>3 then
if UIUtil.isScrollViewStart(ScrollViewActBanner)==true then
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
elseif UIUtil.isScrollViewEnd(ScrollViewActBanner)==true then
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
else
LuaUtils.SetActive(img_actBannerJiantouXia.transform,true)
LuaUtils.SetActive(img_actBannerJiantouShang.transform,true)
end
end
end
end
function onBtnWorld()
JumpMgr.OnGameJumpUIIdle()
end
function onBtnCamp()
JumpMgr.OnGameJumpUICamp({})
end
function onBtnBag()
JumpMgr.OnGameJumpUIBag()
end
function onBtnShouhu()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuardMain)
end
function onBtnHufu()
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_MAINHUFU_SUC"})
AmuletMgr:EnterAmuletView()
end
function onBtnGuild()
JumpMgr.OnGameJumpUIGuild()
end
function onBtnCity()
JumpMgr.OnGameJumpUICityRoot()
end
function onBtnSummonPet()
SummonPetMgr:EnterSummonPetView()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function StopToggleSequence()
if S~=nil then
S:Kill()
S=nil
end
end
function onClickDownAutoHelper(e)
end
function onClickUpAutoHelper(e)
if B then
return
end
if GameFunction.IsFunctionUnLock(GameFunctionType.AutoHelper,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_AutoHelper_Main)
end
end
function OnBeginDragAutoHelper(e)
L=CS.UnityEngine.Input.mousePosition
B=false
end
function onDragingAutoHelper(e)
local t=CS.UnityEngine.Input.mousePosition
local a=t.x-L.x
local o=t.y-L.y
local e=autoHelper_Root.transform.localPosition
e.x=e.x+a
e.y=e.y+o
autoHelper_Root.transform.localPosition=e
SetAutoHelperRedPos(autoHelper_Root.transform.localPosition)
L=t
B=true
end
function OnEndDragAutoHelper(e)
B=false
if CS.UnityEngine.Input.touchCount>1 then
return
end
SetAutoHelperRootLimitPos()
end
function StartRandomAnim()
sp_autoHelperIcon:PlayAnimation(0,"idle",false,function()
local e=math.random(1,100)
if e<30 then
sp_autoHelperIcon:PlayAnimation(0,"in",false,function()
StartRandomAnim()
end)
else
StartRandomAnim()
end
end)
end
function RefereshAutoHelperView()
LuaUtils.SetActive(autoHelper_Root.transform,GameFunction.IsFunctionUnLock(GameFunctionType.AutoHelper))
if GameFunction.IsFunctionUnLock(GameFunctionType.AutoHelper)then
StartRandomAnim()
LuaUtils.SetLocalPos(autoHelper_Root.transform,
SaveMgr.GetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootX,ModulesInit.AutoHelperOtherMgr.DefalutRootX),
SaveMgr.GetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootY,ModulesInit.AutoHelperOtherMgr.DefalutRootY),
0)
LuaUtils.SetActive(autoHelperRedDot.transform,ModulesInit.AutoHelperOtherMgr:GetAutoHelperRed())
SetAutoHelperRootLimitPos()
end
end
function SetAutoHelperRedPos(a)
local e=autoHelper_Root.transform.sizeDelta
local o=CS.UnityEngine.Screen.width/2-e.x*0.8
local i=CS.UnityEngine.Screen.height/2-e.y*0.8
local t=0
local e=0
if a.y>=i then
e=-48
elseif a.y<-i then
e=57
else
e=-48
end
if a.x>=o then
t=-61
elseif a.x<-o then
t=52.5
else
t=52.5
end
LuaUtils.SetLocalPos(autoHelperRedDot.transform,t,e,0)
end
function StopSequence()
if _ then
for e=1,#_ do
_[e]:Kill()
_[e]=nil
end
end
_={}
end
function OnDelayDoCallBack(a,t)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(a)
e:AppendCallback(function()
if t then
t()
end
end)
table.add(_,e)
end
function CheckOnOpenBannerHideAutoHelper()
if n==true then
LuaUtils.SetActive(autoHelper_Root.transform,false)
else
RefereshAutoHelperView()
end
end
function SetAutoHelperRootLimitPos()
local e=autoHelper_Root.transform.localPosition
local t=autoHelper_Root.transform.sizeDelta
local t=CS.UnityEngine.Screen.width*GameEntry.Instance.StandardHeight/CS.UnityEngine.Screen.height
if(t<GameEntry.Instance.MinWidth)then
t=GameEntry.Instance.MinWidth
elseif(t>GameEntry.Instance.MaxWidth)then
t=GameEntry.Instance.MaxWidth
end
local t=t
local a=ScreenDesignHeight
if e.y<(-a/2)then
e.y=(-a/2)
elseif e.y>(a/2)then
e.y=(a/2)
end
if e.x<-t/2 then
e.x=(-t/2)
elseif e.x>(t/2)then
e.x=(t/2)
end
autoHelper_Root.transform.localPosition=e
local t=math.floor(autoHelper_Root.transform.localPosition.x*100+0.5)/100
local e=math.floor(autoHelper_Root.transform.localPosition.y*100+0.5)/100
SaveMgr.SetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootX,t)
SaveMgr.SetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootY,e)
SetAutoHelperRedPos(autoHelper_Root.transform.localPosition)
end
function InitFoolsDollSpineBtnShow()
if not ActMgr:IsOpen(ModulesInit.ActFoolsDollMgr.actId)then
return
end
if ModulesInit.ActFoolsDollMgr.curDay<=0 then
ModulesInit.ActFoolsDollMgr:ReqActFoolsDollInfo()
return
end
RefreshFoolsDollSpineBtnShowByData()
end
function NewDayReqDollMsg()
if not ActMgr:IsOpen(ModulesInit.ActFoolsDollMgr.actId)then
RemoveFoolsDollSpineBtn()
return
end
ModulesInit.ActFoolsDollMgr:ReqActFoolsDollInfo()
RefreshFoolsDollSpineBtnShowByData()
end
function OnActFoolsDollRefreshInfo()
RefreshFoolsDollSpineBtnShowByData()
end
function RefreshFoolsDollSpineBtnShowByData()
ModulesInit.ActFoolsDollMgr:RefreshFoolsDollSpineBtnShowByData(k,self.UIFormId,foolsDollNoed,function(e)
k=e
end)
end
function RemoveFoolsDollSpineBtn()
if k~=nil then
k:Close()
GameEntry.Pool:GameObjectDespawn(k.transform)
k=nil
end
end
function SetFestival()
local t=LoginUtilsGetTConstant("atmosphere.isopen")
local e=false
if t then
e=tonumber(t)==1
end
LuaUtils.SetActive(festival_bottom.transform,e)
LuaUtils.SetActive(festival_liaotian.transform,e)
end
function RefreshTemporaryBuffBtnShow()
local e=PlayerMgr:GetPlayerLimitBuffList()
local t=e and(#e>0)
if t then
local e=e[1]
local e=me.GetEntity(e.buffDid)
LuaUtils.SetImageSprite(im_temporary_buff_Icon,"UIBuffIcon/buff_"..tostring(e.heroBuffId),false)
LuaUtils.SetImageSprite(im_temporary_buff_bg,"UIMainInterface/bgyx_buffsmalldi_"..tostring(e.heroBuffId),false)
end
LuaUtils.SetActive(btn_temporary_buff.transform,t)
end
function OnBtnOpenTemporaryBuffView()
GameEntry.UI:OpenUIForm(UIFormId.UI_ActGroupPhoto_Gold_Buff)
end
function OnSynPlayerLimitBuffList()
if f==false then
RefreshTemporaryBuffBtnShow()
end
end
function OnTestLive2dById(e)
local t=e[0]
local a=e[1]
local o=e[2]
local e=e[3]
GameEntry.UI:OpenUIForm(UIFormId.UI_MarryLive2dMainView,
{heroDid=t,isHaveMarry=a,isSpecialTest=o,isTestKrAnim=e
})
end 
