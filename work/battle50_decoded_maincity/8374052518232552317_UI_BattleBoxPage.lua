local o={
BornFly=1,
Active=2,
Finish=3,
}
local d={
[7]={71,72},[1]={11,12},[4]={41,42},
[8]={81,82},[2]={21,22},[5]={51,52},
[9]={91,92},[3]={31,32},[6]={61,62}
}
local l={
[1]={11,72,12,71,21,22,31,32,82,81,41,42,51,52,92,91,61,62},
[2]={21,82,22,81,31,32,11,12,51,52,61,62,41,42,92,91,72,71},
[3]={31,92,32,82,21,22,11,12,91,81,61,62,51,52,72,71,41,42},
[4]={41,42,51,52,12,11,21,22,61,62,32,31,72,71,82,81,92,91},
[5]={51,52,22,21,61,62,41,42,32,31,12,11,82,81,92,91,72,71},
[6]={61,62,32,31,51,52,22,21,41,42,12,11,92,91,82,81,72,71},
}
local u={
[11]={1,2,3},
[12]={1,2,3},
[21]={2,3},
[22]={2},
[31]={3},
[32]={3},
[41]={4,2,5,6},
[42]={4,2,5,6},
[51]={5,6},
[52]={5,6},
[61]={6},
[62]={6},
[71]={},
[72]={},
[81]={},
[82]={},
[91]={},
[92]={},
}
local s={}
local r={}
local e={}
local n={}
function OnInit(e,e)
end
function OnOpen(e)
e=e or{}
EventSystem.AddListener(CommonEventId.OnBattleHeroDeath,OnBattleHeroDeath)
EventSystem.AddListener(CommonEventId.OnBattleHeroDeathTimeline,OnBattleHeroDeath)
EventSystem.AddListener(CommonEventId.OnEventBattleEnd,OnEventBattleEnd)
EventSystem.AddListener(CommonEventId.OnEventBattleNextWaveEnemy,OnEventBattleNextWaveEnemy)
LuaUtils.SetActive(box_item.transform,false)
r=CreateAwardData(ModulesInit.ProcedureNormalBattle.dropBoxData)
ResetDataInNewWave()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnBattleHeroDeath,OnBattleHeroDeath)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroDeathTimeline,OnBattleHeroDeath)
EventSystem.RemoveListener(CommonEventId.OnEventBattleEnd,OnEventBattleEnd)
EventSystem.RemoveListener(CommonEventId.OnEventBattleNextWaveEnemy,OnEventBattleNextWaveEnemy)
for a,t in pairs(e)do
if t.boxTran then
t.boxTran:DOKill()
RecycleBoxInstance(t.boxTran)
end
end
e={}
end
function Refresh()
end
function OnBeforeDestroy()
end
function OnWillClose()
end
function ResetDataInNewWave()
n=GetCurPositionData()
end
function GetCurPositionData()
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetWaveData()
local a=ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex
local e=e[a]
local e=e.enemyTeamFormation
for a=1,#e do
local e=e[a]
if e.heroId~=0 then
t[e.position]=true
end
end
return t
end
function CreateAwardData(e)
if e==nil or#e<=0 then
return{}
end
local n={}
local o=#e
if o>0 then
local i=ModulesInit.ProcedureNormalBattle.GetWaveData()
local t=#i
local a={}
for e=1,t do
a[e]={}
end
if t>0 then
for o=1,o do
local t=t-(o-1)%t
table.insert(a[t],e[o])
end
end
for e=1,#i do
n[e]={}
local o=n[e]
local t={}
local i=i[e].enemyTeamFormation
for e=1,#i do
local e=i[e]
if e.heroId<0 then
table.insert(t,e.heroId)
o[e.heroId]={finish=false,itemDatas={}}
end
end
local e=a[e]
if e then
local a=#e
local s=#t
local i=a%s
local n={}
for t=a-i+1,a do
table.insert(n,e[t])
end
local a=a-i
for a=1,a do
local i=(a-1)%s+1
local t=t[i]
if t then
table.insert(o[t].itemDatas,e[a])
end
end
local t=RandomTable(t,i)
for a=1,#n do
local t=t[a]
if t then
table.insert(o[t].itemDatas,e[a])
end
end
end
end
end
return n
end
function GenBox(i,h,d,r)
local t=GetBoxInstance()
local a=LuaUtils.GetLuaComBinder(t)
local a=a:GetComponents()
e[i]={
boxTran=t,
itemData=h,
state=o.BornFly
}
local n=e[i]
UIUtil.SpinePlayAnimation(a["sp_box"].transform,0,"A",true)
LuaUtils.SetActive(a["btn_box"].transform,true)
local s=a["btn_box"].transform:GetComponent(typeof(CS.YouYou.UIEventListener))
if not s then
s=a["btn_box"].gameObject:AddComponent(typeof(CS.YouYou.UIEventListener))
end
s.onClick=function()

if n.state==o.Active then
n.state=o.Finish
UIUtil.SpinePlayAnimation(a["sp_box"].transform,0,"B",false,function()
showFlyAction(h,t.transform.position)
UIUtil.SpinePlayAnimation(a["sp_box"].transform,0,"C",false,function()
RecycleBoxInstance(t)
e[i]=nil
end)
end)
end
end
local e=d
t.transform.position=e
local i=15
local a=2.5
local s=10
local e=UIUtil.GetParabolaPathByPos(e,r,i,a,s)
t:DOKill()
t.transform:DOPath(e,0.5,CS.DG.Tweening.PathType.Linear):SetDelay(0.5):OnComplete(
function()
n.state=o.Active
end)
end
function GetBoxInstance()
local e
local t=#s
if t>0 then
e=table.remove(s,t)
else
e=LuaUtils.Instantiate(box_item.transform)
LuaUtils.SetParent(e,node_box.transform)
LuaUtils.SetLookRotationTarget(box_item.transform,GameEntry.CameraCtrl.MainCamera.transform)
end
LuaUtils.SetActive(e.transform,true)
return e
end
function RecycleBoxInstance(e)
table.insert(s,e)
LuaUtils.SetActive(e.transform,false)
end
function showFlyBoxAction(t)
local e={}
local t={
itemType=EItemFlyType.Image,
imagePath="UIBattle/zhandou_boxsmall",
startWorldPos=t,
isUIPos=false,
endPosType=EBattleItemFlyTargetType.BattleBox,
scale=3,
needRandom=false,
flyEndScale=1,
flyFlag="battle_box_key",
isSimpleAction=true
}
table.insert(e,t)
local e={itemFlyEvent=CommonEventId.OnBattleShowBoxFly,flyContentArr=e}
EventSystem.SendEvent(CommonEventId.OnBattleShowBoxFly,e)
end
function showFlyAction(t,e)
local a={}
local e={
itemDid=t[1],
count=t[2],
itemType=EItemFlyType.GameItem,
startWorldPos=Vector3(e.x,e.y+1,e.z),
isUIPos=false,
endPosType=EBattleItemFlyTargetType.BattleBox,
scale=0.7,
needRandom=false,
flyEndScale=0.7,
flyFlag="battle_box_key",
}
table.insert(a,e)
local e={itemFlyEvent=CommonEventId.OnBattleShowBoxFly,flyContentArr=a}
EventSystem.SendEvent(CommonEventId.OnBattleShowBoxFly,e)
end
function OnBattleHeroDeath(e)
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end

local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if a then
local o=a:GetPos()
n[o]=false
local t=r[ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex]
if t and e then
if t[e]and t[e].finish==false then
t[e].finish=true
local t=t[e].itemDatas
for i=1,#t do
local i=t[i]
local a=a:GetMiddlePointPos()
if a then
local t=GetFreeBoxTargetPositonIndex(o)
if t then
GenBox(t,i,a,selfEnv["box_pos_"..t].position)
else
GameInit.LogError("BattleBoxPage  没有位置放宝箱了：%s ",e)
end
end
end
end
end
end
end
function OnEventBattleEnd(t)
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end
for a,t in pairs(e)do
local a=a
local t=t
if t.state~=o.Finish then
t.state=o.Finish
local t=t.boxTran
t:DOKill()
showFlyBoxAction(t.transform.position)
RecycleBoxInstance(t)
e[a]=nil
end
end
end
function OnEventBattleNextWaveEnemy(e)
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end
ResetDataInNewWave()
end
function GetFreeBoxTargetPositonIndex(t)
local a={}
local t=l[t]
if t then
for a=1,#t do
local t=t[a]
if CheckBoxPointOpen(t)then
if e[t]==nil then
return t
end
end
end
else
for o,t in pairs(d)do
for o=1,#t do
local t=t[o]
if CheckBoxPointOpen(t)then
if e[t]==nil then
table.insert(a,t)
end
end
end
end
local e=RandomTable(a,1)
return e[1]
end
end
function CheckBoxPointOpen(e)
if e==nil then
return false
end
local e=u[e]
if e then
for t=1,#e do
local e=e[t]
if n[e]==true then
return false
end
end
end
return true
end 
