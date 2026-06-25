local e=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
local a=t[5]
local n=t[6]
local i={}
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local e=o:GetBuffData()
e[3]=t[9]
e[4]=t[10]
e[5]=t[11]
else
for a=7,11 do
table.insert(i,t[a])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,n,i)
end
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.SearchAndAddTargetBuffLoveInspiring(e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

