local i=require("Modules/Battle/BattleUtil")
local t=nil
function OnInit(e)
end
function OnOpen(e)
LuaUtils.SetChildrenActive(rootTrans.transform,false)
LuaUtils.SetActive(UI_TreasureItem.transform,false)
end
function OnClose()
LuaUtils.SetChildrenActive(rootTrans.transform,false)
LuaUtils.SetActive(UI_TreasureItem.transform,false)
StopDelaySequence()
end
function OnBeforeDestroy()
end
function OnRefresh(o)
local function n(a,t)
local e=UIUtil.GetChild(rootTrans.transform,t-1)
if not e then
e=LuaUtils.Instantiate(UI_TreasureItem.transform)
LuaUtils.SetParent(e.transform,rootTrans.transform)
LuaUtils.SetLocalPos(e.transform,-(t-1)*20-100,-(t-1)*30,0)
end
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
local a=i:GetTreasureCfgData(a.treasureDid)
LuaUtils.SetImageSprite(t["img_icon"],a.icon,true)
LuaUtils.SetImageSprite(t["img_icon_bg"],i:GetTreasureBattleBg(a.color),true)
LuaUtils.SetImageSprite(t["img_name"],a.battleName,true)
return e
end
LuaUtils.SetChildrenActive(rootTrans.transform,false)
StopDelaySequence()
local e=CS.DG.Tweening.DOTween.Sequence()
for a=1,#o do
local t=o[a]
if t.treasureDid>0 then
local t=n(t,a)
if a>1 then
e:AppendInterval(0.15)
end
e:AppendCallback(function()
LuaUtils.SetActive(t.transform,true)
local e=LuaUtils.GetLuaComBinder(t.transform)
local e=e:GetComponents()
local e=e["root"].gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
LuaUtils.AnimtorPlay(e,"battle_treasure_word_up",0,0)
end)
end
end
t=e
end
function StopDelaySequence()
if t~=nil then
t:Kill()
t=nil
end
end 
