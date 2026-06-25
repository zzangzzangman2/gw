local e=require"Common/TaskManager/TaskMgr"
local n=require("Common/cs_coroutine")
local v=require('DataNode/DataTable/Create/skillAct/DTHurtNumDBModel')
local p=0.03
local y=0.0015
local u=100
local l=0.12
local d=-10
local m=0.1
local f=0.1
local b=1.2
local w=0.5
local e="Assets/Download/ArtSources/UISpriteRes/%s.png"
local h="UIHurtNum"
local e=""
local e=910
local c=Color.white
local e={}
local e={}
local s=""
local r=""
local a={}
local t=nil
local o
local i
function OnInit(e)
end
function OnOpen(e)
end
function OnClose()
Reset()
end
function OnBeforeDestroy()
end
function OnRefresh(e)
end
function Reset()
StopDoAnim()
StopCoHideAll()
KillAllTweener();
for t=1,#e do
local e=e[t]
LuaUtils.SetActive(e.transform,false)
end
e={}
end
function SetText(i,t)
local function o(o,e)
local e=UIUtil.GetChild(grid.transform,e-1)
if not e then
e=LuaUtils.Instantiate(im_hurt_item.transform)
LuaUtils.SetParent(e.transform,grid.transform)
end
local a=e:GetComponent(typeof(CS.YouYou.YouYouImage))
a.color=c
LuaUtils.SetImageSprite(e,o,true)
LuaUtils.SetActive(e.transform,true)
return e
end
t=tostring(t)
if type(t)~="string"or t==""then
return
end
local a=GetHitNumCfgData(i)
if a==nil then
return
end
Reset()
s=a.stateImgName
r=a.numName
LuaUtils.SetChildrenActive(grid.transform,false)
local a={}
if s~=""then
local e=h.."/"..s
table.insert(a,e)
end
local t,i=string.str2List(t)
for e=1,#t do

if tonumber(t[e])==nil then
break
end
local e=h.."/"..r.."_"..tostring(t[e])
table.insert(a,e)
end
for t=1,#a do
local a=a[t]
local t=o(a,t)
table.insert(e,t)
end
StartDoAnim()
HideAll()
end
function GetHitNumCfgData(e)
return v.GetEntity(tonumber(e))
end
function StopDoAnim()
if o then
n.stop(o)
o=nil
end
end
function StartDoAnim()
StopDoAnim()
o=n.start(
function()
local t=0
local a=#e
for a=1,a do
local e=e[a]
if a==1 then
t=p
coroutine.yield(CS.UnityEngine.WaitForSeconds(t))
elseif a>1 then
t=t-y
if t<0 then
t=0
end
end
coroutine.yield(CS.UnityEngine.WaitForSeconds(t))
e.transform:DOLocalMoveY(u,l):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
function()
e.transform:DOLocalMoveY(d,m):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
function()
e.transform:DOLocalMoveY(0,f):SetEase(CS.DG.Tweening.Ease.InSine):OnComplete(
function()
end)
end)
end)
end
end
)
end
function KillAllTweener()
local t=#e
for t=1,t do
local e=e[t]
e.transform:DOKill()
end
for e=1,#a do
local e=a[e]
e:Kill()
end
a={}
end
function StopCoHideAll()
if i then
n.stop(i)
i=nil
end
end
function HideAll()
StopCoHideAll()
i=n.start(
function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(b))
local t=#e
for t=1,t do
local t=e[t]
local o=t:GetComponent(typeof(CS.YouYou.YouYouImage))
local a=0
local e=1
local e=CS.DG.Tweening.DOTween.To(
function()
return e
end,
function(t)
e=t
end,
a,
w
):OnUpdate(
function()
o.color=Color(1,1,1,e)
end
):OnComplete(function()
LuaUtils.SetActive(t.transform,false)
end)
AddTweener(e)
end
end
)
end
function AddTweener(e)
table.insert(a,e)
end 
