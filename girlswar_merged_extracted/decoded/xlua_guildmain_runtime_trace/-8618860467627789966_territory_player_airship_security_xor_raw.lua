local e=ModulesInit.GuildTerritoryMgr
local q=100
local k=100
local u=100
local y=165
local n=nil
local a=nil
local g=nil
local r=nil
local o=nil
local l=nil
local s=0
local t=nil
local j=nil
local b=0
local w=nil
local i=e.EAirshipState.None
local h=nil
local p=nil
local v=nil
local m=0
local f={}
local c={}
local d={}
function OnInit(e)
local e=LuaUtils.GetLuaComBinder(head_hp_node_01.transform)
p=e:GetComponents()
local e=LuaUtils.GetLuaComBinder(head_hp_node_02.transform)
v=e:GetComponents()
end
function OnOpen(a)
a=a or{}
r=a.parentScriptEnv
s=0
o=nil
l=nil
t=nil
i=e.EAirshipState.None
g=e:GetRadarBaseCfg()
m=-1
LuaUtils.SetActive(left_time_node.transform,false)
LuaUtils.SetActive(battle_head_root.transform,false)
LuaUtils.SetActive(effect_battle_parent.transform,false)
StopAllHeadHpAnimSequence()
InitHpFloatingItemToPool()
end
function OnClose()
p["head_hp_node"].transform:DOKill()
v["head_hp_node"].transform:DOKill()
StopAllHeadHpAnimSequence()
ClearHpFloatingItemToPool()
RemoveSpine()
if h then
r.RemoveAirshipPathTrans(h)
end
r=nil
s=0
o=nil
l=nil
t=nil
i=e.EAirshipState.None
g=nil
end
function OnRefresh(a)
if a==nil then
return
end
t=a
s=t.targetTaskId
o=GetCurrTargetTaskIdPos()
local o,a=e:GetSelfBuildingUILocalPos()
l=Vector3(o,a,0)
RefreshState(true)
local e=e:GetAirShipCfg(t.skinId)
LoadModel(e.slgPrefab)
end
function GetCurrTargetTaskIdPos()
local t=e:GetRadarEventInfoByRadarEventId(s)
if t==nil then
return Vector3(0,0,0)
end
local t=e:GetTerritoryMapCfgByDid(t.posId)
local e,t=e:GetRadarEventUILocalPos(t.pos[1],t.pos[2])
return Vector3(e,t,0)
end
function LoadModel(t)
if IsNil(w)~=nil and b==t then
return
end
local a={
scale=0.7,
animName="idle",
addSortingOrder=0,
}
UIUtil.GetSpinePrefabFromPool(t,function(e,o,o)
RemoveSpine()
b=t
w=e
UIUtil.HandlePoolSpinePrefab(e,airship_root.transform,a)
LuaUtils.SetLocalPos(e.transform,0,0,0)
end)
end
function RemoveSpine()
if w then
UIUtil.SpinePoolDespawn(w)
end
j=nil
w=nil
b=0
end
function GetActualPos(e,t,i,o)
local a=(t-e).normalized
local i=e+a*i
local e=t-a*o
return i,e
end
function GetCurPosition(a,i,t,o)
local e=e:GetLocalServerTime()
local e=(e-t)/(o-t)
e=math.max(0,math.min(1,e))
return a+(i-a)*e
end
function RefreshState(n)
t=e:GetAirshipInfoByRadarEventId(s)
if t==nil then
return
end
local a=e.EAirshipState.None
local o=e:GetLocalServerTime()
if o<t.flyAwayOverTime then
a=e.EAirshipState.GoTo
elseif o<t.battleOverTime then
a=e.EAirshipState.Battle
elseif o<t.flyOffOverTime then
a=e.EAirshipState.Return
else
a=e.EAirshipState.Finish
end
if a==i then
return
end
if i==e.EAirshipState.Battle and a==e.EAirshipState.Return then
local e=t.result==nil or t.result.win==true
EventSystem.SendEvent(CommonEventId.OnGuildRadarAirshipBattleFinish,s,e)
elseif i==e.EAirshipState.Return and a==e.EAirshipState.Finish then
EventSystem.SendEvent(CommonEventId.OnGuildRadarAirshipReturnFinish,s)
end
i=a
if i==e.EAirshipState.GoTo then
OnInGoToState(n)
elseif i==e.EAirshipState.Battle then
OnInBattleState()
elseif i==e.EAirshipState.Return then
OnInReturnState(n)
elseif i==e.EAirshipState.Finish then
OnInFinishState()
end
end
function OnUpdate()
if i==e.EAirshipState.GoTo then
OnGoToStateUpdate()
elseif i==e.EAirshipState.Battle then
OnBattleStateUpdate()
elseif i==e.EAirshipState.Return then
OnReturnStateUpdate()
end
end
function SetAirshipPathTrans(e,t)
if h==nil then
h=r.CreateAirshipPathTrans()
end
LuaUtils.SetActive(h.transform,true)
local e,o=GetActualPos(e,t,q,k)
LuaUtils.SetLocalPos(h.transform,e.x,e.y,0)
local t=e-o
local t=CS.UnityEngine.Vector2.SignedAngle(Vector2.right,Vector2(t.x,t.y))+90
h.transform.localRotation=Quaternion.Euler(0,0,t)
local a=LuaUtils.GetLuaComBinder(h.transform)
local a=a:GetComponents()
a["img_pos_1"].transform.localRotation=Quaternion.Euler(0,0,-t)
a["img_pos_2"].transform.localRotation=Quaternion.Euler(0,0,-t)
local t=Vector3.Distance(e,o)
local e=h.transform.sizeDelta
e.y=t
h.transform.sizeDelta=e
end
local i=150
function CalcPos(e,a)
local e=e*Mathf.Deg2Rad;
local t=Mathf.Cos(e)
local e=Mathf.Sin(e)
local e=Vector3(t,e,0)
local e=e.normalized*a
return e
end
function SetHeadHpData(a,t,h)
if t==nil then
return nil
end
a["head_hp_node"].transform:DOKill()
local o=Vector2(t.selfPos.x,t.selfPos.y)-Vector2(t.targetPos.x,t.targetPos.y)
local o=o.normalized
local o=Mathf.Atan2(o.y,o.x)*Mathf.Rad2Deg;
if o<0 then
o=o+360
end
local o=o
local i=CalcPos(o,i)
local r=CalcPos(o,50)
local o=i
local n=t.targetPos-t.selfPos
local n=CS.UnityEngine.Vector2.SignedAngle(Vector2.right,Vector2(n.x,n.y))
t.isFullHp=h
t.curHp=t.beginAckHp
if t.isFullHp==true then
t.curHp=t.beginAckHp
else
t.curHp=t.endAckHp+(t.beginAckHp-t.endAckHp)*(t.battleTime-t.hasStartedTime)/t.battleTime
end
LuaUtils.SetImageFillAmount(a["img_hp"],GetHpSpecificValue(t.curHp,t.beginAckHp))
if h==true then
LuaUtils.SetActive(a["img_arrows_node"].transform,false)
LuaUtils.SetLocalPos(a["head_hp_node"].transform,i.x,i.y,0)
a["head_hp_node"].transform:DOLocalMove(r,0.08):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
a["head_hp_node"].transform:DOLocalMove(o,0.15):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
a["img_arrows_node"].transform.localRotation=Quaternion.Euler(0,0,n+90)
LuaUtils.SetActive(a["img_arrows_node"].transform,true)
PlayHpAnim(a,t)
end)
end)
else
LuaUtils.SetLocalPos(a["head_hp_node"].transform,o.x,o.y,0)
a["img_arrows_node"].transform.localRotation=Quaternion.Euler(0,0,n+90)
LuaUtils.SetActive(a["img_arrows_node"].transform,true)
PlayHpAnim(a,t)
end
if t.isSelf==true then
local e=PlayerMgr.PlayerInfo
local e=UIUtil.GetPlayerIcon(e.head)
LuaUtils.SetImageSprite(a["img_head"],e,false)
else
local t=e:GetRadarEventInfoByRadarEventId(s)
if t~=nil then
local e=e:GetRadarMissionCfgByDid(t.taskDid)
if e~=nil then
LuaUtils.SetImageSprite(a["img_head"],e.headIcon,false)
end
end
end
end
function PlayHpAnim(i,e)
if e==nil then
return
end
i["img_hp"].transform:DOKill()
local a=e.curHp
local t=e.battleTime-e.hasStartedTime
local t=t/1
t=math.floor(t)
if t<=0 then
LuaUtils.SetImageFillAmount(i["img_hp"],GetHpSpecificValue(e.endAckHp,e.beginAckHp))
return
end
local o=a-e.endAckHp
local s=CS.DG.Tweening.DOTween.Sequence()
for n=1,t do
local a=(o/(t-n+1))
if n==t then
a=o
else
a=a*(1+math.random()*0.05)
end
o=o-a
local t=math.max(o,0)
if n>1 then
s:AppendInterval(0.98)
end
s:AppendCallback(function()
AddHpFloatingItem(a,e.isSelf)
local t=GetHpSpecificValue((e.endAckHp+t),e.beginAckHp)
i["img_hp"]:DOFillAmount(t,0.78):SetEase(CS.DG.Tweening.Ease.OutCubic)
local t=i["head_anim_node"].gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
if e.isSelf then
LuaUtils.AnimtorPlay(t,"un_GuildTerritory_act05hit",0,0)
else
LuaUtils.AnimtorPlay(t,"un_GuildTerritory_act05hit_2",0,0)
end
end)
end
SetHeadHpAnimSequence(i,s)
end
function GetHpSpecificValue(e,t)
local e=(e/t)*0.86+0.07
e=math.max(math.min(e,0.93),0.07)
return e
end
function GetRadarEventType()
local a=e.ERadarEventType.None
local t=e:GetRadarEventInfoByRadarEventId(t.targetTaskId)
if t~=nil then
local e=e:GetRadarMissionCfgByDid(t.taskDid)
if e then
a=e.taskEnumerate
end
end
return a
end
function OnInGoToState(s)
if t==nil then
return
end
transform:DOKill()
LuaUtils.SetActive(battle_head_root.transform,false)
LuaUtils.SetActive(effect_battle_parent.transform,false)
local i=GetRadarEventType()
local i=i==e.ERadarEventType.Collect and u or y
n,a=GetActualPos(l,o,u,i)
if s==true then
local e=GetCurPosition(n,a,t.beginFlyTime,t.flyAwayOverTime)
LuaUtils.SetLocalPos(transform,e.x,e.y,0)
else
LuaUtils.SetLocalPos(transform,n.x,n.y,0)
end
SetAirshipPathTrans(l,o)
local o=n.x>a.x
LuaUtils.SetLocalScale(airship_root.transform,o and-1 or 1,1,1)
local e=t.flyAwayOverTime-e:GetLocalServerTime()
transform:DOLocalMove(Vector3(a.x,a.y,0),e):SetEase(CS.DG.Tweening.Ease.Linear)
LuaUtils.SetActive(left_time_node.transform,true)
end
function OnGoToStateUpdate()
if t==nil then
return
end
if t.flyAwayOverTime<=e:GetLocalServerTime()then
RefreshState()
end
local e=t.flyAwayOverTime-e:GetLocalServerTime()
if e~=m then
m=e
LuaUtils.SetTextMeshText(text_left_time,GameTools.GetLocalize("UI.Equip.Common.14",LanguageCategory.LangCommon,tostring(e)))
end
end
function OnInBattleState()
if t==nil then
return
end
transform:DOKill()
m=0
LuaUtils.SetActive(left_time_node.transform,false)
if h then
LuaUtils.SetActive(h.transform,false)
end
StopAllHeadHpAnimSequence()
local i=GetRadarEventType()
local h=i==e.ERadarEventType.Collect and u or y
n,a=GetActualPos(l,o,u,h)
LuaUtils.SetLocalPos(transform,a.x,a.y,0)
local n=n.x>a.x
LuaUtils.SetLocalScale(airship_root.transform,n and-1 or 1,1,1)
local n=t.result
if i==e.ERadarEventType.Collect then
local e=nil
if r then
e=r.GetRadarEventBuilding(s)
if e then
e.scriptEnv.SetCollectEffectShow(true)
end
end
else
local s=Vector2(o.x-a.x,o.y-a.y)*0.5
LuaUtils.SetActive(effect_battle_parent.transform,true)
LuaUtils.SetLocalPos(effect_battle_parent,s.x,s.y,0)
if n and i==e.ERadarEventType.Fight or
i==e.ERadarEventType.Assess or
i==e.ERadarEventType.Army then
LuaUtils.SetActive(battle_head_root.transform,true)
LuaUtils.SetLocalPos(battle_head_root,s.x,s.y,0)
local i=t.battleOverTime-t.flyAwayOverTime
local e=e:GetLocalServerTime()-t.flyAwayOverTime
local t={
beginAckHp=n.beginAckHp,
endAckHp=n.endAckHp,
battleTime=i,
hasStartedTime=e,
isSelf=true,
selfPos=a,
targetPos=o
}
SetHeadHpData(p,t,e<1.1)
local t={
beginAckHp=n.beginDefHp,
endAckHp=n.endDefHp,
battleTime=i,
hasStartedTime=e,
isSelf=false,
selfPos=o,
targetPos=a
}
SetHeadHpData(v,t,e<1.1)
end
end
end
function OnBattleStateUpdate()
if t==nil then
return
end
if t.battleOverTime<=e:GetLocalServerTime()then
RefreshState()
end
end
function OnInReturnState(h)
if t==nil then
return
end
transform:DOKill()
LuaUtils.SetActive(battle_head_root.transform,false)
LuaUtils.SetActive(effect_battle_parent.transform,false)
local i=GetRadarEventType()
if i==e.ERadarEventType.Collect then
local e=nil
if r then
e=r.GetRadarEventBuilding(s)
if e then
e.scriptEnv.SetCollectEffectShow(false)
end
end
end
local i=i==e.ERadarEventType.Collect and u or y
n,a=GetActualPos(o,l,i,u)
if h==true then
local e=GetCurPosition(n,a,t.battleOverTime,t.flyOffOverTime)
LuaUtils.SetLocalPos(transform,e.x,e.y,0)
else
LuaUtils.SetLocalPos(transform,n.x,n.y,0)
end
SetAirshipPathTrans(o,l)
local o=n.x>a.x
LuaUtils.SetLocalScale(airship_root.transform,o and-1 or 1,1,1)
local t=t.flyOffOverTime-e:GetLocalServerTime()
transform:DOLocalMove(Vector3(a.x,a.y,0),t):SetEase(CS.DG.Tweening.Ease.Linear)
LuaUtils.SetActive(left_time_node.transform,true)
local t=e:GetAirshipInfoByRadarEventId(s)
if t~=nil then
if e:GetLocalServerTime()>=t.battleOverTime then
if t.result==nil or t.result.win==true then
if r then
r.RemoveRadarEvent(s)
end
end
end
end
end
function OnReturnStateUpdate()
if t==nil then
return
end
if t.flyOffOverTime<=e:GetLocalServerTime()then
RefreshState()
end
local e=t.flyOffOverTime-e:GetLocalServerTime()
if e~=m then
m=e
LuaUtils.SetTextMeshText(text_left_time,GameTools.GetLocalize("UI.Equip.Common.14",LanguageCategory.LangCommon,tostring(e)))
end
end
function OnInFinishState()
if t==nil then
return
end
transform:DOKill()
m=0
LuaUtils.SetActive(left_time_node.transform,false)
LuaUtils.SetActive(battle_head_root.transform,false)
LuaUtils.SetActive(effect_battle_parent.transform,false)
local t=GetRadarEventType()
local e=t==e.ERadarEventType.Collect and u or y
n,a=GetActualPos(o,l,e,u)
LuaUtils.SetLocalPos(transform,a.x,a.y,0)
end
function GetAirshipPos()
return LuaUtils.GetLocalPos(transform)
end
function SetHeadHpAnimSequence(e,t)
if f[e]~=nil then
f[e]:Kill()
f[e]=nil
end
f[e]=t
end
function StopAllHeadHpAnimSequence()
for t,e in pairs(f)do
if e~=nil then
e:Kill()
e=nil
end
end
f={}
end
function AddHpFloatingItem(i,s)
if i<=0 then
i=1
end
local e=GetHpFloatingTransItem()
e:DOKill()
local h=e:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
local n=""
local t=nil
if s==true then
t=Vector3(0,0,0)
n="<color=#ff4141>-"..tostring(math.ceil(i)).."</color>"
else
t=o-a
n=tostring(math.ceil(i))
end
t.y=t.y+50
LuaUtils.SetTextMeshText(h,n)
LuaUtils.SetLocalPos(e.transform,t.x,t.y,0)
local a=CS.DG.Tweening.DOTween.Sequence()
local o=e:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
o.alpha=1
LuaUtils.SetLocalScale(e.transform,1.3,1.3,1.3)
a:Append(e.transform:DOScale(1,0.2))
a:Append(e.transform:DOLocalMoveY(t.y+50,1))
a:Join(o:DOFade(0,1))
a:OnComplete(function()
c[e]=nil
RemoveHpFloatingItemToPool(e)
end)
if c==nil then
c={}
end
c[e]={sequence=a}
end
function InitHpFloatingItemToPool()
c={}
d={}
local e=LuaUtils.GetChildrenCount(hp_floating_root.transform)
for e=1,e do
local e=LuaUtils.GetChild(hp_floating_root.transform,e-1)
if e then
RemoveHpFloatingItemToPool(e)
end
end
end
function GetHpFloatingTransItem()
local e=nil
if d==nil or#d<=0 then
e=LuaUtils.Instantiate(hp_floating_item.transform)
LuaUtils.SetParent(e.transform,hp_floating_root.transform)
LuaUtils.SetActive(e,true)
else
e=table.remove(d,#d)
end
e.transform.localScale=Vector3.one
return e.transform
end
function RemoveHpFloatingItemToPool(e)
if e==nil then
return
end
if d==nil then
d={}
end
e:DOKill()
local t=e:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
t.alpha=0
table.insert(d,e)
end
function ClearHpFloatingItemToPool()
for t,e in pairs(c)do
if e.sequence~=nil then
e.sequence:Kill()
e.sequence=nil
end
RemoveHpFloatingItemToPool(t)
end
c=nil
d=nil
end

