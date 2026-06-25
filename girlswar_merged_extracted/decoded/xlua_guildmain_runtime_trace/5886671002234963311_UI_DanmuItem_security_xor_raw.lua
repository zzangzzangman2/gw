local l=6
local i=10
local s=1000
local c=2
local r=i*c
local h=0
local n=0
local e={}
local t={}
local d={}
local a={}
local f=150
local u=200
local m=300
local o=0.1
local o=nil
function OnInit(e,e)
end
function OnOpen(e)
e=e or{}
EventSystem.AddListener(CommonEventId.OnNewChatMsg,receiveNewMsg)
ResetChatType(e.chatTypeArr)
h=node_chat.transform.rect.width
n=node_chat.transform.rect.height
t={}
local o=n/i
for e=1,i do
local e={
index=e,
endTime=0,
posY=e*o-(n/2)
}
table.insert(t,e)
end
a={}
CheckPlayDunmu()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnNewChatMsg,receiveNewMsg)
StopDelaySequence()
a={}
local e=LuaUtils.GetChildrenCount(node_chat.transform)
for e=1,e do
local e=UIUtil.GetChild(node_chat.transform,e-1)
LuaUtils.SetActive(e.transform,false)
e.transform:DOKill()
table.insert(a,e)
end
end
function Refresh()
end
function OnBeforeDestroy()
end
function OnWillClose()
end
function ResetChatType(e)
d={}
if e then
for t=1,#e do
local e=e[t]
d[e]=true
end
end
end
function PushTaskInfos(t)
local a=#e
local a=s-a
local o=math.min(a,#t)
for o=1,#t do
if a<=0 then
if t[o].playerId==PlayerMgr.PlayerInfo.uid then
table.insert(e,t[o])
end
else
table.insert(e,t[o])
end
a=a-1
end
CheckPlayDunmu()
end
function CheckPlayDunmu()
if o~=nil then
return
end
if#e>0 then
local n=math.ceil(#e/l)
n=math.max(1,n)
local a={}
local s={}
for t=1,#e do
local o=e[t]
if t<=n or o.endTime<Time.realtimeSinceStartup then
if o.playerId==PlayerMgr.PlayerInfo.uid then
table.insert(a,e[t])
else
table.insert(s,e[t])
end
else
break
end
end
local n={}
if#a<=r then
n=a
local e=r-#a
local e=math.min(e,#s)
for e=1,e do
table.insert(n,s[e])
end
else
for e=1,r do
table.insert(n,a[e])
end
end
local a=#n
local n=GetFreeDanmuChannel(a)
if a<=#n then
for t=1,#n do
local t=n[t]
local e=table.remove(e,1)
if e and t then
PlayDanmuText(e,t,0)
end
end
else
for a=1,a do
local o=(a-1)%i+1
local a=math.floor((a-1)/i)
local t=t[o]
local e=table.remove(e,1)
if e and t then
local a=a/c
PlayDanmuText(e,t,a)
end
end
end
StopDelaySequence()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(1)
e:AppendCallback(
function()
o=nil
CheckPlayDunmu()
end
)
o=e
end
end
function GetFreeDanmuChannel(e)
local a=math.min(e,i)
local e={}
for a=1,#t do
if t[a].endTime<Time.realtimeSinceStartup then
table.insert(e,t[a])
end
end
local t={}
while#e>0 do
local o=math.random(1,#e)
local e=table.remove(e,o)
table.insert(t,e)
a=a-1
if a<=0 then
break
end
end
return t
end
function PlayDanmuText(t,o,a)
local i=GetChatInstance()
local e=i:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(e,GetDanmuStr(t))
CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(e.transform)
local i=i:GetComponent(typeof(CS.YouYou.ClickRichText))
i.UserObjectData=t.msgTempDid
local i=h/2+100
local n=e.transform.rect.width
local s=0-n-h/2-100
e.transform.anchoredPosition=Vector2(i,o.posY)
local t
if math.random()<0.1 then
t=math.random(u,m)
else
t=math.random(f,u)
end
local i=math.abs(s-i)
local i=i/t
local h=Time.realtimeSinceStartup
o.endTime=h+n/t+a+0.1
e.transform:DOKill()
e.transform:DOLocalMoveX(s,i):SetEase(CS.DG.Tweening.Ease.Linear):SetDelay(a):OnComplete(
function()
RecycleChatInstance(e)
end)
end
function GetChatInstance()
local e
local t=#a
if t>0 then
e=table.remove(a,t)
else
e=LuaUtils.Instantiate(text_chat.transform)
LuaUtils.SetParent(e,node_chat.transform)
local e=e:GetComponent(typeof(CS.YouYou.ClickRichText))
e.OnTClickRich=touchUrl
end
LuaUtils.SetActive(e.transform,true)
return e
end
function RecycleChatInstance(e)
table.insert(a,e)
LuaUtils.SetActive(e.transform,false)
end
function receiveNewMsg(e)
if d[e.chatType]==true then
local o={}
for a=1,#e.content do
if e.chatType==PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_GUILD then
local t=e.content[a]
if t.senderId~=0 then
local e={
msgTempDid=t.msgTempDid,
msg=GetChatMsgText(t),
endTime=Time.realtimeSinceStartup+l,
playerId=e.content[a].senderId
}
table.insert(o,e)
end
end
end
PushTaskInfos(o)
end
end
function GetChatMsgText(e)
local t=""
if e.msgTempDid==ChatMgr.TEMP_ID.GreatBossSharePos then
local a=ModulesInit.GreatBossMapMgr:GetMapPoint(tonumber(e.msgTempArgs[2]),tonumber(e.msgTempArgs[3]))
local o=GameTools.GetLocalize(a.posName,LanguageCategory.LangCommon)
local a=ChatMgr:getTempInfo(e.msgTempDid)
t=GameTools.GetLocalize(a.key,LanguageCategory.LangCommon,e.msgTempArgs[1],o,tonumber(e.msgTempArgs[2]))
elseif e.msgTempDid==ChatMgr.TEMP_ID.GreatBossSetRally then
local a=ModulesInit.GreatBossMapMgr:GetMapPoint(tonumber(e.msgTempArgs[2]),tonumber(e.msgTempArgs[3]))
local a=GameTools.GetLocalize(a.posName,LanguageCategory.LangCommon)
local o=ChatMgr:getTempInfo(e.msgTempDid)
t=GameTools.GetLocalize(o.key,LanguageCategory.LangCommon,e.msgTempArgs[1],a,tonumber(e.msgTempArgs[2]))
elseif e.msgTempDid==ChatMgr.TEMP_ID.GreatBossKillBoss then
t=ModulesInit.GreatBossMgr:GetKillBossMessage(e)
else
t=e.senderName..": "..e.msg
end
return"["..GameTools.GetLocalize("UI.Chat.Main.03",LanguageCategory.LangCommon).."]"..t
end
function GetDanmuStr(e)
local t=e.msg
if e.playerId==PlayerMgr.PlayerInfo.uid then
t=string.format("<color=#F2F38B>%s</color>",e.msg)
end
return t
end
function StopDelaySequence()
if o~=nil then
o:Kill()
o=nil
end
end
function touchUrl(t,e,a,a)
local t=t
if t==ChatMgr.TEMP_ID.GreatBossSharePos then
ModulesInit.GreatBossMgr:OnCheckJumpGreatBossMap(tonumber(e),false)
elseif t==ChatMgr.TEMP_ID.GreatBossSetRally then
ModulesInit.GreatBossMgr:OnCheckJumpGreatBossMap(tonumber(e),true)
end
end 
