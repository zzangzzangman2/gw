local e=1
local a=require("DataNode/DataManager/DataMgr/DataUtil")
local e={
BattleBuffs={}
}
local o=e
function e.Init()
for t=1,7 do
local t="Modules/BattleBuffScript/BattleBuffData"..t
local t=require(t)
t.Init()
local t=t.BattleBuffs
for a,t in pairs(t)do
e.BattleBuffs[a]=t
end
end
end
function e.GetBuffScript(e)
local t=a:GetBuffCfg(e)
if(t==nil)then
GameInit.LogError("buff 数据不存在 buffId=%s",e)
end
local t=o.BattleBuffs[t.scriptId]
if(t==nil)then
GameInit.LogError("GetBuffScript is nil buffId=%s",e)
end
return t
end
return e 
