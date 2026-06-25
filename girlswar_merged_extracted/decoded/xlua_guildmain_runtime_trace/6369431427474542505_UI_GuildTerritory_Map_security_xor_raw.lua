local e=ModulesInit.GuildTerritoryMgr
local i=nil
local m=nil
local w=0
local f=0
local c=0
local u=0
local s=1
local d=false
local l=false
local h=nil
function OnInit(e)
UIUtil.AddTouchEventMulti(mMapSv,onClickPointDown,onClickPointUp,nil,nil,nil,nil)
btn_guild_city.onClick:AddListener(function()
local e={
guildId=PlayerMgr.PlayerInfo.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end)
end
function OnOpen(e)
i=e.parentScriptEnv
CleanAllMap()
InitData()
mMapSv.enabled=false
LuaUtils.SetTextMeshText(text_guild_name,PlayerMgr.PlayerInfo.guildName)
LuaUtils.SetActive(event_select_node.transform,false)
end
function OnClose()
StopTransBuildingSequence()
Content.transform:DOKill()
CleanAllMap()
i=nil
m=nil
end
function InitData()
s=1
LuaUtils.SetLocalScale(Content.transform,s,s,s)
local t=Content.transform.rect.width
local a=Content.transform.rect.height
c=-300
f=-300
w=a+300
u=t+300
m=e:GetMapBaseCfg()
d=false
l=false
h=nil
end
function OnRefresh()
CrateAllMap()
end
function CrateAllMap()
if GameInit.IsEditor and e.isTestShowMapTitle then
CrateTileMap()
end
RefreshCrateAllBuilding()
RefreshCrateAllRadarEvent()
RefreshCrateAllAirship()
RefreshCrateAllAuraAirship()
RefreshCrateAllOtherRadarEvent()
end
function CleanAllMap()
if GameInit.IsEditor then
RemoveAllTile()
end
RemoveAllBuilding()
RemoveAllRadarEvent()
RemoveAllAirship()
RemoveAllAuraAirship()
RemoveAllOtherRadarEvent()
end
function GetMapCurrScale()
return s
end
function OnFocusMyBuilding(a)
local t,o=e:GetSelfBuildingMapPos()
local t,e=e:MapPos2UILocalPos(t,o)
MoveMapToMapPos(t,e,a)
end
function MoveMapToMapPos(t,e,a)
local o=Content.transform.localPosition
local e=Content.transform:TransformPoint(Vector3(t,e,0));
local i=Content.parent.transform:InverseTransformPoint(e)
local e=mMapSv.transform.rect
local t=e.width*0.5
local e=e.height*0.5
local t=(t-i.x+o.x)
local e=(e-i.y+o.y)
t,e=CheckContentPos(t,e)
Content.transform:DOKill()
local i=Vector3(t,e,0)
local o=Vector3.Distance(o,i)
a=a and o>0.1
if a then
l=true
Content.transform:DOLocalMove(i,0.2):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
l=false
end)
else
l=false
LuaUtils.SetLocalPos(Content.transform,t,e,0)
end
end
function CheckContentPos(t,e)
local a=mMapSv.transform.rect
local o=Content.transform.rect
local i=(a.width-o.width*s)
local a=(a.height-o.height*s)
if t>0 then
t=0
end
if t<i then
t=i
end
if e>0 then
e=0
end
if e<a then
e=a
end
return t,e
end
function OnFocusClickSelectTaskBuilding(a)
local t=e:GetRadarEventInfoByRadarEventId(a)
if t==nil then
t=e:GetOtherRadarEventInfoByRadarEventId(a)
end
if t~=nil then
local t=e:GetTerritoryMapCfgByDid(t.posId)
if t~=nil then
local e,t=e:GetRadarEventUILocalPos(t.pos[1],t.pos[2])
MoveMapToMapPos(e,t,true)
end
end
return t~=nil
end
function SetEventSelectNodeShow(t,o)
if t==true then
local a=e:GetRadarEventInfoByRadarEventId(o)
if a==nil then
a=e:GetOtherRadarEventInfoByRadarEventId(o)
end
if a~=nil then
local a=e:GetTerritoryMapCfgByDid(a.posId)
if a~=nil then
local e,t=e:GetRadarEventUILocalPos(a.pos[1],a.pos[2])
LuaUtils.SetLocalPos(event_select_node.transform,e,t,0)
else
t=false
end
else
t=false
end
end
LuaUtils.SetActive(event_select_node.transform,t)
end
function OnClickSelectTask(e)
OnFocusClickSelectTaskBuilding(e)
if i then
i.OnClickSelectTask(e)
end
end
function SetTransferNode(t,o,a)
LuaUtils.SetActive(player_transfer_node.transform,t)
if t==true then
local t,e=e:MapPos2UILocalPos(o,a)
LuaUtils.SetLocalPos(player_transfer_node.transform,t,e,0)
end
end
local t={}
function RefreshCrateAllBuilding()
local a=e.buildingInfoMap or{}
local e={}
for t,o in pairs(t)do
if a[t]==nil then
e[t]=true
end
end
for t,a in pairs(a)do
RefreshCrateBuilding(t)
e[t]=nil
end
for e,t in pairs(e)do
if t then
RemoveBuilding(e,true)
end
end
end
function RefreshCrateBuilding(a)
local o=e:GetBuildingInfoByPlayerId(a)
if o==nil and t[a]==nil then
return
end
local e=nil
if t[a]==nil then
e=CreateBuilding()
t[a]=e
else
e=t[a]
end
if o==nil then
RemoveBuilding(a,true)
return
end
e:Refresh(o)
d=true
end
function CreateBuilding()
local e=e:InstantiateCreateLuaUnit(territory_player_building.transform,build_root.transform)
local t={parentScriptEnv=selfEnv}
e:Open(t)
return e
end
function RemoveBuilding(a,e)
local e=t[a]
if e==nil then
return
end
e:Close()
t[a]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveAllBuilding()
for a,e in pairs(t)do
e:Close()
GameObject.Destroy(e.gameObject)
end
t={}
end
function OnGuildRadarTransferNotify(e)
if e~=PlayerMgr.PlayerInfo.uid then
RefreshCrateBuilding(e)
end
end
function OnGuildRadarPlayerQuitNotify(e)
if e~=PlayerMgr.PlayerInfo.uid then
RefreshCrateBuilding(e)
end
end
function OnGuildRadarRefreshBuildingInfo(a)
local e=e:GetBuildingInfoByPlayerId(a)
if e~=nil and t[a]~=nil then
local t=t[a]
t:Refresh(e)
end
end
local a=nil
function StopTransBuildingSequence()
if a~=nil then
a:Kill()
a=nil
end
end
function OnRespGuildRadarTransfer()
local i=PlayerMgr.PlayerInfo.uid
local o=t[i]
if o==nil then
RefreshCrateBuilding(i)
o=t[i]
end
if o==nil then
return
end
o.scriptEnv.SetIsTransferAnim(true)
SetMapScale(1)
local t,n=e:GetSelfBuildingMapPos()
local n,t=e:MapPos2UILocalPos(t,n)
MoveMapToMapPos(n,t,true)
StopTransBuildingSequence()
a=CS.DG.Tweening.DOTween.Sequence()
a:AppendInterval(0.3)
a:AppendCallback(function()
local e=e:GetBuildingInfoByPlayerId(i)
o.scriptEnv.SetBuildInfo(e)
o.scriptEnv.TransferRefreshBuildingPos()
RefreshCrateAllRadarEvent()
end)
a:AppendInterval(1)
a:AppendCallback(function()
o.scriptEnv.SetIsTransferAnim(false)
end)
end
local n={}
function RefreshCrateAllRadarEvent()
local e=e.myTaskInfoMap or{}
local t={}
for a,o in pairs(n)do
if e[a]==nil or e[a].status==1 then
t[a]=true
end
end
for a,e in pairs(e)do
if e~=nil and e.status==0 then
RefreshCrateRadarEvent(a)
t[a]=nil
end
end
for t,e in pairs(t)do
if e==true then
RemoveRadarEvent(t)
end
end
end
function RefreshCrateRadarEvent(t)
local a=e:GetRadarEventInfoByRadarEventId(t)
if a==nil and n[t]==nil then
return
end
local e=nil
if n[t]==nil then
e=CreateRadarEvent()
n[t]=e
else
e=n[t]
end
if a==nil then
RemoveRadarEvent(t)
return
end
RemoveOtherRadarEventByPosId(a.posId)
e:Refresh(t)
d=true
end
function CreateRadarEvent()
local e=e:InstantiateCreateLuaUnit(territory_radar_event.transform,build_root.transform)
local t={parentScriptEnv=selfEnv}
e:Open(t)
return e
end
function RemoveRadarEvent(t)
local e=n[t]
if e==nil then
return
end
e:Close()
n[t]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveAllRadarEvent()
for t,e in pairs(n)do
e:Close()
GameObject.Destroy(e.gameObject)
end
n={}
end
function GetRadarEventBuilding(e)
local e=n[e]
return e
end
local o={}
local a={}
function RefreshCrateAllAirship()
local o=e.airshipInfoMap or{}
local e={}
for t,a in pairs(a)do
if o[t]==nil then
e[t]=true
end
end
for t,a in pairs(o)do
RefreshCrateAirship(t)
e[t]=nil
end
for t,e in pairs(e)do
if e then
RemoveAirship(t)
end
end
end
function RefreshCrateAirship(t)
local o=e:GetAirshipInfoByRadarEventId(t)
if o==nil and a[t]==nil then
return
end
local e=nil
if a[t]==nil then
e=CreateAirship()
a[t]=e
else
e=a[t]
end
if o==nil then
RemoveAirship(t)
return
end
e:Refresh(o)
end
function CreateAirship()
local e=e:InstantiateCreateLuaUnit(territory_player_airship.transform,airship_root.transform)
local t={parentScriptEnv=selfEnv}
e:Open(t)
return e
end
function RemoveAirship(t)
local e=a[t]
if e==nil then
return
end
e:Close()
a[t]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveAllAirship()
for t,e in pairs(a)do
e:Close()
GameObject.Destroy(e.gameObject)
end
a={}
RemoveAllAirshipPathTrans()
end
function OnFocusAirShipByTaskId(e,t)
local e=a[e]
if e==nil then
return
end
local e,a,o=e.scriptEnv.GetAirshipPos()
MoveMapToMapPos(e,a,t)
end
function RemoveAllAirshipPathTrans()
for e,t in pairs(o)do
if IsNil(e)==false then
GameObject.Destroy(e.gameObject)
end
end
o={}
end
function RemoveAirshipPathTrans(e)
o[e]=nil
GameObject.Destroy(e.gameObject)
end
function CreateAirshipPathTrans()
local e=LuaUtils.Instantiate(airshipPath.transform)
LuaUtils.SetParent(e,airshipPath_root.transform)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetActive(e,true)
o[e]=true
return e
end
local o={}
function RefreshCrateAllOtherRadarEvent()
local t=e.otherTaskInfoMap or{}
local e={}
for a,o in pairs(o)do
if t[a]==nil then
e[a]=true
end
end
for t,a in pairs(t)do
RefreshCrateOtherRadarEvent(t)
e[t]=nil
end
for e,t in pairs(e)do
if t==true then
RemoveOtherRadarEvent(e)
end
end
end
function RefreshCrateOtherRadarEvent(t)
local a=e:GetOtherRadarEventInfoByRadarEventId(t)
if a==nil and o[t]==nil then
return
end
if a then
local e=e:GetRadarEventInfoByPosId(a.posId)
if e~=nil then
RemoveOtherRadarEvent(t)
return
end
end
local e=nil
if o[t]==nil then
e=CreateRadarEvent()
o[t]=e
else
e=o[t]
end
if a==nil then
RemoveOtherRadarEvent(t)
return
end
e:Refresh(t)
d=true
end
function RemoveOtherRadarEventByPosId(n)
local i=0
local e=nil
for o,a in pairs(o)do
local t=a.scriptEnv.GetTaskInfo()
if t and t.posId==n then
i=o
e=a
break
end
end
if e==nil then
return
end
e:Close()
o[i]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveOtherRadarEvent(t)
local e=o[t]
if e==nil then
return
end
e:Close()
o[t]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveAllOtherRadarEvent()
for t,e in pairs(o)do
e:Close()
GameObject.Destroy(e.gameObject)
end
o={}
end
local r={}
function RefreshCrateAllAuraAirship()
local e=m and m.auraAirNum or 0
for e=1,e do
RefreshCrateAuraAirship(e)
end
end
function RefreshCrateAuraAirship(e)
local t=nil
if r[e]==nil then
t=CreateAuraAirship()
r[e]=t
end
end
function CreateAuraAirship()
local e=e:InstantiateCreateLuaUnit(territory_player_auraAirship.transform,airship_root.transform)
local t={parentScriptEnv=selfEnv}
e:Open(t)
return e
end
function RemoveAuraAirship(t)
local e=r[t]
if e==nil then
return
end
e:Close()
r[t]=nil
GameObject.Destroy(e.gameObject)
end
function RemoveAllAuraAirship()
for t,e in pairs(r)do
e:Close()
GameObject.Destroy(e.gameObject)
end
r={}
end
function GetAuraAirshipStartEndPos()
local a=Vector3(math.random(c,u),w,0)
local o=Vector3(math.random(c,u),f,0)
local t=Vector3(c,math.random(f,w),0)
local e=Vector3(u,math.random(f,w),0)
local t={a,o,t,e}
local a=math.random(1,4)
local e=math.random(1,3)
if e>=a then
e=e+1
end
return t[a],t[e]
end
function CrateTileMap()
local e=50
for e=0,e-1 do
local t=e+1
for t=-e,t-1 do
if(e+t<=30 and e-t<=26)then
CreateTile(e,t)
end
end
end
end
function CreateTile(a,o)
local t=LuaUtils.Instantiate(UI_Territory_Cell.transform)
LuaUtils.SetParent(t,tile_root.transform)
LuaUtils.SetActive(t,true)
local i,e=e:MapPos2UILocalPos(a,o)
LuaUtils.SetLocalPos(t,i,e,0)
local e=t:Find('text_pos'):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(e,a.." , "..o)
end
function RemoveAllTile()
LuaUtils.DestroyChildren(tile_root.transform)
end
function SortAllBuild()
local e={}
for a,t in pairs(t)do
table.insert(e,t.transform)
end
for a,t in pairs(n)do
table.insert(e,t.transform)
end
for a,t in pairs(o)do
table.insert(e,t.transform)
end
table.sort(e,function(e,t)
local a=LuaUtils.GetLocalPosY(e)
local e=LuaUtils.GetLocalPosY(t)
return a>e
end)
for e,t in ipairs(e)do
LuaUtils.SetSiblingIndex(t.transform,e-1)
end
end
function OnUpdate()
if a then
for t,e in pairs(a)do
e.scriptEnv.OnUpdate()
end
end
if d==true then
d=false
SortAllBuild()
end
end
local t=nil
function onClickPointDown(e)
if l then
return
end
if CS.UnityEngine.Input.touchCount<=1 then
mMapSv.enabled=true
else
mMapSv.enabled=false
end
local e=e.position
t=Vector3(e.x,e.y)
if i then
i.SetUnGuildTerritoryVibe02Show(false)
end
end
function OnDrag()
if CS.UnityEngine.Input.touchCount<=1 then
mMapSv.enabled=true
else
mMapSv.enabled=false
end
end
function onClickPointUp(e)
mMapSv.enabled=false
if t==nil then
return
end
if CS.UnityEngine.Input.touchCount>1 then
return
end
local e=e.position
if Vector3.Distance(t,Vector3(e.x,e.y))<10 then
local e=GameEntry.CameraCtrl.UICamera:ScreenToWorldPoint(Vector3(e.x,e.y,0))
OnClickMapCell(e)
end
if i then
i.SetUnGuildTerritoryVibe02Show(true)
end
end
function OnClickMapCell(t)
if t==nil then
return
end
local t=Content.transform:InverseTransformPoint(t)
local n,o=e:UILocalPos2MapPos(t.x,t.y)
local t=e:GetPosIdByMapPos(n,o)
if t<=0 then
return
end
local a=nil
local s=e.buildingInfoMap or{}
for o,e in pairs(s)do
if e.posId==t then
a=e
break
end
end
if a then
if a.playerId==PlayerMgr.PlayerInfo.uid then
UIUtil.forceShowUI(UIFormId.UI_GuildTerritory_MyInfo)
else
e:OnShowPlayerInfo(a.playerId)
end
return
end
local a=e:GetTerritoryMapCfgByDid(t)
if a and a.forbidCity==0 then
if i then
local a,e=e:MapPos2UILocalPos(n,o)
local e=Content.transform:TransformPoint(Vector3(a,e,0));
i.OnClickSelectBlankMapCell(t,e,n,o)
end
end
end
function ClearZoomData()
h=nil
end
function OnZoom(t)
if l then
return
end
local t=false
t,h=GameTools:GetZoomData(h)
if t==false then
return
end
local a=0
if h.mouseWheel~=nil and h.mouseWheel~=0 then
a=(h.mouseWheel*0.2)
else
local e=h.oldTouchDis or 0
local t=h.newTouchDis or 0
local e=t/e-1
a=e*0.95
end
if i then
i.HideRransferNodeTrans()
end
local t,o,i
t,o,i=LuaUtils.GetLocalScale(Content.transform,t,o,i)
t=t+a
t=math.min(t,e.sxMax)
t=math.max(t,e.sxMin)
SetMapScale(t)
end
function SetMapScale(e)
if s~=e then
LuaUtils.SetLocalScale(Content.transform,e,e,e)
local a=mMapSv.transform.rect
local t=mMapSv.content.transform.localPosition
local o=a.width*0.5
local a=a.height*0.5
local o=(t.x-o)*(e/s)+o
local t=(t.y-a)*(e/s)+a
s=e
local e,t=CheckContentPos(o,t)
LuaUtils.SetLocalPos(Content.transform,e,t,0)
end
end 
