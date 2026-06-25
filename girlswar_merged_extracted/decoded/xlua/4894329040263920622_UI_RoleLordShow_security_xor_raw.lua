local e=require("DataNode/DataTable/Create/player/DTProfileDBModel")
local s=require("DataNode/DataManager/DataMgr/DataUtil")
local t=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local n=require('DataNode/DataTable/Create/constant/DTBattleAttrDBModel')
local a=nil
local o=nil
function OnInit(e,e)
btn_fanhui.onClick:AddListener(closeUI)
end
function OnOpen(e)
refreshView(e.lordId)
end
function OnClose()
UnLoadSelfHeroSpine()
end
function OnBeforeDestroy()
end
function UnLoadSelfHeroSpine()
UIUtil.SpinePoolDespawnAll(a,o)
a=nil
o=nil
end
function refreshView(t)
UnLoadSelfHeroSpine()
local e=e.GetEntity(t)
LuaUtils.SetTextMeshText(text_name,GameTools.GetLocalize(e.profileName,LanguageCategory.LangCommon))
local t=e.profileAttr[1]
local i=e.profileAttr[2]
local n=n.GetEntity(t)
LuaUtils.SetTextMeshText(text_attr,GameTools.GetLocalize(n.attrName,LanguageCategory.LangBattle)..string.format("+%s",s:clientAttrShowValue(t,i)))
local t=nil
if PlayerMgr:GetProfileType(e)==ELordProfileType.LordProfile then
t=e.profile
else
local e=HeroMgr:GetHeroCfgData(e.profile)
t=e.modelID
end
DynamicModuleRes.CheckResAndDownload({
[1]={t},
},function()
UIUtil.GetPlayerBigSpineAll(t,trans_spine,"teamPara",function(t,e)
a=t
o=e
end)
end)
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_RoleLordShow)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

