local e=Class("UI_MainPageActItem",{})
local i=require("DataNode/DataManager/DataMgr/ActCfgData")
function e:Create(t,a)
local e=e:New()
e:Init(t,a)
return e
end
function e:Init(e,t)
self._trans=e
self._actId=0
self._isSelect=false
self._mModelTrans=nil
self._mModelPrefabId=0
self._mLoadingModelPrefabId=0
self._mRedPointTrans=nil
self._mRedPointPrefabId=0
self._mLoadingRedPointPrefabId=0
self._actInfo=nil
self._timer=nil
self._timer2=nil
self._mIsGray=false
local e=LuaUtils.GetLuaComBinder(self._trans.transform)
self._bicoms=e:GetComponents()
self._bicoms["btn_act"].onClick:AddListener(function(e)
local e=self._actId
if self._actInfo and self._actInfo.systemId==nil then
local t=i[self._actId]
if t and t.mainPageTouchJumpId then
e=t.mainPageTouchJumpId()
end
end
if ActMgr:IsInRallyActivity(e)~=0 then
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_ACTICON_SUC"})
UIUtil.forceShowUI(UIFormId.UI_ActRallyRoot,{actId=e})
else
ActMgr:CheckJumpViewById(e,{isOpenFrame=true})
end
end)
end
function e:OnClose()
self:RemoveModel()
self._mLoadingModelPrefabId=0
end
function e:SetTouchCallback(e)
self._callback=e
end
function e:Refresh(t)
self._actInfo=t
self:SetActId(t.actId)
local o=t.tbSpine
local a=GameTools.GetLocalize(t.name,LanguageCategory.LangCommon)
local e=i[self._actId]
if t.systemId~=nil then
if e and self._actId~=301 and e.getActNewName then
a=e.getActNewName()
else
a=ActMgr:GetActivityBaseName(t.systemId)
end
else
if e and self._actId~=301 and e.getActNewName then
a=e.getActNewName()
elseif e and e.mainPageName then
a=GameTools.GetLocalize(e.mainPageName,LanguageCategory.LangCommon)
end
if e and e.mainPageSpineId then
o=t.mainPageSpineId
end
end
self:CheckRefreshSpine(o)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_name"],a)
self:RefreshRedPoint()
end
function e:UpdateFaceGiftBtnStage(e)
end
function e:SetActive(e)
LuaUtils.SetActive(self._trans.transform,e)
end
function e:RefreshRedPoint()
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,false)
LuaUtils.SetActive(self._bicoms["root_red_special"].transform,false)
local e=ActMgr:CheckSpeicalRedPoint(self._actId)
if e==nil then
if self._actId==5 then
local t=false
local e=false
if not RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MONTH_SIGN)then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MONTH_SIGN_AGAIN)then
LuaUtils.SetActive(self._bicoms["root_red_special"].transform,true)
self:CheckRefreshSpecialRedPoint(110000001)
LuaUtils.SetLocalPos(self._bicoms["root_red_special"].transform,0,0,0)
t=true
end
else
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,true)
e=true
end
if not t and not e then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.TEN_DAY_ACTIVE_RED)then
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,true)
end
end
else
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,ActMgr:CheckRedPoint(self._actId,true,true))
end
else
LuaUtils.SetActive(self._bicoms["root_red_special"].transform,true)
self:CheckRefreshSpecialRedPoint(e.prefabId)
local e=e.posOffset or{x=0,y=0}
LuaUtils.SetLocalPos(self._bicoms["root_red_special"].transform,e.x,e.y,0)
end
end
function e:SetActId(e)
self._actId=e;
end
function e:GetActId()
return self._actId;
end
function e:CheckRefreshSpine(e)
if self._mModelTrans==nil or(self._mModelPrefabId==0)or(self._mModelPrefabId~=e)then
self._mLoadingModelPrefabId=e
local t=self._bicoms["spine_root"].transform
local o={
scale=1,
animName="A",
}
UIUtil.GetSpinePrefabFromPool(e,function(a,i,i)
if self._mLoadingModelPrefabId~=e then
return
end
self._mLoadingModelPrefabId=0
self:RemoveModel()
self._mModelPrefabId=e
self._mModelTrans=a
self:CheckSetSpineGray()
UIUtil.HandlePoolSpinePrefab(self._mModelTrans,t,o)
LuaUtils.SetLocalPos(self._mModelTrans,0,0,0)
self:RefreshModel()
end)
else
self:RefreshModel()
end
end
function e:RefreshModel()
local e=self._mModelTrans:GetComponent(typeof(CS.YouYou.UISpineCtr))
if self._actId==ModulesInit.FaceGiftManager.ACT_ID then
local t,a=ModulesInit.FaceGiftManager:GetEnterShowGift()
if t then
if a>1 then
if ActMgr:CheckRedPoint(self._actId,true,true)then
e:PlayAnimation(0,"0_C",true)
else
e:PlayAnimation(0,"0_B",true)
end
else
local t=ModulesInit.FaceGiftManager:GetGiftCfg(t.giftDid)
local t=t.mainIcon
if ActMgr:CheckRedPoint(self._actId,true,true)then
e:PlayAnimation(0,string.format("%d_C",t),true)
else
e:PlayAnimation(0,string.format("%d_B",t),true)
end
end
end
else
if ActMgr:CheckRedPoint(self._actId,true,true)then
e:PlayAnimation(0,"C",true)
else
e:PlayAnimation(0,"B",true)
end
end
end
function e:RemoveModel()
if self._mModelTrans~=nil then
UIUtil.SpinePoolDespawn(self._mModelTrans)
self._mModelTrans=nil
self._mModelPrefabId=0
end
LuaUtils.DestroyChildren(self._bicoms["spine_root"].transform)
end
function e:CheckRefreshSpecialRedPoint(e)
if self._mRedPointTrans==nil
or(self._mRedPointPrefabId==0)
or(self._mRedPointPrefabId~=e)
then
self._mLoadingRedPointPrefabId=e
local a=self._bicoms["root_red_special"].transform
local t={
scale=1,
animName="A",
}
UIUtil.GetSpinePrefabFromPool(e,function(o,i,i)
if self._mLoadingRedPointPrefabId~=e then
return
end
self._mLoadingRedPointPrefabId=0
self:RemoveRedPointModel()
self._mRedPointPrefabId=e
self._mRedPointTrans=o
UIUtil.HandlePoolSpinePrefab(self._mRedPointTrans,a,t)
LuaUtils.SetLocalPos(self._mRedPointTrans,0,0,0)
self:RefreshRedPointModel()
end)
else
self:RefreshRedPointModel()
end
end
function e:RefreshRedPointModel()
local e=self._mRedPointTrans:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:PlayAnimation(0,"A",true)
end
function e:RemoveRedPointModel()
if self._mRedPointTrans~=nil then
UIUtil.SpinePoolDespawn(self._mRedPointTrans)
self._mRedPointTrans=nil
self._mRedPointPrefabId=0
end
LuaUtils.DestroyChildren(self._bicoms["root_red_special"].transform)
end
function e:CheckSetSpineGray()
end
function e:SetSpineGray(e)
self._mIsGray=e
end
function e:DoSetSpineGray(e)
if self._mModelTrans~=nil then
UIUtil.SetSpineRenderGray(self._mModelTrans,e)
end
end
function e:SetRedPointGray(e)
UIUtil.SetGray(self._bicoms["im_qipao1"].transform,e)
end
return e 
