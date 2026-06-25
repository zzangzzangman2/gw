local e=Class("UI_MainPageFaceActItem",{})
local o=require("DataNode/DataManager/DataMgr/ActCfgData")
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
self._reqCount=0
local e=LuaUtils.GetLuaComBinder(self._trans.transform)
self._bicoms=e:GetComponents()
self._bicoms["btn_act"].onClick:AddListener(function(e)
local t=self._actId
if self._actInfo and self._actInfo.systemId==nil then
local e=o[self._actId]
if e and e.mainPageTouchJumpId then
t=e.mainPageTouchJumpId()
end
end
ActMgr:CheckJumpViewById(t,{isOpenFrame=true})
end)
end
function e:OnClose()
self:RemoveModel()
self._mLoadingModelPrefabId=0
if self._timer then
self._timer:Stop()
self._timer=nil
end
if self._timer2 then
self._timer2:Stop()
self._timer2=nil
end
self._reqCount=0
end
function e:SetTouchCallback(e)
self._callback=e
end
function e:Refresh(a)
self._actInfo=a
self:SetActId(a.actId)
local i=a.tbSpine
local t=GameTools.GetLocalize(a.name,LanguageCategory.LangCommon)
local e=o[self._actId]
if a.systemId~=nil then
if e.getActNewName then
t=e.getActNewName()
else
t=ActMgr:GetActivityBaseName(a.systemId)
end
else
if e.getActNewName then
t=e.getActNewName()
elseif e and e.mainPageName then
t=GameTools.GetLocalize(e.mainPageName,LanguageCategory.LangCommon)
end
if e and e.mainPageSpineId then
i=a.mainPageSpineId
end
end
LuaUtils.SetTextMeshText(self._bicoms["txt_act_name"],t)
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,false)
self:CheckRefreshSpine(i)
if self._timer then
self._timer:Stop()
self._timer=nil
end
if self._timer2 then
self._timer2:Stop()
self._timer2=nil
end
if self._actId==39 then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=0
for a,t in pairs(ModulesInit.KillDragonsManager.ActGragonGift.gifts)do
if not t.isPay and t.leftTime>TimeUtil.serverMillTimeStamp then
if e==0 then
e=t.leftTime
else
if t.leftTime<e then
e=t.leftTime
end
end
end
end
if e==0 then
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],t)
else
self._timer=ModulesInit.TimeActionMgr:CreateTimeAction()
local e=math.floor(e/1000)-TimeUtil.serverTimeStep
if e<=0 then
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],t)
else
self._timer:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
end
end
elseif self._actId==52 then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=ModulesInit.ThroughGiftManager:GetNewGift()
if e then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
local e=e.endSecond-TimeUtil.serverTimeStep
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
end
elseif self._actId==106 then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=ModulesInit.ThroughGift2Manager:GetNewGift()
if e then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
local e=e.endSecond-TimeUtil.serverTimeStep
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
end
elseif self._actId==41 then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=ModulesInit.ActEighteenGiftMgr.giftEndTime
if e and e>0 then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
local e=e-TimeUtil.serverTimeStep
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
else
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end
elseif self._actId==ModulesInit.FaceGiftManager.ACT_ID then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
self:UpdateFaceGiftBtnStage(t)
elseif self._actId==ModulesInit.FullServerBattleMgr.ACT_GIFT_BAG_ID then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=ModulesInit.FullServerBattleMgr.giftBagEndTime-TimeUtil.serverTimeStep
if e>0 then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
else
if self._reqCount==0 then
NetManager.SendEmpty(ProtoId.PRT_FSB_GIFT_INFO_REQ)
self._reqCount=1
end
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end
elseif self._actId==ModulesInit.FullServerBattleYearMgr.ACT_GIFT_BAG_ID then
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
local e=ModulesInit.FullServerBattleYearMgr.giftBagEndTime-TimeUtil.serverTimeStep
if e>0 then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
else
if self._reqCount==0 then
NetManager.SendEmpty(ProtoId.PRT_FSBY_GIFT_INFO_REQ)
self._reqCount=1
end
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end
else
LuaUtils.SetActive(self._bicoms["txt_act_leftTime"].transform,true)
if e.showLeftTimeInMainPage==true then
local t=ActMgr:GetActServerData(self._actId)
local e=0
if t then
e=t.closeSecond
end
if e and e>0 then
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
local e=e-TimeUtil.GetServerTimeStamp()
self._timer2:Init(0,1,e,nil,function(e)
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.toDHMSStr2(e))
end,function()
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end):Run()
else
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end
else
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],"")
end
end
self:RefreshRedPoint()
end
function e:UpdateFaceGiftBtnStage(e)
if self._timer2 then
self._timer2:Stop()
self._timer2=nil
end
self._timer2=ModulesInit.TimeActionMgr:CreateTimeAction()
self._timer2:Init(0,1,-1,nil,function(e)
local e,t=ModulesInit.FaceGiftManager:GetEnterShowGift()
if e then
local e=e.endTimestamp-TimeUtil.serverTimeStep
if e>0 then
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],TimeUtil.TimestampToDate2(e))
else
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],'')
end
else
LuaUtils.SetTextMeshText(self._bicoms["txt_act_leftTime"],'')
end
end):Run()
end
function e:SetActive(e)
LuaUtils.SetActive(self._trans.transform,e)
end
function e:RefreshRedPoint()
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,false)
LuaUtils.SetActive(self._bicoms["root_red_special"].transform,false)
local e=ActMgr:CheckSpeicalRedPoint(self._actId)
if e==nil then
LuaUtils.SetActive(self._bicoms["im_qipao1"].transform,ActMgr:CheckRedPoint(self._actId,true,true))
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
local a=self._bicoms["spine_root"].transform
local t={
scale=1,
animName="A",
}
UIUtil.GetSpinePrefabFromPool(e,function(o,i,i)
if self._mLoadingModelPrefabId~=e then
return
end
self._mLoadingModelPrefabId=0
self:RemoveModel()
self._mModelPrefabId=e
self._mModelTrans=o
self:CheckSetSpineGray()
UIUtil.HandlePoolSpinePrefab(self._mModelTrans,a,t)
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
local t=self._bicoms["root_red_special"].transform
local o={
scale=1,
animName="A",
}
UIUtil.GetSpinePrefabFromPool(e,function(a,i,i)
if self._mLoadingRedPointPrefabId~=e then
return
end
self._mLoadingRedPointPrefabId=0
self:RemoveRedPointModel()
self._mRedPointPrefabId=e
self._mRedPointTrans=a
UIUtil.HandlePoolSpinePrefab(self._mRedPointTrans,t,o)
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
