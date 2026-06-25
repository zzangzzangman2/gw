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
function e.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,a,e[1],EBattleSrcType.SkillSmall,true)
local a=302108306
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddLickBlood(o,e[2])
end
local a=e[3]
local o=e[4]
local e={e[5],e[6],e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return i

