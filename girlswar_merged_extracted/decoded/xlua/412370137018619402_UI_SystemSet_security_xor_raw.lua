local o=require('DataNode/DataTable/Create/player/DTLevelUpDBModel')
local t=nil
local e=0
function OnInit(a,a)
Image.onClick:AddListener(closeUI)
inputIntroduce.onValueChanged:AddListener(function(e)
if e then
local e,t=string.truncateChar(e,Constant.player_intro_limit)
if t>Constant.player_intro_limit then
inputIntroduce.text=e
end
end
end)
inputIntroduce.onEndEdit:AddListener(function(e)
if e then
if inputIntroduce.text==nil or inputIntroduce.text==""or string.trim(inputIntroduce.text)==""then
inputIntroduce.text=""
return
end
inputIntroduce.text=string.trim(inputIntroduce.text)
local e=PlayerMgr:sendSign(inputIntroduce.text)
e.onCompleted=function()
end
end
end)
btn_yueka.onClick:AddListener(onBtnMonthCard)
bg_vip.onClick:AddListener(onBtnVip)
btn_shezhi.onClick:AddListener(onBtnSet)
btn_changename.onClick:AddListener(onBtnChangeName)
btn_nor_set.onClick:AddListener(onNormalSet)
btn_game_desc.onClick:AddListener(onGameDesc)
btn_music.onClick:AddListener(onMusicSet)
btn_accChange.onClick:AddListener(onAccChange)
btn_notice.onClick:AddListener(btnNotice)
btn_mail.onClick:AddListener(btnMail)
bg_guanzhi.onClick:AddListener(OnGuanzhi)
btn_delete.onClick:AddListener(OnDeletePlayer)
btn_line.onClick:AddListener(OnClickLineBtn)
LuaUtils.SetActive(btn_shezhi.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_nor_set.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_music.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_accChange.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_mail.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_notice.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_game_desc.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_twitter.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_discord.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_delete.transform,GameEntry.IsReview)
btn_twitter.onClick:AddListener(function()
LuaUtils.OpenUrl(Constant.twitter_url)
end)
btn_discord.onClick:AddListener(function()
LuaUtils.OpenUrl(Constant.discord_url)
end)
if GameEntry.IsCommittee then
LuaUtils.SetActive(bg_vip.transform,false)
end
if GameTools:IsReview()then
LuaUtils.SetActive(btn_residence.transform,false)
end
btn_residence.onClick:AddListener(function()
if GameEntry.UI:IsExists(UIFormId.UI_MarryResidence)then
GameTools.CloseUIForm(UIFormId.UI_MarryResidence)
end
if GameFunction.IsFunctionUnLock(GameFunctionType.MyHone,true)then
local e=ModulesInit.MarryManager:SendMarryHeramInfoResquest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_MarryResidence)
end
end
end)
btn_title.onClick:AddListener(function()
if BuildPatchMgr:CompareVersion(GameEntry.AppVer,"1.0.24")<0 then
return
end
local a=os.time()
if t==nil or a-t>3 then
e=1
t=a
return
else
e=e+1
end
if e>=3 then
local a=not CS.YouYou.MacroDefine.DEBUG_MODEL
if a then
CS.YouYou.MacroDefine.DEBUG_LOG_ERROR=true
CS.YouYou.MacroDefine.DEBUG_LOG_NORMAL=true
CS.YouYou.MacroDefine.DEBUG_LOG_RESOURCE=true
CS.YouYou.MacroDefine.DEBUG_LOG_PROTO=true
CS.YouYou.MacroDefine.DEBUG_LOG_BATTLE=true
CS.YouYou.MacroDefine.DEBUG_LOG_PROCEDURE=true
else
CS.YouYou.MacroDefine.DEBUG_LOG_ERROR=false
CS.YouYou.MacroDefine.DEBUG_LOG_NORMAL=false
CS.YouYou.MacroDefine.DEBUG_LOG_RESOURCE=false
CS.YouYou.MacroDefine.DEBUG_LOG_PROTO=false
CS.YouYou.MacroDefine.DEBUG_LOG_BATTLE=false
CS.YouYou.MacroDefine.DEBUG_LOG_PROCEDURE=false
end
GameEntry.SetDebugMode(a)
CS.YouYou.MacroDefine.DEBUG_MODEL=a
e=0
t=nil
end
end)
btn_resetAutoHelperPos.onClick:AddListener(function()
SaveMgr.SetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootX,ModulesInit.AutoHelperOtherMgr.DefalutRootX)
SaveMgr.SetFloatForKey(ModulesInit.AutoHelperOtherMgr.const_autoHelper_RootY,ModulesInit.AutoHelperOtherMgr.DefalutRootY)
EventSystem.SendEvent(CommonEventId.OnAutoHelperRedRefresh)
UIUtil.ShowCommonTips(GameTools.GetLocalize("HelperUI134",LanguageCategory.LangCommon))
end)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnPlayerChangeName,onPlayerChangeName)
EventSystem.AddListener(CommonEventId.OnPlayInfoChange,onPlayInfoChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnOfficerStatusSync,OnOfficerStatusSync)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
RefreshView()
CheckFunctionUnlock()
RefreshRedPoint()
end
function CheckFunctionUnlock()
if GameEntry.IsReview==false then
LuaUtils.SetActive(btn_residence.transform,GameFunction.IsFunctionUnLock(GameFunctionType.MyHone))
end
end
function RefreshView()
UIUtil.SetPlayerIconFrame(head_yuan150,{head=PlayerMgr.PlayerInfo.head,headFrame=PlayerMgr.PlayerInfo.headFrame})
GameTools:SetImageSprite(im_vip_num,UIUtil.GetVipNumPath(PlayerMgr.PlayerInfo.vip))
LuaUtils.SetLabelText(text_name,GameTools.GetLocalize("UI.Setting.Main.02",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.name))
if PlayerMgr.PlayerInfo.guildId<=0 then
local e=GameTools.GetLocalize("UI.Arena.Rank.02",LanguageCategory.LangCommon)
LuaUtils.SetLabelText(text_guild_name,GameTools.GetLocalize("UI.Setting.Main.04",LanguageCategory.LangCommon,e))
else
LuaUtils.SetLabelText(text_guild_name,GameTools.GetLocalize("UI.Setting.Main.04",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.guildName))
end
local e=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_MAIN)
LuaUtils.SetLabelText(text_zhanli,GameTools.GetLocalize("UI.Setting.Main.05",LanguageCategory.LangCommon,UIUtil.toBigNum(e)))
local e=o.GetEntity(PlayerMgr.PlayerInfo.level)
local a=ModulesInit.BagManager:GetItemCountById(PROTO_ENUM.ENUM_CURRENCY.EXP)
if e==nil then
e=o.GetEntity(PlayerMgr.PlayerInfo.level)
end
local t=GameTools.GetLocalize("UI.Setting.Main.06",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.level)
local e=GameTools.GetLocalize("UI.Setting.Main.07",LanguageCategory.LangCommon,UIUtil.toBigNum(a),UIUtil.toBigNum(e.exp))
LuaUtils.SetLabelText(text_lv_exp,t.."  "..e)
LuaUtils.SetLabelText(text_id,GameTools.GetLocalize("UI.Setting.Main.08",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.uid))
local e=GameServerInfo:getServerInfoById(UserAccountInfo.serverId)
LuaUtils.SetLabelText(text_qufu,GameTools.GetLocalize("UI.Setting.Main.09",LanguageCategory.LangCommon,e.name))
inputIntroduce.text=PlayerMgr.PlayerInfo.sign or""
local e=false
UIUtil.SetGray(btn_yueka.transform,not e)
LuaUtils.SetActive(bg_guanzhi.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
PlayerMgr.PlayerInfo.officer and PlayerMgr.PlayerInfo.officer>0 then
LuaUtils.SetActive(bg_guanzhi.transform,true)
local e=bg_guanzhi.transform:GetComponent(typeof(CS.YouYou.YouYouImage))
GameTools:SetImageSprite(e,UIUtil.GetOfficerCapPath(PlayerMgr.PlayerInfo.officer))
UIUtil.SpinePlayAnimation(spine_guanzhi2,0,UIUtil.GetOfficerNumPath(PlayerMgr.PlayerInfo.officer),true)
LuaUtils.SetTextMeshText(officer_show_num,ModulesInit.OfficerMgr:getOfficeSmallLevelShow(PlayerMgr.PlayerInfo.officer))
end
LuaUtils.SetActive(im_redpoint_name.transform,ChangeNameStatus())
LuaUtils.SetActive(guanzhiRedImgNode.transform,false)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.OFFICER_UPGRADE)then
LuaUtils.SetActive(guanzhiRedImgNode.transform,true)
end
LuaUtils.SetActive(btn_line.transform,GameFunction.IsFunctionUnLock(GameFunctionType.LineJump))
end
function ChangeNameStatus()
local e=false
local t=string.match(PlayerMgr.PlayerInfo.name,"성주+%d")
if t and PlayerMgr.PlayerInfo.changeNameCount<=0 then
e=true
end
return e
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnPlayerChangeName,onPlayerChangeName)
EventSystem.RemoveListener(CommonEventId.OnPlayInfoChange,onPlayInfoChange)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnOfficerStatusSync,OnOfficerStatusSync)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
end
function OnEventNetReconnectSuccess()
RefreshView()
end
function OnBeforeDestroy()
end
function OnOfficerStatusSync()
LuaUtils.SetActive(bg_guanzhi.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
PlayerMgr.PlayerInfo.officer and PlayerMgr.PlayerInfo.officer>0 then
LuaUtils.SetActive(bg_guanzhi.transform,true)
local e=bg_guanzhi.transform:GetComponent(typeof(CS.YouYou.YouYouImage))
GameTools:SetImageSprite(e,UIUtil.GetOfficerCapPath(PlayerMgr.PlayerInfo.officer))
UIUtil.SpinePlayAnimation(spine_guanzhi2,0,UIUtil.GetOfficerNumPath(PlayerMgr.PlayerInfo.officer),true)
LuaUtils.SetTextMeshText(officer_show_num,ModulesInit.OfficerMgr:getOfficeSmallLevelShow(PlayerMgr.PlayerInfo.officer))
end
end
function RefreshRedPoint()
LuaUtils.SetActive(im_redpoint_line.transform,RedPointMgr.GetLineRedStatus())
LuaUtils.SetActive(im_line_gift.transform,RedPointMgr:GetLineGiftStatus())
LuaUtils.SetActive(guanzhiRedImgNode.transform,false)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.OFFICER_UPGRADE)then
LuaUtils.SetActive(guanzhiRedImgNode.transform,true)
end
LuaUtils.SetChildActive(btn_residence.transform,'RedDot',RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_HAREM_POWER))
LuaUtils.SetActive(btn_resetAutoHelperPos.transform,GameFunction.IsFunctionUnLock(GameFunctionType.AutoHelper))
end
function closeUI()
ViewMgr:OnWillClose(self.UIFormId)
GameTools.CloseUIForm(UIFormId.UI_SystemSet)
end
function onBtnMonthCard()
closeUI()
JumpMgr.OnGameJumpUICamp()
end
function onBtnVip()
GameEntry.UI:OpenUIForm(UIFormId.UI_VIPMaim)
end
function onBtnSet()
GameEntry.UI:OpenUIForm(UIFormId.UI_HeadSet)
end
function onBtnChangeName()
local e=GameTools.GetLocalize("UI.Setting.Profile.21",LanguageCategory.LangCommon,Constant.player_rename_cost[2])
if PlayerMgr.PlayerInfo.changeNameCount<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_PlayerChangeName)
else
UIUtil.ShowMessageBox({
onOkBtnClick=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_PlayerChangeName)
end,
text=e,
buttons=MessageBoxButtons.OKCancel,
}
)
end
end
function onPlayerChangeName()
LuaUtils.SetLabelText(text_name,GameTools.GetLocalize("UI.Setting.Main.02",LanguageCategory.LangCommon,PlayerMgr.PlayerInfo.name))
LuaUtils.SetActive(im_redpoint_name.transform,ChangeNameStatus())
end
function onPlayInfoChange()
UIUtil.SetPlayerIconFrame(head_yuan150,{head=PlayerMgr.PlayerInfo.head,headFrame=PlayerMgr.PlayerInfo.headFrame})
end
function onNormalSet()
GameEntry.UI:OpenUIForm(UIFormId.UI_NormalSet)
end
function onGameDesc()
GameEntry.UI:OpenUIForm(UIFormId.UI_GameExplain)
end
function onCdkChange()
GameEntry.UI:OpenUIForm(UIFormId.UI_CDKExchange)
end
function onMusicSet()
GameEntry.UI:OpenUIForm(UIFormId.UI_VoiceSet)
end
function onAccChange()
if BuildPatchMgr:CanSDKLogin()then
GameEntry.UI:OpenUIForm(UIFormId.UI_ChangeAccSetSelect)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_ChangeAccExplain)
end
end
function btnNotice()
GetNoticeData(function(e)
GameEntry.UI:OpenUIForm(UIFormId.UI_Notice,{noticeData=e})
end,UIUtil.ShowMessageBox)
end
function btnMail()
GameEntry.UI:OpenUIForm(UIFormId.UI_SupportMail)
end
function btnGameSet()
GameEntry.UI:OpenUIForm(UIFormId.UI_GameSettings)
end
function OnGuanzhi()
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
PlayerMgr.PlayerInfo.officer and PlayerMgr.PlayerInfo.officer>0 and not GameTools:IsReview()then
GameEntry.UI:OpenUIForm(UIFormId.UI_OfficerMainView)
end
end
function OnDeletePlayer()
GameEntry.UI:OpenUIForm(UIFormId.UI_ChangeAccSetSelect)
end
function OnClickLineBtn()
if PlayerMgr.PlayerInfo.vip<Constant.line_vipLimit then
UIUtil.ShowCommonTipsForLocalize("lineCsTips_1",LanguageCategory.LangCommon,Constant.line_vipLimit)
return
end
local e=SaveMgr.GetBoolForKey("main_sys_player_line_show",false)
if not e then
UIUtil.forceShowUI(UIFormId.UI_Line_Show)
SaveMgr.SetBoolForKey("main_sys_player_line_show",true)
EventSystem.SendEvent(CommonEventId.RedPointInfoChange)
else
if RedPointMgr:GetLineGiftStatus()then
UIUtil.forceShowUI(UIFormId.UI_Line_Show)
else
LuaUtils.OpenUrl(Constant.line_url)
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

