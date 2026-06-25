local e=require('DataNode/DataTable/Create/item/DTItemDBModel')
local x=require("DataNode/DataTable/Create/item/DTDropDBModel")
local n={
Normal=1,
Rare=2,
}
local q=false
local t={}
local a={}
local s={}
local o=n.Normal
local f=0;
local j=0;
local v=0;
local k=0;
local u=PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_UNACTIVE;
local b=0
local g=0
local y=0
local d=0
local p=false
local w=0
local c=0
local m=0
local r=0
local h=0
local l=false
local i=0
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildGiftView)
end)
toggle1.onClick:AddListener(function(e)
ChangePage(n.Normal)
end)
toggle2.onClick:AddListener(function(e)
ChangePage(n.Rare)
end)
btn_box.onClick:AddListener(function()
if u==PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_ACTIVE then
ModulesInit.GuildMgr:ReqGuildGiftBox()
else
local t=ModulesInit.GuildMgr:getGuildTreasureData(f)
if t then
local i={}
local e=0
local o={}
local t=t.awards
for t,a in ipairs(t)do
local t=a[1]
local n=a[2]
local a=x.GetEntity(t)
if a then
local t=a.dropItem
for a,t in ipairs(t)do
table.insert(i,{itemDid=t[1],count=t[2]})
end
e=e+1
else
table.insert(o,{itemDid=t,count=n})
end
end
local e={
titleName1=GameTools.GetLocalize("guild_box_accuracy_get_title",LanguageCategory.LangCommon),
itemArr1=o,
titleName2=GameTools.GetLocalize("guild_box_probably_get_title",LanguageCategory.LangCommon,e),
itemArr2=i,
worldPos=btn_box.transform.position,
offset=0,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Vertical_Down},
}
GameEntry.UI:OpenUIForm(UIFormId.UI_GameBoxInfo2View,e)
end
end
end)
btn_wenhao_treasure_box.onClick:AddListener(function()
local e={
worldPos=btn_wenhao_treasure_box.transform.position,
hintDes=GameTools.GetLocalize("giftDesc_bigbox",LanguageCategory.LangCommon),
offset=20,
priorPageArr={EHintPageDir.Down},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end)
btn_delete.onClick:AddListener(function()
if#t<=0 and#a<=0 then
UIUtil.ShowCommonTipsForLocalize('tips.common_55')
return
end
UIUtil.ShowMessageBox({
onOkBtnClick=function()
ModulesInit.GuildMgr:ReqGuildGiftDelete()
end,
text=GameTools.GetLocalize("UI.guild.Gift.26",LanguageCategory.LangCommon),
buttons=MessageBoxButtons.OKCancel,
})
end)
btn_yijianlingqu.onClick:AddListener(function()
if#t>0 then
ModulesInit.GuildMgr:ReqGuildNormalGiftAward()
end
end)
btn_wenhao.onClick:AddListener(function()
local e={
worldPos=btn_wenhao.transform.position,
hintDes=GameTools.GetLocalize("UI.Help.Guild.Gift.Desc",LanguageCategory.LangCommon),
offset=10,
priorPageArr={EHintPageDir.Down},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end)
o=n.Normal
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=420
ScrollView:InitListView(0,e,OnGetItemByIndex)
LuaUtils.SetLabelText(text_message_empty,GameTools.GetLocalize("UI.guild.Gift.25",LanguageCategory.LangCommon))
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnGuildRespGiftList,OnGuildRespGiftList)
EventSystem.AddListener(CommonEventId.OnGuildRespGiftAward,OnGuildRespGiftAward)
EventSystem.AddListener(CommonEventId.OnGuildRespAllNormalGiftAward,OnGuildRespAllNormalGiftAward)
EventSystem.AddListener(CommonEventId.OnGuildRespGiftBox,OnGuildRespGiftBox)
EventSystem.AddListener(CommonEventId.OnGuildRespGiftDelete,OnGuildRespGiftDelete)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.OnGuildRespTreasureTimeOut,OnGuildRespTreasureTimeOut)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnEventFlyFinish,OnEventFlyFinish)
q=false
t={}
a={}
s={}
o=n.Normal
f=0;
j=0;
v=0;
k=0;
u=PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_UNACTIVE;
b=0
g=0
y=0
d=0
p=false
w=0
c=0
m=0
r=0
h=0
l=false
i=0
o=n.Normal
LuaUtils.SetActive(text_box_left_time.transform,false)
DoChangePage(o)
RefreshRedPoint()
ReqGuildGiftListAll()
LuaUtils.SetActive(char_review.transform,false)
end
function OnFormBack(e)
if e==UIFormId.UI_GameBoxInfo2View then
ReqGuildGiftListAll()
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnGuildRespGiftList,OnGuildRespGiftList)
EventSystem.RemoveListener(CommonEventId.OnGuildRespGiftAward,OnGuildRespGiftAward)
EventSystem.RemoveListener(CommonEventId.OnGuildRespAllNormalGiftAward,OnGuildRespAllNormalGiftAward)
EventSystem.RemoveListener(CommonEventId.OnGuildRespGiftBox,OnGuildRespGiftBox)
EventSystem.RemoveListener(CommonEventId.OnGuildRespGiftDelete,OnGuildRespGiftDelete)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.OnGuildRespTreasureTimeOut,OnGuildRespTreasureTimeOut)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnEventFlyFinish,OnEventFlyFinish)
end
function OnBeforeDestroy()
end
function OnUpdate()
UpdateMovingItem()
UpdateGiftLeftTime()
UpdateReqGiftList()
UpdateReqAllGiftList()
end
function UpdateMovingItem()
if ScrollView.IsDraging then
l=false
end
if l==true then
local e=10
if mIsMovingOffset>0 then
e=math.min(e,mIsMovingOffset)
UIUtil.moveScrollViewByOffset(ScrollView,true,e)
mIsMovingOffset=mIsMovingOffset-e
if mIsMovingOffset<=0 then
l=false
mIsMovingOffset=0
end
elseif mIsMovingOffset<0 then
e=math.min(e,mIsMovingOffset)
UIUtil.moveScrollViewByOffset(ScrollView,false,e)
mIsMovingOffset=mIsMovingOffset+e
if mIsMovingOffset>=0 then
l=false
mIsMovingOffset=0
end
else
l=false
mIsMovingOffset=0
end
end
end
function UpdateGiftLeftTime()
y=y+Time.deltaTime
if y<1 then
return
end
y=0
if u==PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_ACTIVE then
LuaUtils.SetActive(text_box_left_time.transform,true)
else
LuaUtils.SetActive(text_box_left_time.transform,false)
end
local e=b-TimeUtil.GetServerTimeStamp()
e=math.max(0,e)
LuaUtils.SetTextMeshText(text_box_left_time,GameTools.GetLocalize("UI.guild.Gift.11",LanguageCategory.LangCommon,TimeUtil.toDHMSStr2(e)))
local e=UIUtil.GetGridViewAllItem(ScrollView)
for e,t in pairs(e)do
local e=t.UserObjectData
local e=s[e]
if e and e.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_ACTIVE then
local e=math.max(0,e.expiredTimeStamp/1000-TimeUtil.GetServerTimeStamp())
local t=LuaUtils.GetLuaComBinder(t.transform)
local t=t:GetComponents()
if e>0 then
LuaUtils.SetTextMeshText(t["text_left_time"],GameTools.GetLocalize("UI.guild.Gift.11",LanguageCategory.LangCommon,TimeUtil.toDHMSStr2(e)))
else
LuaUtils.SetTextMeshText(t["text_left_time"],GameTools.GetLocalize("UI.guild.Gift.09",LanguageCategory.LangCommon))
end
end
end
end
function UpdateReqGiftList()
d=d+Time.deltaTime
if d<5 then
return
end
d=0
if u==PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_ACTIVE
and b<TimeUtil.GetServerTimeStamp()then
ModulesInit.GuildMgr:ReqGuildTreasureTimeOut()
end
CheckReqGiftList()
end
function UpdateReqAllGiftList()
if p==false then
return
end
w=w+Time.deltaTime
if w<5 then
return
end
p=false
w=0
ReqGuildGiftListAll()
end
function Refresh(e)
if e~=false then
ScrollView:SetListItemCount(#s)
ScrollView:RefreshAllShownItem()
LuaUtils.SetActive(gift_empty.transform,#s<=0 and GameTools:IsReview()==false)
end
LuaUtils.SetActive(bg_ditu_1.transform,false)
LuaUtils.SetActive(bg_ditu_2.transform,false)
if o==n.Normal then
LuaUtils.SetActive(bg_ditu_1.transform,true)
else
LuaUtils.SetActive(bg_ditu_2.transform,true)
end
local e=ModulesInit.GuildMgr:getGuildTreasureDataExp(f)
local a=j
if ModulesInit.GuildMgr:isGuildTreasureMaxLevel(treasureDid)then
LuaUtils.SetImageFillAmount(im_jindutiao_exp,1)
LuaUtils.SetTextMeshText(text_lv_exp,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,f))
LuaUtils.SetTextMeshText(text_num_exp,GameTools.GetLocalize("UI.guild.Gift.21",LanguageCategory.LangCommon))
else
if e~=0 then
LuaUtils.SetImageFillAmount(im_jindutiao_exp,a/e)
else
LuaUtils.SetImageFillAmount(im_jindutiao_exp,0)
end
LuaUtils.SetTextMeshText(text_lv_exp,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,f))
LuaUtils.SetTextMeshText(text_num_exp,GameTools.GetLocalize("UI.guild.Main.04",LanguageCategory.LangCommon,a,e))
end
if u==PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_UNACTIVE then
LuaUtils.SetTextMeshText(text_message_box,GameTools.GetLocalize("UI.guild.Gift.22",LanguageCategory.LangCommon))
UIUtil.SpinePlayAnimation(gonghuidabaoxiang.transform,0,"A",true)
elseif u==PROTO_ENUM.ENUM_TREASURE_STATUS.TREASURE_STATUS_ACTIVE then
LuaUtils.SetTextMeshText(text_message_box,GameTools.GetLocalize("UI.guild.Gift.23",LanguageCategory.LangCommon))
UIUtil.SpinePlayAnimation(gonghuidabaoxiang.transform,0,"B",true)
end
local e=ModulesInit.GuildMgr:getGuildTreasureNeedKey(k)
LuaUtils.SetImageFillAmount(im_jindutiao_key,v/e)
LuaUtils.SetTextMeshText(text_num_key,GameTools.GetLocalize("UI.guild.Main.04",LanguageCategory.LangCommon,v,e))
UIUtil.SetGray(btn_yijianlingqu.transform,#t<=0)
RefreshRedPoint()
end
function RefreshRedPoint()
UIUtil.RefreshRedPoint2(rd_box,g)
LuaUtils.SetActive(rd_gift_1.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_NORMAL))
LuaUtils.SetActive(rd_gift_2.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_ADVANCE))
end
function GetGiftList()
if o==n.Normal then
return t
elseif o==n.Rare then
return a
end
end
function OnGetItemByIndex(e,r)
r=r+1

local a
if o==n.Rare then
a=e:NewListViewItem("item1")
else
a=e:NewListViewItem("item2")
end
local e=LuaUtils.GetLuaComBinder(a.transform)
local e=e:GetComponents()
local t=s[r]
local d=ModulesInit.GuildMgr:getGuildGiftData(t.giftDid)
local h=GetAwardData(t,d)
LuaUtils.SetTextMeshText(e["text_num"],"")
LuaUtils.SetActive(e["itemCell76"].transform,false)
LuaUtils.SetActive(e["im_prop"].transform,false)
if h then
local t=0
if h[3]then
if h[2]>0 then
t=h[2]
elseif h[2]<0 then
end
end
LuaUtils.SetActive(e["itemCell76"].transform,true)
UIUtil.SetItemCell(e["itemCell76"].transform,{itemDid=h[1],count=t})
else
LuaUtils.SetActive(e["im_prop"].transform,true)
GameTools:SetImageSprite(e["im_prop"],UIUtil.GuildGiftCfgGetItemIconPath(d.giftIcon1),false)
end
LuaUtils.SetLabelText(e["text_tiaojian1"],GameTools.GetLocalize(tostring(d.giftTitle),LanguageCategory.LangCommon))
LuaUtils.SetActive(e["text_left_time"].transform,false)
LuaUtils.SetActive(e["node_daoju"].transform,false)
LuaUtils.SetActive(e["btn_lingqu"].transform,false)
LuaUtils.SetActive(e["text_yilingqu"].transform,false)
if t.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_ACTIVE then
LuaUtils.SetActive(e["text_left_time"].transform,true)
LuaUtils.SetActive(e["btn_lingqu"].transform,true)
local t=math.max(0,t.expiredTimeStamp/1000-TimeUtil.GetServerTimeStamp())
if t>0 then
LuaUtils.SetTextMeshText(e["text_left_time"],GameTools.GetLocalize("UI.guild.Gift.11",LanguageCategory.LangCommon,TimeUtil.toDHMSStr2(t)))
else
LuaUtils.SetTextMeshText(e["text_left_time"],GameTools.GetLocalize("UI.guild.Gift.09",LanguageCategory.LangCommon))
end
elseif t.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_EXPIRED then
LuaUtils.SetActive(e["text_left_time"].transform,true)
LuaUtils.SetTextMeshText(e["text_left_time"],GameTools.GetLocalize("UI.guild.Gift.09",LanguageCategory.LangCommon))
elseif t.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_AWARDED then
LuaUtils.SetActive(e["text_yilingqu"].transform,true)
LuaUtils.SetActive(e["node_daoju"].transform,true)
end
LuaUtils.SetLabelText(e["text_item_num1"],GameTools.GetLocalize("UI.guild.Gift.20",LanguageCategory.LangCommon,d.treasureKey[2]))
LuaUtils.SetLabelText(e["text_item_num2"],GameTools.GetLocalize("UI.guild.Gift.20",LanguageCategory.LangCommon,d.treasureExp[2]))
LuaUtils.SetActive(e["CanvasMarque"].transform,o==n.Rare)
local n=""
local o=ModulesInit.GuildMgr:getGuildGiftInfoData(t.chargeId,t.activityId)
local o=o and o.deskey
if o and o~=""then
if t.closeShowName then
local e=GameTools.GetLocalize("tips.common_109",LanguageCategory.LangCommon)
n=GameTools.GetLocalize(tostring(o),LanguageCategory.LangCommon,e)
else
n=GameTools.GetLocalize(tostring(o),LanguageCategory.LangCommon,t.triggerName)
end
else
n=""
end
UIUtil.SetMarqueeWithDesc(e["mask_marquee"].transform,e["text_tiaojian2"],100,n,false,false,true)
if a.IsInitHandlerCalled==false then
a.IsInitHandlerCalled=true
e["btn_lingqu"].onClick:AddListener(handler(a,function(e)
if l==false then
local e=e.UserObjectData
local t=s[e]
ModulesInit.GuildMgr:ReqGuildGiftAward({giftId=t.giftId})
i=e
end
end))
e["btn_icon_item"].onClick:AddListener(handler(a,function(t)
if l==false then
local t=t.UserObjectData
local a=s[t]
local t=ModulesInit.GuildMgr:getGuildGiftData(a.giftDid)
local a=GetAwardData(a,t)
if a then
local e={
thingDid=a[1],
worldPos=e["btn_icon_item"].transform.position,
offset=30,
priorPageArr={EHintPageDir.Left},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowItemTip(e)
else
local a={}
local o=t.treasureKey
table.insert(a,{itemDid=o[1],count=o[2]})
local o=t.treasureExp
table.insert(a,{itemDid=o[1],count=o[2]})
local o={}
local i=1
local t=t.awards
for t,e in ipairs(t)do
local t=e[1]
local e=e[2]
table.insert(o,{itemDid=t,count=e})
end
local e={
titleName1=GameTools.GetLocalize("guild_box_accuracy_get_title",LanguageCategory.LangCommon),
itemArr1=a,
titleName2=GameTools.GetLocalize("guild_box_probably_get_title",LanguageCategory.LangCommon,i),
itemArr2=o,
worldPos=e["btn_icon_item"].transform.position,
offset=0,
priorPageArr={EHintPageDir.Right},
priorArrowArr={EHintArrowAlign.Horizontal_Left},
}
GameEntry.UI:OpenUIForm(UIFormId.UI_GameBoxInfo2View,e)
end
end
end))
end
a.UserObjectData=r
return a
end
function GetAwardData(e,t)
local t=nil
if e.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_AWARDED then
t={
e.awardItemDid,e.awardItemCount,100
}
else
end
return t
end
function ChangePage(e)
if o==e then
return
end
DoChangePage(e)
end
function DoChangePage(e)
o=e
ChangeToggleShow(o)
end
function ChangeToggleShow(e)
LuaUtils.SetActive(toggle1.transform:Find('im_on'),e==1)
LuaUtils.SetActive(toggle1.transform:Find('im_off'),e~=1)
LuaUtils.SetActive(toggle2.transform:Find('im_on'),e==2)
LuaUtils.SetActive(toggle2.transform:Find('im_off'),e~=2)
ShowViewByType(e,true)
end
function ShowViewByType(i,e)
o=i
if o==n.Normal then
s=t
LuaUtils.SetActive(btn_yijianlingqu.transform,true)
else
s=a
LuaUtils.SetActive(btn_yijianlingqu.transform,false)
end
if e==true then
SortGiftList(s)
ScrollView:MovePanelToItemIndex(0)
end
Refresh()
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildGiftView)
end
function OnGuildRespGiftList(e)
SynRespGiftList(e,e.isNew)
SynRespBaseInfo(e.teasure)
if q==false then
q=true
for e=1,#a do
if a[e].giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_ACTIVE then
o=n.Rare
break
end
end
CheckChooseList()
DoChangePage(o)
else
if e.isNew then
local t=ScrollView.ContainerTrans
local a=UIUtil.getScrollViewContainerOffset(ScrollView)
if#e.giftsNormal>0 and o==n.Normal then
Refresh()
UIUtil.setScrollViewContainerOffset(ScrollView,Vector2(t.anchoredPosition.x,a.y+#e.giftsNormal*100))
if i~=0 then
i=i+#e.giftsNormal
end
elseif#e.giftsAdvance>0 and o==n.Rare then
Refresh()
UIUtil.setScrollViewContainerOffset(ScrollView,Vector2(t.anchoredPosition.x,a.y+#e.giftsAdvance*100))
if i~=0 then
i=i+#e.giftsAdvance
end
else
Refresh(false)
end
handleGiftListError(e)
else
Refresh()
end
end
end
function handleGiftListError(e)
if(e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_NORMAL or e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL)
and r==0
and RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_NORMAL)then

p=true
elseif(e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ADVANCE or e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL)
and h==0
and RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_ADVANCE)then

p=true
end
end
function OnGuildRespGiftAward(e)
SynRespBaseInfo(e.teasure)
local n=ModulesInit.GuildMgr:getGuildGiftData(e.gift.giftDid)
local o=0
if n.type==1 then
if t[i]and t[i].giftId==e.gift.giftId then
t[i]=e.gift
ReduceCommonAwardCount()
o=i
else
for a=1,#t do
if t[a].giftId==e.gift.giftId then
t[a]=e.gift
ReduceCommonAwardCount()
o=a
break
end
end
end
t=SortGiftList(t)or{}
for a=1,#t do
if t[a].giftId==e.gift.giftId then
for e=1,#t do
if e>a then
break
end
t[a+1-e]=t[a-e]
end
t[1]=e.gift
end
end
r=calculateAwardCount(t)
else
if a[i]and a[i].giftId==e.gift.giftId then
a[i]=e.gift
ReduceRareAwardCount()
o=i
else
for t=1,#a do
if a[t].giftId==e.gift.giftId then
a[t]=e.gift
ReduceRareAwardCount()
o=t
break
end
end
end
a=SortGiftList(a)or{}
for t=1,#a do
if a[t].giftId==e.gift.giftId then
for e=1,#a do
if e>t then
break
end
a[t+1-e]=a[t-e]
end
a[1]=e.gift
end
end
h=calculateAwardCount(a)
end
i=0
Refresh()
showFlyAction(e,n,o)
end
function OnGuildRespAllNormalGiftAward(e)
SynRespBaseInfo(e.teasure)
SynRespNormalGiftList(e,false)
i=0
CheckChooseList()
Refresh()
end
function showFlyAction(s,n,e)
local e=ScrollView:GetShownItemByItemIndex(e-1)
local a
local t
local i
if e then
local o=LuaUtils.GetLuaComBinder(e.transform)
local o=o:GetComponents()
local e=e.transform.position
a=o["im_prop"].transform.position
t=o["text_item_num1"].transform.position
i=o["text_item_num2"].transform.position
else
a=ScrollView.transform.position
t=ScrollView.transform.position
i=ScrollView.transform.position
end
local e={}
local o=ModulesInit.BagManager:GetBaseInfo(s.gift.awardItemDid)
local a={
itemType=EItemFlyType.Image,
imagePath=o.icon,
startWorldPos=a,
endPosType=EItemFlyTargetType.Bag,
scale=0.8,
}
table.insert(e,a)
local a=ModulesInit.BagManager:GetBaseInfo(n.treasureKey[1],true)
local t={
itemType=EItemFlyType.Image,
imagePath=a.icon,
startWorldPos=t,
endWorldPos=im_tubiao_key.transform.position,
scale=0.6,
flyFlag="guild_gift_key",
}
table.insert(e,t)
local t=ModulesInit.BagManager:GetBaseInfo(n.treasureExp[1],true)
local t={
itemType=EItemFlyType.Image,
imagePath=t.icon,
startWorldPos=i,
endWorldPos=text_lv_exp.transform.position,
scale=0.6,
flyFlag="guild_gift_box_exp",
}
table.insert(e,t)
UIUtil.ShowCommonItemFly(e)
end
function ReduceCommonAwardCount()
r=math.max(0,r-1)
CheckReqNormalGiftList(0)
end
function ReduceRareAwardCount()
h=math.max(0,h-1)
CheckReqRareGiftList(0)
end
function CheckReqGiftList()
local a=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_NORMAL)
local t=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_ADVANCE)
if a==false and t==false then
return
end
local e=5
if r<=e and h<=e then
local e={reqType=PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL,
isNew=true,
topNorGiftId=c,
topAdvGiftId=m
}
ModulesInit.GuildMgr:ReqGuildGiftList(e)
d=0
else
if r<=e and a then
CheckReqNormalGiftList(e)
elseif h<=e and t then
CheckReqRareGiftList(e)
end
end
end
function CheckReqNormalGiftList(e)
if r<=e then
ModulesInit.GuildMgr:ReqGuildGiftList({reqType=PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_NORMAL,isNew=true,topNorGiftId=c},false)
d=0
end
end
function CheckReqRareGiftList(e)
if h<=e then
ModulesInit.GuildMgr:ReqGuildGiftList({reqType=PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ADVANCE,isNew=true,topAdvGiftId=m},false)
d=0
end
end
function OnGuildRespGiftBox(e)
SynRespBaseInfo(e.teasure)
Refresh(false)
UIUtil.SpinePlayAnimation(gonghuidabaoxiang.transform,0,"C",false,function()
Refresh(false)
end)
end
function OnGuildRespGiftDelete(e)
SynRespNormalGiftList(e,false)
SynRespRareGiftList(e,false)
CheckChooseList()
Refresh()
end
function CheckChooseList()
if o==n.Normal then
s=t
else
s=a
end
end
function SynRespGiftList(e,t)
if e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_NORMAL
or e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL then
SynRespNormalGiftList(e,t)
end
if e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ADVANCE
or e.reqType==PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL then
SynRespRareGiftList(e,t)
end
CheckChooseList()
if t then
if#e.giftsNormal>0 or#e.giftsAdvance>0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Gift.24",LanguageCategory.LangCommon))
end
end
end
function SynRespNormalGiftList(e,o)
if o and#e.giftsNormal<=0 then
return
end
local a=SortGiftListById(e.giftsNormal)
local a=a[1]and a[1].giftId or 0
local i=c
c=math.max(a,c)
if o then
if#e.giftsNormal>0 then
local a=SortGiftList(e.giftsNormal)
for e=1,#a do
if a[e].giftId>i then
table.insert(t,1,a[e])
end
end
r=r+calculateAwardCount(e.giftsNormal)
end
else
t=SortGiftList(e.giftsNormal)or{}
r=calculateAwardCount(e.giftsNormal)
end
end
function SynRespRareGiftList(e,o)
if o and#e.giftsAdvance<=0 then
return
end
local t=SortGiftListById(e.giftsAdvance)
local t=t[1]and t[1].giftId or 0
local i=m
m=math.max(t,m)
if o then
if#e.giftsAdvance>0 then
local t=SortGiftList(e.giftsAdvance)
for e=1,#t do
if t[e].giftId>i then
table.insert(a,1,t[e])
end
end
h=h+calculateAwardCount(e.giftsAdvance)
end
else
a=SortGiftList(e.giftsAdvance)or{}
h=calculateAwardCount(e.giftsAdvance)
end
end
function SynRespBaseInfo(e)
f=e.treasureLevel;
j=e.treasureExp;
v=e.giftCurKeyCount;
k=e.giftCurLevel;
u=e.treasureStatus;
g=e.availableCount;
b=e.treasureFinishTime
end
function SortGiftListById(e)
table.sort(e,function(e,t)
return e.giftId>t.giftId
end)
return e
end
function SortGiftList(a)
table.sort(a,function(e,t)
if e.giftStatus~=t.giftStatus then
return e.giftStatus<t.giftStatus
end
if e.giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_ACTIVE then
if e.expiredTimeStamp~=t.expiredTimeStamp then
return e.expiredTimeStamp<t.expiredTimeStamp
end
end
return e.giftId>t.giftId
end)
return a
end
function calculateAwardCount(t)
local e=0
for a=1,#t do
if t[a].giftStatus==PROTO_ENUM.ENUM_GIFT_STATUS.GIFT_STATUS_ACTIVE then
e=e+1
end
end
return e
end
function OnEventRespError(e)
if e.protoCode==ProtoId.PRT_GUILD_GIFT_AWARD_REQ then
local e=e.errorCode
ReqGuildGiftListAll()
end
end
function OnGuildRespTreasureTimeOut(e)
SynRespBaseInfo(e.teasure)
Refresh(false)
end
function OnEventNetReconnectSuccess(e)
ReqGuildGiftListAll()
end
function OnEventFlyFinish(e)
local e=e.flyFlag
if e=="guild_gift_key"then
local e=node_key.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"guild_exp_breath",0,0)
elseif e=="guild_gift_box_exp"then
local e=root_exp.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"guild_exp_breath",0,0)
end
end
function ReqGuildGiftListAll()
ModulesInit.GuildMgr:ReqGuildGiftList({reqType=PROTO_ENUM.ENUM_GIFT_TYPE.GIFT_TYPE_ALL,isNew=false,topNorGiftId=0,topAdvGiftId=0})
d=0
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

