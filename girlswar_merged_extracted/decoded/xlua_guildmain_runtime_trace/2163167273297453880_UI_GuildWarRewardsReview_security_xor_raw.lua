local e=ModulesInit.CSGuildWarManager
local e=e:GetGuildWarDBCfg()
function OnInit(e,e)
bg.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarRewardsReview)
end)
button.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarRewardsReview)
end)
end
function OnOpen(t)
local t=e.showAward
for e=1,#t do
local t=t[e]
local e=UIUtil.GetChild(Content,e-1)
if not e then
e=LuaUtils.Instantiate(itemCell90)
LuaUtils.SetParent(e,Content)
LuaUtils.SetLocalScale(e,1,1,1)
end
LuaUtils.SetActive(e,true)
local a=LuaUtils.GetLuaComBinder(e)
local i=a:GetComponents()
local a=t[1]
local o=t[2]
local n=t[3]/10000*100
local t={
thingDid=a,
offset=45,
}
UIUtil.SetItemCell(e,{itemDid=a,count=o},t)
LuaUtils.SetTextMeshText(i['text_level'],string.format('%d%%확률',n))
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

