local e=ModulesInit.GuildTrialsMgr
local u=4
local o={
idle=1,
openAnim=2,
openDone=3,
awarded=4,
}
local p=0
local v=0
local w=0
local y=0
local a={}
local t=nil
local i={}
local n={}
local h=0
local m=false
local l=false
local c=nil
local f=true
local r=0
local d=0
local s=0
function OnInit(e,e)
Image.onClick:AddListener(function()
LuaUtils.SetActive(ScrollViewBox.transform,false)
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_DrillBox_View,true)
end)
ScrollViewAct:InitListView(0,OnGetItemByIndex)
ScrollViewBox:InitListView(0,OnGetItemBoxByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsMapBox,OnRespGuildTrialsMapBox)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsSingleMapBox,OnRespGuildTrialsSingleMapBox)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsMapBoxAward,OnRespGuildTrialsMapBoxAward)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
n={}
p=e.yesterdayChapterDid
v=e.yesterdayStage
w=e.chapterDid
y=e.stage
m=false
l=false
f=false
r=0
d=0
s=0
LuaUtils.SetActive(btn_mask.transform,false)
LuaUtils.SetActive(ScrollViewBox.transform,true)
ForceResetBoxDataAndRefreshView()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsMapBox,OnRespGuildTrialsMapBox)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsSingleMapBox,OnRespGuildTrialsSingleMapBox)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsMapBoxAward,OnRespGuildTrialsMapBoxAward)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
StopDelaySequence()
end
function OnBeforeDestroy()
end
function Refresh(o)
StopDelaySequence()
UIUtil.RefreshScrollView(ScrollViewAct,#a,o)
UIUtil.RefreshScrollView(ScrollViewBox,#i,o)
LuaUtils.SetActive(trans_box.transform,false)
LuaUtils.SetActive(bg_empty.transform,false)
if t and#i>0 then
LuaUtils.SetActive(trans_box.transform,true)
local e=e:getGuildTrialsMapsById(t.mapDid)
LuaUtils.SetActive(im_boss_box.transform,e.isBoss>=1)
LuaUtils.SetActive(im_normal_box.transform,e.isBoss==0)
else
LuaUtils.SetActive(bg_empty.transform,true)
end
UpdateLeftTime()
end
function OnUpdate()
r=r-Time.deltaTime
if r>0 then
return
end
r=1
UpdateLeftTime()
UpdateRedPoint()
end
function UpdateLeftTime()
if t then
local e=t.endTime-TimeUtil.GetServerTimeStamp()
if e>0 then
local e=TimeUtil.toDHMSStr2(e)
LuaUtils.SetTextMeshText(boxdesc_txt,GameTools.GetLocalize("guildTrials_desc_33",LanguageCategory.LangCommon,e))
else
LuaUtils.SetTextMeshText(boxdesc_txt,GameTools.GetLocalize("guildTrials_desc_34",LanguageCategory.LangCommon))
end
end
end
function UpdateRedPoint()
local t=e:getAllMapBoxServerData()
local a=false
for o,t in pairs(t)do
if t.endTime<=TimeUtil.GetServerTimeStamp()and e:hasMapBoxAwardByMapId(t.mapDid)then
e:SetHasMapBoxAwardByMapId(t.mapDid,false)
a=true
end
end
if a==true then
Refresh(false)
end
end
function OnGetItemByIndex(i,o)
o=o+1
local a=a[o]
local t
if a.tabType==e.EMapBoxTabType.chapter then
t=i:NewListViewItem("item_chapter")
OnItemTabChapter(t,a,o)
else
t=i:NewListViewItem("item_hero")
OnItemTabHero(t,a,o)
end
return t
end
function OnItemTabChapter(t,i,n)
local o=LuaUtils.GetLuaComBinder(t.transform)
local o=o:GetComponents()
local i=i.chapterDid
local e=e:getGuildTrialsById(i)
LuaUtils.SetTextMeshText(o["text_name"],GameTools.GetLocalize(e.name,LanguageCategory.LangCommon))
LuaUtils.SetActive(o["im_up"].transform,IsChapterFold(i))
LuaUtils.SetActive(o["im_down"].transform,IsChapterFold(i)==false)
if t.IsInitHandlerCalled==false then
t.IsInitHandlerCalled=true
o["btn_touch"].onClick:AddListener(handler(t,function(e)
local e=e.UserObjectData
local t=a[e]
local t=t.chapterDid
ToggleChapterFold(t,e)
end))
end
t.UserObjectData=n
return t
end
function OnItemTabHero(t,i,n)
local o=LuaUtils.GetLuaComBinder(t.transform)
local o=o:GetComponents()
local i=i.mapDid
local r=e:getMapBoxServerData(i)
local d=e:getGuildTrialsMapsById(i)
local d=HeroMgr:GetHeroCfgData(d.heroDid)
LuaUtils.SetTextMeshText(o["text_name"],GameTools.GetLocalize(d.heroName,LanguageCategory.LangBattle))
LuaUtils.SetActive(o["im_lock"].transform,r==nil)
LuaUtils.SetActive(o["im_select"].transform,i==h)
LuaUtils.SetActive(o["red"].transform,e:hasMapBoxAwardByMapId(i))
if t.IsInitHandlerCalled==false then
t.IsInitHandlerCalled=true
o["btn_touch"].onClick:AddListener(handler(t,function(t)
local t=t.UserObjectData
local t=a[t]
local t=t.mapDid
local a=e:getMapBoxServerData(t)
if a==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_35",LanguageCategory.LangCommon))
else
if t~=h then
s=t
e:reqGuildTrialsSingleMapBox(a.mapId)
end
end
end))
end
t.UserObjectData=n
return t
end
function OnGetItemBoxByIndex(a,n)
n=n+1
local h=i[n]
local a=a:NewListViewItem("boxItem")
local s=LuaUtils.GetLuaComBinder(a.transform)
local r=s:GetComponents()
local h=h.boxRowArr
local s=t.mapDid
local s=e:getGuildTrialsMapsById(s)
for e=1,u do
local a=r["UI_guildTrials_boxItem_"..e]
local t=h[e]
local e=LuaUtils.GetLuaComBinder(a.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["GuildTrialsbd"].transform,false)
if t then
LuaUtils.SetActive(a.transform,true)
LuaUtils.SetActive(e["item"].transform,false)
LuaUtils.SetActive(e["text_other_name"].transform,false)
LuaUtils.SetActive(e["text_my_name"].transform,false)
local i=GetSpineAnimName(o.idle,s.isBoss)
if t.playerId>0 then
i=GetSpineAnimName(o.awarded,s.isBoss)
LuaUtils.SetActive(e["item"].transform,true)
local a=string.split(t.award,":")
local o={
thingDid=tonumber(a[1]),
offset=45
}
UIUtil.SetItemCell(e["itemCell"].transform,{itemDid=tonumber(a[1]),count=tonumber(a[2])},o)
if t.playerId==PlayerMgr.PlayerInfo.uid then
LuaUtils.SetActive(e["text_my_name"].transform,true)
LuaUtils.SetTextMeshText(e["text_my_name"],t.playerName)
else
LuaUtils.SetActive(e["text_other_name"].transform,true)
LuaUtils.SetTextMeshText(e["text_other_name"],t.playerName)
end
end
UIUtil.SpineCheckPlayAnimation(e["spine_box"],0,i,false)
if d==t.boxIdx then
StartAnim(a.transform)
d=0
end
else
LuaUtils.SetActive(a.transform,false)
end
end
if a.IsInitHandlerCalled==false then
a.IsInitHandlerCalled=true
for o=1,u do
local n=r["UI_guildTrials_boxItem_"..o]
local s=h[o]
if s then
local n=LuaUtils.GetLuaComBinder(n.transform)
local n=n:GetComponents()
n["btn_touch"].onClick:AddListener(handler(a,function(a)
local a=a.UserObjectData
local a=i[a]
local a=a.boxRowArr
local a=a[o]
if a then
local o=t.mapDid
if a.playerId==PlayerMgr.PlayerInfo.uid then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_36",LanguageCategory.LangCommon))
return
end
if a.playerId>0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_37",LanguageCategory.LangCommon))
return
end
if t.endTime<TimeUtil.GetServerTimeStamp()then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_38",LanguageCategory.LangCommon))
return
end
if e:hasMapBoxAwardByMapId(o)==false then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_36",LanguageCategory.LangCommon))
return
end
e:reqGuildTrialsMapBoxAward(t.mapId,a.boxIdx)
end
end))
end
end
end
a.UserObjectData=n
return a
end
function GetSpineAnimName(e,t)
if t>=1 then
if e==o.idle then
return"H-A"
elseif e==o.openAnim then
return"H-B"
elseif e==o.openDone then
return"H-C"
elseif e==o.awarded then
return"H-D"
end
else
if e==o.idle then
return"L-A"
elseif e==o.openAnim then
return"L-B"
elseif e==o.openDone then
return"L-C"
elseif e==o.awarded then
return"L-D"
end
end
end
function CalculateTabSelectMapDid()
local o=0
local t=1
local n=6
for i=1,#a do
if a[i].tabType==e.EMapBoxTabType.map then
local a=a[i]
if e:hasMapBoxAwardByMapId(a.mapDid)then
o=a.mapDid
t=i-math.min(a.index,n)
break
end
end
end
if o==0 then
for i=#a,1,-1 do
if a[i].tabType==e.EMapBoxTabType.chapter then
if o>0 then
break
end
elseif a[i].tabType==e.EMapBoxTabType.map then
local a=a[i]
if e:getMapBoxServerData(a.mapDid)then
o=a.mapDid
t=i-math.min(a.index,n)
end
end
end
end
t=t-1
t=math.max(t,0)
return o,t
end
function CalculatePageData()
n={}
a,n=e:GetGuildTrialsBoxData(n)
local e=0
h,e=CalculateTabSelectMapDid()
CalculateBoxData()
local t=CalculateBoxInitIndex()
return e,t
end
function CalculateBoxData()
t=nil
i={}
local a=GetTabData(h)
if a then
t=e:getMapBoxServerData(a.mapDid)
if t then
local e=t.boxes
for o=1,#e,u do
local t={}
local a={
boxRowArr=t,
}
for a=1,u do
local e=e[o+a-1]
if e then
table.insert(t,e)
end
end
table.insert(i,a)
end
end
end
end
function CalculateBoxInitIndex()
if t then
for e=1,#i do
local t=i[e].boxRowArr
for a=1,#t do
if t[a].playerId==PlayerMgr.PlayerInfo.uid then
return e-1
end
end
end
for t=1,#i do
local e=i[t].boxRowArr
for a=1,#e do
if e[a].playerId<=0 then
return t-1
end
end
end
end
return 0
end
function GetTabData(o)
for t=1,#a do
if a[t].tabType==e.EMapBoxTabType.map then
local e=a[t]
if e.mapDid==o then
return e
end
end
end
return nil
end
function IsChapterFold(e)
if n[e]==true then
return true
end
return false
end
function ToggleChapterFold(t,o)
local i=n[t]or false
n[t]=i==false
a,n=e:GetGuildTrialsBoxData(n)
Refresh(false)
if o==1 then
ScrollViewAct:MovePanelToItemIndex(0,0)
end
end
function OnRespGuildTrialsInfo()
if p~=e.yesterdayChapterDid
or v~=e.yesterdayStage
or w~=e.chapterDid
or y~=e.stage then
e:reqGuildTrialsMapBox()
l=true
p=e.yesterdayChapterDid
v=e.yesterdayStage
w=e.chapterDid
y=e.stage
elseif m then
e:reqGuildTrialsMapBox()
end
end
function OnRespGuildTrialsMapBox()
if l==true then
l=false
ForceResetBoxDataAndRefreshView()
else
CheckResetBoxDataAndRefreshView()
end
end
function OnRespGuildTrialsSingleMapBox()
if s>0 and GetTabData(s)then
h=s
ResetBoxDataAndRefreshView()
local e=CalculateBoxInitIndex()
ScrollViewBox:MovePanelToItemIndex(e,0)
else
ResetBoxDataAndRefreshView()
end
s=0
end
function OnRespGuildTrialsMapBoxAward(e)
GameTools:PlayAudioLua(303)
if t and e.mapId==t.mapId then
d=e.boxInfo.boxIdx
end
CheckResetBoxDataAndRefreshView()
d=0
end
function StartAnim(a)
local t=t.mapDid
local t=e:getGuildTrialsMapsById(t)
f=true
StopDelaySequence()
LuaUtils.SetActive(btn_mask.transform,true)
local e=LuaUtils.GetLuaComBinder(a.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["item"].transform,false)
LuaUtils.SetActive(e["GuildTrialsbd"].transform,false)
local i=GetSpineAnimName(o.openAnim,t.isBoss)
local a=GetSpineAnimName(o.openDone,t.isBoss)
local o=GetSpineAnimName(o.awarded,t.isBoss)
UIUtil.SpineCheckPlayAnimation(e["spine_box"],0,i,false,function()
UIUtil.SpinePlayAnimation(e["spine_box"],0,a,true)
end)
LuaUtils.SetActive(e["GuildTrialsbd"].transform,true)
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(0.3)
t:AppendCallback(function()
LuaUtils.SetActive(e["item"].transform,true)
end)
t:AppendInterval(0.3)
t:AppendCallback(function()
UIUtil.SpinePlayAnimation(e["spine_box"],0,o,true)
LuaUtils.SetActive(btn_mask.transform,false)
f=false
end)
c=t
end
function CheckResetBoxDataAndRefreshView()
local e=e:getMapBoxServerData(h)
if e==nil then
ForceResetBoxDataAndRefreshView()
else
ResetBoxDataAndRefreshView()
end
end
function ForceResetBoxDataAndRefreshView()
local e,t=CalculatePageData()
Refresh(true)
ScrollViewAct:MovePanelToItemIndex(e,0)
ScrollViewBox:MovePanelToItemIndex(t,0)
end
function ResetBoxDataAndRefreshView()
CalculateBoxData()
Refresh(false)
end
function OnEventNetReconnectSuccess()
m=true
s=0
end
function OnEventNewDay()
m=true
l=true
end
function StopDelaySequence()
if c~=nil then
c:Kill()
c=nil
end
LuaUtils.SetActive(btn_mask.transform,false)
end

