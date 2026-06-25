local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
local i=43260
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local t=nil
local a=43264
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
t=e:GetBuffData()
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
i.CheckAddBuffFluttering(o,t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.Explode(e)
end
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

