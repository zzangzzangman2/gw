local e=ModulesInit.CSGuildWarManager:GetGuildWarDBCfg()
function OnInit(e,e)
bg.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBoxRewardGet)
end
)
btn_queren.onClick:AddListener(
function()
ModulesInit.CSGuildWarManager:SendGuildWarGetNoFitstBoxRequest()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBoxRewardGet)
end
)
LuaUtils.SetActive(item,false)
end
function OnOpen(e)
local t=ModulesInit.CSGuildWarManager.GuildWarStatusInfo.myBoxes
LuaUtils.SetChildrenActive(grid,false)
for e=1,#t do
local t=t[e]
local e=UIUtil.GetChild(grid,e-1)
if not e then
e=LuaUtils.Instantiate(item)
LuaUtils.SetParent(e,grid)
LuaUtils.SetLocalScale(e,1,1,1)
end
LuaUtils.SetActive(e,true)
LuaUtils.SetChildLabelText(e,'text',TimeUtil.TimestampToyyyyMMdd(t.time))
if t.myScore==0 then
LuaUtils.SetChildLabelTextWrap(e,"text2"," <color=red>0")
else
local t=t.myScore/15
LuaUtils.SetChildLabelTextWrap(e,"text2",string.format(" <color=green>%s%%",UIUtil.FormatNum(math.floor(t*100))))
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

