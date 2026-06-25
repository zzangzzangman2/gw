local e=require("DataNode/DataTable/Create/constant/DTServerListDBModel")
local d=require("Modules/CSGuildWar/PlayerListView")
local o={
DEFAULT=0,
MATCHING=2,
PREPARE=3,
BATTLING=5,
PUBLICITY=1
}
local e=276
local l={}
local h=false
local i=nil
local n=nil
local s=nil
local t=nil
local r=false
local e=ModulesInit.CSGuildWarManager
local a=ModulesInit.GuildMgr
local a=e:GetGuildWarDBCfg()
function OnInit(t,t)
l={
[o.DEFAULT]=OnDefaultStage,
[o.MATCHING]=OnMatchingStage,
[o.PREPARE]=OnPrepareStage,
[4]=OnPrepareStage,
[o.PUBLICITY]=OnPublictyStage,
[o.BATTLING]=OnBattlingStage
}
btn_fanhui.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarMain)
end
)
btn_shop.onClick:AddListener(
function()
end
)
btn_reward.onClick:AddListener(
function()
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarAwards)
else
local e=e:SendPlayerQuestAwardRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarAwards)
end
end
end
)
btn_rank.onClick:AddListener(
function()
local e=e:SendGuildWarRankInfoRequest(e.GuildWarStatusInfo.battleGroundId)
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarRank)
end
end
)
guild_review_btn.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarGuildStatusReview)
end
)
btn_chest.onClick:AddListener(
function()
local t=e:SendGuildWarNoFitstBoxInfoRequest()
t.onCompleted=function()
UpdateBoxStatu()
if#e.GuildWarStatusInfo.myBoxes>0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarBoxRewardGet)
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarRewardsReview)
end
end
)
btn_reward_preview.onClick:AddListener(
function()
if e:SelfIsCanJoin()then
if e:GuildFirstTimeJoinAwardIsGeted()then
ShowFirstJoinRewardReview(true)
else
local e=e:SendGuildWarGetBoxRequest()
e.onCompleted=function()
UpdateFirstJoinBoxStatu()
end
end
return
end
ShowFirstJoinRewardReview()
end
)
btn_enter.onClick:AddListener(
function()
if e:GuildIsBye()then
UIUtil.ShowCommonTipsForLocalize('UI.guildBattle.battlefield.08')
return
end
GameTools:PlayAudioLua(308)
spine_enter:PlayAnimation(
0,
"C",
false,
function()
if not h then
LuaUtils.SetActive(black,true)
local t=ModulesInit.TimeActionMgr:CreateTimeAction()
t:Init(0.5,1,1,nil,nil,function()
e:EnterWarProcedure()
end):Run()
h=true
end
end
)
end
)
btn_buff.onClick:AddListener(
function()
local e=e:SendGuildWarBuffRecordRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarBuff)
end
end
)
btn_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Tournament",isOpen=e.GuildWarStatusInfo.warType==PROTO_ENUM.ENUM_GUILD_WAR_TYPE.WAR_CS_SERVER})
end
)
btn_shop.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ShopMain,{type=PROTO_ENUM.ENUM_SHOP_TYPE.SHOP_GUILD})
end
)
end
function OnOpen(t)
h=false
LuaUtils.SetActive(black,false)
local e=e:GetGuildWarStage()
if e==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN then
i=o.DEFAULT
elseif e==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.PREPARE or e==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.COLLECTION then
i=o.PREPARE
else
i=e
end
UpdateState()
GameTools:SwitchBGMFadeOutLua(112)
EventSystem.AddListener(SysEventId.OnClick,OnClickCallBack)
EventSystem.AddListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.AddListener(CommonEventId.GuildWarBuffSync,OnGuildWarBuffSync)
EventSystem.AddListener(CommonEventId.GuildWarGetBoxAwardSucess,OnGuildWarGetBoxAwardSucess)
EventSystem.AddListener(CommonEventId.GuildWarGetTaskAwardSuccess,OnGuildWarGetTaskAwardSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,OnRedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
ModulesInit.PhotoArtistMgr:checkIDShowUI(ModulesInit.PhotoArtistMgr.FirstUI.TournamentHelpId)
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
end
function UpdateState()
UpdateRewardStatu()
UpdateBoxStatu()
UpdateFirstJoinBoxStatu()
SwitchState()
UpdateBuffAdd()
if e.GuildWarStatusInfo.startTime<=0 then
GameEntry.LogError("和战时间有问题了")
return
end
local t=TimeUtil.timeStampToDateWithAreaTimeZone(e.GuildWarStatusInfo.startTime)
local e=TimeUtil.timeStampToDateWithAreaTimeZone(e.GuildWarStatusInfo.endTime)
local i=GameTools.GetLocalize(WEEK_DAY_LOCALIZATION[t.week])
local o=GameTools.GetLocalize(WEEK_DAY_LOCALIZATION[t.week])
local a=string.format("%d:00",t.hour)
if t.minute==0 then
a=string.format("%d:00",t.hour)
elseif t.minute<10 then
a=string.format("%d:0%d",t.hour,t.minute)
else
a=string.format("%d:%d",t.hour,t.minute)
end
local t
if e.minute==0 then
t=string.format("%d:00",e.hour)
elseif e.minute<10 then
t=string.format("%d:0%d",e.hour,e.minute)
else
t=string.format("%d:%d",e.hour,e.minute)
end
LuaUtils.SetLabelTextWrap(text_time,i,a,o,t)
end
function UpdateBoxStatu()
local o=#e.GuildWarStatusInfo.myBoxes
local t=a.boxPoint
local a=e.GuildWarStatusInfo.curScore+o*t
LuaUtils.SetLabelTextWrap(text_box_pro,a,t)
LuaUtils.SetImageFillAmount(im_charge,a/t)
if e.GuildWarStatusInfo.curMyScore==0 then
LuaUtils.SetLabelTextWrap(text_score," <color=#F96157>0")
else
LuaUtils.SetLabelTextWrap(
text_score,
string.format(" <color=#4ACB57>%s%%",UIUtil.GetPreciseDecimal(e.GuildWarStatusInfo.curMyScore/e.GuildWarStatusInfo.curScore*100,1))
)
end
if o>0 then
LuaUtils.SetChildActive(btn_chest.transform,"im_redpoint",true)
LuaUtils.SetChildLabelText(btn_chest.transform,"im_redpoint/Text",tostring(o))
spine_box:PlayAnimation(0,'A',true)
else
LuaUtils.SetChildActive(btn_chest.transform,"im_redpoint",false)
spine_box:PlayAnimation(0,'B',false)
end
end
function UpdateFirstJoinBoxStatu()
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
LuaUtils.SetActive(btn_reward_preview.transform,false)
return
end
if e:SelfIsCanJoin()then
if e:GuildFirstTimeJoinAwardIsGeted()then
LuaUtils.SetActive(btn_reward_preview.transform,false)
else
LuaUtils.SetActive(btn_reward_preview.transform,true)
end
else
LuaUtils.SetActive(btn_reward_preview.transform,false)
end
end
function UpdateRewardStatu()
LuaUtils.SetChildActive(btn_reward.transform,'im_redpoint',RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CS_GUILD_WAR_QUEST))
end
function ShowFirstJoinRewardReview(n)
local t=LuaUtils.GetLuaComBinder(tips_reward)
local t=t:GetComponents()
local o=t["rewardiips_grid"]
LuaUtils.SetActive(tips_reward,true)
LuaUtils.SetChildrenActive(o,false)
local i=a.firstAward
for e=1,#i do
local t=i[e]
local e=UIUtil.GetChild(o,e-1)
if not e then
e=LuaUtils.Instantiate(itemCell90)
LuaUtils.SetParent(e,o)
LuaUtils.SetLocalScale(e,1,1,1)
end
LuaUtils.SetActive(e,true)
UIUtil.SetItemCell(e,{itemDid=t[1],count=t[2]})
end
if not n then
if not e:GuildIsCanJoin()then
UIUtil.SetTextMeshTextForLocalize(t["text_tiaojian"],"UI.guildBattle.main.17")
else
if PlayerMgr.PlayerInfo.level<a.lv then
UIUtil.SetTextMeshTextForLocalize(t["text_tiaojian"],"UI.guildBattle.main.18",LanguageCategory.LangCommon,a.level)
else
LuaUtils.SetTextMeshText(t["text_tiaojian"],"")
end
end
else
LuaUtils.SetTextMeshText(t["text_tiaojian"],"수령 완료")
end
end
function CloseFirstJoinRewardReview()
LuaUtils.SetActive(tips_reward,false)
end
function SwitchState()
LuaUtils.SetActive(node_flag_violet,false)
LuaUtils.SetActive(node_flag_red,false)
LuaUtils.SetActive(node_mid,false)
LuaUtils.SetActive(node_player_list,false)
LuaUtils.SetActive(boxRoot,false)
LuaUtils.SetActive(tip_2,false)
LuaUtils.SetActive(stageTimeRoot,false)
LuaUtils.SetActive(guildBye,false)
UpdateTime()
local t=e:GuildIsCanJoin()
if not t then
LuaUtils.SetActive(node_player_list,true)
LuaUtils.SetActive(stageTimeRoot,true)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.01")
SetBlueGuildInfo()
InitPlayerListView()
SetPlayerListInfo()
return
end
CheckWatching()
l[i]()
end
function OnDefaultStage()
LuaUtils.SetActive(stageTimeRoot,true)
LuaUtils.SetActive(btn_enter.transform,false)
LuaUtils.SetActive(node_player_list,true)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.01")
SetBlueGuildInfo()
InitPlayerListView()
SetPlayerListInfo()
end
function OnMatchingStage()
LuaUtils.SetActive(stageTimeRoot,true)
LuaUtils.SetActive(btn_enter.transform,false)
LuaUtils.SetActive(node_player_list,false)
LuaUtils.SetActive(node_flag_red,true)
LuaUtils.SetActive(node_mid,true)
LuaUtils.SetActive(tip_4,false)
LuaUtils.SetActive(tip_5,false)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.17")
local t=e:SendGuildWarBattleGroundInfoRequest(e.GuildWarStatusInfo.battleGroundId)
t.onCompleted=function()
local e=e.CurReqBattleGroundInfo
SetBlueGuildInfo()
SetBattleInfoView(e,true)
end
SetRedGuildInfo(nil,false)
end
function OnPrepareStage()
LuaUtils.SetActive(btn_enter.transform,false)
LuaUtils.SetActive(node_flag_red,true)
LuaUtils.SetActive(node_mid,true)
spine_enter:PlayAnimation(0,"A",false)
LuaUtils.SetActive(tip_4,false)
LuaUtils.SetActive(tip_5,false)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.23")
local t=e:SendGuildWarBattleGroundInfoRequest(e.GuildWarStatusInfo.battleGroundId)
t.onCompleted=function()
local e=e.CurReqBattleGroundInfo
local t=e.battleGroundId==-1
SetBlueGuildInfo()
SetRedGuildInfo(e.targetGuildInfo,t)
if t then
LuaUtils.SetActive(btn_enter.transform,false)
LuaUtils.SetActive(guildBye,true)
else
LuaUtils.SetActive(btn_enter.transform,true)
LuaUtils.SetActive(stageTimeRoot,true)
end
SetBattleInfoView(e,false)
end
end
function OnPublictyStage()
LuaUtils.SetActive(btn_enter.transform,true)
LuaUtils.SetActive(node_player_list,false)
LuaUtils.SetActive(node_flag_red,true)
LuaUtils.SetActive(node_mid,true)
spine_enter:PlayAnimation(0,"A",false)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.01")
local t=e:SendGuildWarBattleGroundInfoRequest(e.GuildWarStatusInfo.battleGroundId)
t.onCompleted=function()
local e=e.CurReqBattleGroundInfo
local t=e.battleGroundId==-1
if t then
LuaUtils.SetActive(guildBye,true)
else
LuaUtils.SetActive(stageTimeRoot,true)
end
SetBlueGuildInfo()
SetRedGuildInfo(e.targetGuildInfo,t)
SetBattleInfoView(e,false)
SetBattleResultInfo(e,t)
end
end
function OnBattlingStage()
LuaUtils.SetActive(btn_enter.transform,true)
LuaUtils.SetActive(node_player_list,false)
LuaUtils.SetActive(node_flag_red,true)
LuaUtils.SetActive(node_mid,true)
spine_enter:PlayAnimation(0,"B",true)
LuaUtils.SetActive(tip_4,false)
LuaUtils.SetActive(tip_5,true)
LuaUtils.SetActive(tip_3,not e:GuildIsCanJoin())
UIUtil.SetLabelTextForLocalize(text_title2,"UI.guildBattle.main2.24")
local t=e:SendGuildWarBattleGroundInfoRequest(e.GuildWarStatusInfo.battleGroundId)
t.onCompleted=function()
local e=e.CurReqBattleGroundInfo
local t=e.battleGroundId==-1
if t then
LuaUtils.SetActive(guildBye,true)
else
LuaUtils.SetActive(stageTimeRoot,true)
end
SetBlueGuildInfo()
SetRedGuildInfo(e.targetGuildInfo,t)
SetBattleInfoView(e,false)
end
end
function UpdateTime()
if n then
n:Stop()
n=nil
end
local e=e:GetGuildWarCountDown()
n=ModulesInit.TimeActionMgr:CreateTimeAction()
n:Init(
0,
1,
e,
nil,
function(e)
LuaUtils.SetLabelText(text_time2,TimeUtil.toDHMSStr2(e))
end,
nil
):Run()
end
function InitPlayerListView()
if not r then
local t=LuaUtils.GetLuaComBinder(node_player_list)
s=t:GetComponents()
s["toggle1"].onValueChanged:AddListener(
function(t)
if t then
local t=e:SendGuildActivePlayerRequest(false)
t.onCompleted=function()
OnGuildActivePlayer(e.CurReqActivePlauerInfo)
end
end
end
)
s["toggle2"].onValueChanged:AddListener(
function(t)
if t then
local t=e:SendGuildActivePlayerRequest(true)
t.onCompleted=function()
OnGuildActivePlayer(e.CurReqActivePlauerInfo)
end
end
end
)
d:Init(s["UI_scrollview_cont"],6)
r=true
end
end
function SetBattleInfoView(i,n)
local o=i.ownerGuildInfo
LuaUtils.SetTextMeshText(txt_left_attack_count,tostring(math.max(0,a.attackTime-i.attCount)).."/"..(a.attackTime))
local a=LuaUtils.GetLuaComBinder(node_mid)
t=a:GetComponents()
LuaUtils.SetChildLabelTextMeshText(t["item_1"],"txt_1",UIUtil.toBigNum(o.fightValue))
LuaUtils.SetChildLabelTextMeshText(t["item_2"],"txt_1",string.format("%d/%d",o.memJoinCount,o.memMaxCount))
LuaUtils.SetChildLabelTextMeshText(t["item_3"],"txt_1",string.format("<u>%s</u>",o.leaderName))
LuaUtils.SetChildLabelTextMeshText(t["item_4"],"txt_1",o.leftDefCount)
LuaUtils.GetUIEventListener(t["item_3"]:Find('txt_1')).onClick=function()
UIUtil.showPlayerInfo(o.leaderPlayerId,o.serverId)
end
local a=LuaUtils.GetUIEventListener(t["item_3"]:Find('txt_3'))
if n then
SetBattleScoreSliderBar(0,0)
LuaUtils.SetChildLabelTextMeshText(t["item_1"],"txt_3","?")
LuaUtils.SetChildLabelTextMeshText(t["item_2"],"txt_3","?")
LuaUtils.SetChildLabelTextMeshText(t["item_3"],"txt_3","?")
LuaUtils.SetChildLabelTextMeshText(t["item_4"],"txt_3","?")
a.onClick=nil
else
local s=e:GuildIsCanJoin()
local e=i.targetGuildInfo
local n=0
if e then
n=e.grade
end
SetBattleScoreSliderBar(o.grade,n)
local o=i.battleGroundId==-1
if not o and s and e then
LuaUtils.SetChildLabelTextMeshText(t["item_1"],"txt_3",UIUtil.toBigNum(e.fightValue))
LuaUtils.SetChildLabelTextMeshText(t["item_2"],"txt_3",string.format("%d/%d",e.memJoinCount,e.memMaxCount))
LuaUtils.SetChildLabelTextMeshText(t["item_3"],"txt_3",string.format("<u>%s</u>",e.leaderName))
LuaUtils.SetChildLabelTextMeshText(t["item_4"],"txt_3",e.leftDefCount)
a.onClick=function()
UIUtil.showPlayerInfo(e.leaderPlayerId,e.serverId)
end
else
LuaUtils.SetChildLabelTextMeshText(t["item_1"],"txt_3","")
LuaUtils.SetChildLabelTextMeshText(t["item_2"],"txt_3","")
LuaUtils.SetChildLabelTextMeshText(t["item_3"],"txt_3","")
LuaUtils.SetChildLabelTextMeshText(t["item_4"],"txt_3","")
a.onClick=nil
end
end
end
function SetBattleScoreSliderBar(e,a)
LuaUtils.SetTextMeshText(t["txt_power_1"],e)
LuaUtils.SetTextMeshText(t["txt_power_2"],a)
if e==0 and a==0 then
LuaUtils.SetImageFillAmount(t["slider_bar"],0.5)
else
local a=e+a
local a=e/a
local e=a
LuaUtils.SetImageFillAmount(t["slider_bar"],e)
local o=-(711/2)
local a=o+711*a
LuaUtils.SetRectTransformPos(t["slider_move"],a,0,0)
if e==0 or e==1 then
LuaUtils.SetActive(t["slider_move"].transform,false)
else
LuaUtils.SetActive(t["slider_move"].transform,true)
end
end
end
function SetBlueGuildInfo()
LuaUtils.SetLabelTextWrap(txt_sever1,PlayerMgr.serverId)
LuaUtils.SetTextMeshText(txt_sever_name1,ModulesInit.GuildMgr.guildInfo.name)
GameTools:SetImageSprite(im_icon1,ModulesInit.GuildMgr:getGuildFg(ModulesInit.GuildMgr.guildInfo.fg))
end
function SetRedGuildInfo(e,t)
if not e then
LuaUtils.SetActive(txt_sever2.transform,false)
LuaUtils.SetActive(txt_sever_name2.transform,false)
LuaUtils.SetActive(im_icon.transform,false)
if not t then
LuaUtils.SetActive(im_no,true)
LuaUtils.SetActive(text_bye,false)
LuaUtils.SetActive(red_flag2,false)
else
LuaUtils.SetActive(im_no,false)
LuaUtils.SetActive(text_bye,true)
LuaUtils.SetActive(red_flag2,true)
end
LuaUtils.SetActive(txt_left_attack_count.transform,false)
else
LuaUtils.SetActive(txt_sever2.transform,true)
LuaUtils.SetActive(txt_sever_name2.transform,true)
LuaUtils.SetActive(im_icon.transform,true)
LuaUtils.SetActive(im_no,false)
LuaUtils.SetActive(text_bye,false)
LuaUtils.SetActive(red_flag2,false)
LuaUtils.SetLabelTextWrap(txt_sever2,e.serverId)
LuaUtils.SetTextMeshText(txt_sever_name2,e.name)
GameTools:SetImageSprite(im_icon,ModulesInit.GuildMgr:getGuildFg(e.fg))
LuaUtils.SetActive(txt_left_attack_count.transform,i==o.BATTLING or i==o.PREPARE)
end
end
function SetPlayerListInfo()
LuaUtils.SetToggleValue(s["toggle2"],true)
LuaUtils.SetActive(s["txt_tips_R"],not e:GuildIsCanJoin())
LuaUtils.SetActive(s["txt_tips_L"],not e:GuildIsCanJoinForNextSeason())
end
function SetBattleResultInfo(e,t)
LuaUtils.SetActive(tip_5,false)
if t then
LuaUtils.SetActive(tip_4,false)
else
LuaUtils.SetActive(tip_4,true)
local t=e.ownerGuildInfo
local e=e.targetGuildInfo
if e then
if t.grade>e.grade then
LuaUtils.SetChildActive(tip_4,"win",true)
LuaUtils.SetChildActive(tip_4,"fail",false)
LuaUtils.SetChildActive(tip_4,"no",false)
elseif t.grade<e.grade then
LuaUtils.SetChildActive(tip_4,"win",false)
LuaUtils.SetChildActive(tip_4,"fail",true)
LuaUtils.SetChildActive(tip_4,"no",false)
else
LuaUtils.SetChildActive(tip_4,"win",false)
LuaUtils.SetChildActive(tip_4,"fail",false)
LuaUtils.SetChildActive(tip_4,"no",true)
end
else
LuaUtils.SetChildActive(tip_4,"win",false)
LuaUtils.SetChildActive(tip_4,"fail",false)
LuaUtils.SetChildActive(tip_4,"no",false)
end
end
end
function CheckWatching()
local e=e:SelfIsCanJoin()
if not e then
LuaUtils.SetActive(tip_2,true)
if PlayerMgr.PlayerInfo.level<a.lv then
LuaUtils.SetChildActive(tip_2,"txt_1",true)
LuaUtils.SetChildActive(tip_2,"txt_2",false)
else
LuaUtils.SetChildActive(tip_2,"txt_1",false)
LuaUtils.SetChildActive(tip_2,"txt_2",true)
end
else
LuaUtils.SetActive(boxRoot,true)
LuaUtils.SetActive(tip_2,false)
end
end
function UpdateBuffAdd()
local t=a.inspireAtkAdd*e.GuildWarStatusInfo.guildInspireCount
local e=a.inspireHpAdd*e.GuildWarStatusInfo.guildInspireCount
LuaUtils.SetLabelTextWrap(text_buff1,string.format('%d%%',t))
LuaUtils.SetLabelTextWrap(text_buff2,string.format('%d%%',e))
end
function OnGuildActivePlayer(e)
d:Show(e)
end
function OnGuildWarStageSync()
i=e:GetGuildWarStage()
UpdateState()
end
function OnGuildWarBuffSync()
UpdateBuffAdd()
end
function OnGuildWarGetBoxAwardSucess()
UpdateBoxStatu()
end
function OnGuildWarGetTaskAwardSuccess()
UpdateRewardStatu()
end
function OnRedPointInfoChange()
UpdateRewardStatu()
end
function OnClickCallBack()
if LuaUtils.GetActive(tips_reward)then
CloseFirstJoinRewardReview()
end
end
function OnEventNetReconnectSuccess()
h=false
LuaUtils.SetActive(black,false)
UpdateState()
end
function OnClose()
if n then
n:Stop()
n=nil
end
EventSystem.RemoveListener(SysEventId.OnClick,OnClickCallBack)
EventSystem.RemoveListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.RemoveListener(CommonEventId.GuildWarBuffSync,OnGuildWarBuffSync)
EventSystem.RemoveListener(CommonEventId.GuildWarGetBoxAwardSucess,OnGuildWarGetBoxAwardSucess)
EventSystem.RemoveListener(CommonEventId.GuildWarGetTaskAwardSuccess,OnGuildWarGetTaskAwardSuccess)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,OnRedPointInfoChange)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnFormBack()
UpdateState()
end
function OnBeforeDestroy()
end
local t=nil
function TriggleStep()
if t==nil then
t=e:GetGuildWarStage()
end
UpdateState()
t=t+1
if t>5 then
t=1
end
i=t
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

