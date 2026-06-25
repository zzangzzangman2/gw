local t=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local e=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local i=require('DataNode/DataTable/Create/skillAct/DTSkillActDBModel')
local s=require('DataNode/DataTable/Create/skillAct/DTSkillPasDBModel')
local n=require('Modules/Battle/BattleTimelineResMap')
local e={}
e.asyncPreloadDict={}
e.isOpenAppVer="1.0.0"
e.isCanUse=false
e.timeLineMp4List={}
function e:Init()
e.isCanUse=BuildPatchMgr:CompareVersion(GameEntry.AppVer,e.isOpenAppVer)>=0
end
function e:GetHeroSkillIds(e)
local e=t.GetEntity(e)
local t={}
if e==nil then return t end
for a=1,5 do
local e=i.GetEntity(e["skill"..a])
t[e.prefabId]=true
end
for a,o in ipairs(e.skillAwakeType)do
if o==PROTO_ENUM.SkillType.ACTIVE then
local e=i.GetEntity(e.skillAwake[a])
t[e.prefabId]=true
elseif o==PROTO_ENUM.SkillType.PASSIVE then
local e=s.GetEntity(e.skillAwake[a])
t[e.prefabId]=true
end
end
return t
end
function e:GetSkillPrefabAllRes(t)
local e={}
e[t]=true
local t=LuaUtils.GetSysprefabData(t)
if t then
local t=n[t.AssetPath]
if t then
for a,t in ipairs(t.prefab or{})do
e[t]=true
end
end
end
local e=table.keys(e)
return e
end
function e:AsyncPreloadSelfAllRes(t)
if not e.isCanUse then return end
for a,t in ipairs(t or{})do
local t=e:GetHeroSkillIds(t)
for t,a in pairs(t or{})do
e:AsyncPreloadSkillAllRes(t)
end
end
end
function e:AsyncPreloadSkillAllRes(t,a)
if not e.isCanUse then return end
if ModulesInit.ProcedureNormalBattle.IsSkipBattle then
return
end

if a==nil then a=false end
local o=e:GetSkillPrefabAllRes(t)
CS.YouYou.AsyncLoadManager.AddAsyncLoadTasks(o,a,tostring(t))
e.asyncPreloadDict[tostring(t)]=true
end
function e:PlaySkillPrefabAndRemoveAsyncPreload(t,a)

if not e.isCanUse then
a()
return
end
if ModulesInit.ProcedureNormalBattle.IsSkipBattle or t==nil or t==0 then
a()
return
end
local o
local i=0
local s=LuaUtils.GetSysprefabData(t)
if s then
local e=n[s.AssetPath]
if e then
for t,e in ipairs(e.video or{})do
o=e
i=i+1
end
end
end
if o and i==1 then

local i=false
local n=false
CS.YouYou.GameEntry.Video:PrepareVideo(o,function()
if not e.isCanUse then
e:RemoveAsyncLoadTasks(t)
a()
else
if n==false then
i=true
e:RemoveAsyncLoadTasks(t)
a()
end
end
end)
if e.isCanUse then
local o=CS.DG.Tweening.DOTween.Sequence()
if BuildPatchMgr:CompareVersion(GameEntry.AppVer,"1.0.9")>=0 then
o:AppendInterval(0.5)
else
o:AppendInterval(0.1)
end
o:AppendCallback(
function()
if i==false then
n=true
e:RemoveAsyncLoadTasks(t)
a()
end
end
)
end
ErrInfoCollectMgr:AddInfo("[AVProVideo] Error","PrepareVideo",o)
else
e:RemoveAsyncLoadTasks(t)
a()
end
end
function e:RemoveAsyncLoadTasks(t)
if not e.isCanUse then return end
if e.asyncPreloadDict[tostring(t)]then
CS.YouYou.AsyncLoadManager.RemoveAsyncLoadTasks(tostring(t))

end
end
function e:ClearAll()
if not e.isCanUse then return end
CS.YouYou.AsyncLoadManager.ClearAll()
e.asyncPreloadDict={}
end
function e:PreloadMp4(a,t)
e.timeLineMp4List={}
local a=LuaUtils.GetSysprefabData(a)
if a then
local t=n[a.AssetPath]
if t then
e.timeLineMp4List=table.deepCopy(t.video)
end
end
if#e.timeLineMp4List>1 then
local a=e.timeLineMp4List[1]
table.remove(e.timeLineMp4List,1)
local t=function()
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect:Resume()
t()
end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect:Pause()
CS.YouYou.GameEntry.Video:PrepareVideo(a,function()
if not e.isCanUse then
t()
end
end)
if e.isCanUse then
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.1)
e:AppendCallback(
function()
t()
end
)
end
else
e.timeLineMp4List={}
t()
end
end
function e:checkPreloadMp4()
if ModulesInit.ProcedureNormalBattle.IsSkipBattle or ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
if#e.timeLineMp4List>0 then
local t=e.timeLineMp4List[1]
table.remove(e.timeLineMp4List,1)
CS.YouYou.GameEntry.Video:Stop()
GameTools:PlayUIVideo(CS.YouYou.GameEntry.Video,t)
end
end
if(GameInit.IsClient)then
e:Init()
end
return e 
