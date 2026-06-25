local e=Class("BattleClientField")
function e:Create(t)
local e=e:New()
e:Init(t)
return e
end
function e:Init(e)
self.mBattleClientMgr=e
self.FireEffectTrans=nil
self.FireEffectFocusTrans=nil
self.CameraCtrlOldPos=nil
self.CameraCtrlOriginalOrthographicSize=OG_DESIGN_SIZE*OGAdjustSizeRate
self.CameraCtrlCurrOrthographicSize=self.CameraCtrlOriginalOrthographicSize
self.OnePixelRatio=1
end
function e:LoadInitRes()
self:LoadFireEffect()
self:LoadMaps()
end
function e:LoadFireEffect()
GameTools:PoolGameObjectSpawn(
SysPrefabId.FireEffect,
nil,
function(e,t,t)
self.FireEffectTrans=e
self.FireEffectTrans.position=Vector3(0,10000,0)
end
)
GameTools:PoolGameObjectSpawn(
SysPrefabId.FireEffectFocus,
nil,
function(e,t,t)
self.FireEffectFocusTrans=e
LuaUtils.SetActive(self.FireEffectFocusTrans,false)
end
)
end
function e:UnLoadFireEffect()
if(self.FireEffectTrans~=nil)then
GameEntry.Pool:GameObjectDespawn(self.FireEffectTrans)
self.FireEffectTrans=nil
end
if(self.FireEffectFocusTrans~=nil)then
GameEntry.Pool:GameObjectDespawn(self.FireEffectFocusTrans)
self.FireEffectFocusTrans=nil
end
end
function e:LoadScene()
GameEntry.Scene:LoadScene(
SysSceneId.GameScene_NormalBattle,
false,
function()
self:CameraCtrlReset()
self:RecordCameraCtrl()
GameEntry.UI:OpenUIForm(UIFormId.UI_Global)
self:LoadMaps()
end
)
end
function e:CameraCtrlReset()
if IsNil(GameEntry.CameraCtrl)then
return
end
CameraMgr:SetCameraPosition(CameraMgr.ESceneType.NormalBattle,Vector3(0,0,-50))
CameraMgr:SetCameraLocalEulerAngles(CameraMgr.ESceneType.NormalBattle,Vector3.zero)
GameEntry.CameraCtrl:ResetMainCameraPos()
CameraMgr:SetCameraOrthographic(CameraMgr.ESceneType.NormalBattle,true)
CameraMgr:SetCameraOrthographicSize(CameraMgr.ESceneType.NormalBattle,OG_DESIGN_SIZE*OGAdjustSizeRate)
end
function e:RecordCameraCtrl()
self.CameraCtrlOldPos=GameEntry.CameraCtrl.transform.position
self.CameraCtrlOriginalOrthographicSize=OG_DESIGN_SIZE*OGAdjustSizeRate
self.CameraCtrlCurrOrthographicSize=self.CameraCtrlOriginalOrthographicSize
local e=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(Vector3.zero)
e=e+Vector3(1,0,0)
local e=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(e)
self.OnePixelRatio=e.x
end
function e:LoadMaps()
local e=0
local t=self.mBattleClientMgr:GetBattleViewData()
if t then
e=t.mapPrefabId or 0
end
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,e,e)
end
)
end
function e:LoadTeam()
end
return e 
