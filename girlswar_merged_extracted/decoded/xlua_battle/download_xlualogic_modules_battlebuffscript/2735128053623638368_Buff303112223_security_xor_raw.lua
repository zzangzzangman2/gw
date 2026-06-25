local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionPerEmptyMarkExplode(e,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil or a<=0 then
return
end
if t==nil or t<=0 then
return
end
local e=e.CurrHeroCtrl
local o=e.HeroBattleInfo.MaxHP
local t=math.floor(o*t*MillionCoe)*a
if t<=0 then
return
end
local o=303112221
local a=e.HeroBattleInfo:GetBuff(o)
if a==nil then
return
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddBuffMirrorShieldTo(a,e,t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fMinHpPercentWithCount)
if e~=nil and#e>0 then
o.AddBuffMirrorShieldTo(a,e[1],t)
end
end
return i

