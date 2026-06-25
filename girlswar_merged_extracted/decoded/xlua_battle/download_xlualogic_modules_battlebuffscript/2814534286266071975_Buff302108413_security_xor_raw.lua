local e={}
local h=e
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
function e.DoActionSmallSkill(t)
local e=t:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
if#a>e[1]then
local o=e[2]
local n=e[3]
local s={e[4],e[5]}
local i=o
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.AddShield(a,e[4])
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,s)
end
end
end
return h

