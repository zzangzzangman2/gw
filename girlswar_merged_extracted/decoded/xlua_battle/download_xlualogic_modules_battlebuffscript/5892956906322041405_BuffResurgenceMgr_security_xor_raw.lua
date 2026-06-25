local s=require("DataNode/DataManager/DataMgr/DataUtil")
local n={}
local t={
303111004,
60062,30104301,3053,30221,30109903,30106115,
30106609,30106419,30106712,302101503,302101219,
302107711,302107820,302107521,302104301,302108222,
302108318,302108416,302108509,302108909,303101503,
303110616,303110705,303110913,303111112,303111214,
303111317,303111509,303111714,303104420,303111805,
303111912,303112016,303101219,303112107,
92191,
308200202,
}
function n.DoResurgence(e,a,h,n)
if e==nil or e.CurrHeroCtrl==nil or a==nil then
return
end
if e.CurrHeroCtrl:IsNothingToDoState()then
return
end
for a=1,#t do
if e.CurrHeroCtrl:IsLiveAgainState()then
return
end
local o=t[a]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if t and t.isExec==false then
local i=t:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local o=s:GetBuffCfg(o)
if a.DoResurgence and e.CurrHeroCtrl.ImmuneResurgence<=o.triggleLevel then
if a.CheckCondition==nil or a.CheckCondition(t,i)then
e.CurrHeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmgCheckSuccess)
e.CurrHeroCtrl:CheckExcuteWillHeroSpecialState(BuffTriggerTime.fatalDmgCheckSuccess)
if e.CurrHeroCtrl:IsNothingToDoState()then
return
end
e.CurrHeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enterUnUsualStateBefore,nil,nil,{buffTriggerTime=BuffTriggerTime.fatalDmg})
a.DoResurgence(t,i,h,n)
end
end
end
end
end
return n

