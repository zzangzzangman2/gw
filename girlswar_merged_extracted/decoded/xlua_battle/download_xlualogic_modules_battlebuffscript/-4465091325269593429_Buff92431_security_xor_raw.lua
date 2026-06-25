local s=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.attacked then
local a=t[8]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
local o=t[1]
local i=t[2]
local t={t[3],t[4]}
a:AddBuff(e.CurrHeroCtrl,o,i,t)
end
elseif o.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
local a=t[8]
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if o==nil then
return
end
local i=92430
local a=o.HeroBattleInfo:GetBuff(i)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
if i.CheckCondition(a)then
if s:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local n=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local n=math.floor(n*t[5]*t[6]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(n,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
o:AddFuryWithBuffImmediately(t[7])
i.RecordCanImmuneDead(a)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckCondition(e)
local e=e:GetBuffData()
local e=e[8]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e==nil then
return false
end
local t=92430
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if t.CheckCondition(e)==false then
return false
end
end
return true
end
function a.ShowTreasure(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle259TreasureImmuneDeadEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
return n

