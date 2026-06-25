local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneControlBuff(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneControlBuff()
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
local a=302110405
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local a=a.GetWineFumeBuffData(o)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2]*t[3])
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
return i

