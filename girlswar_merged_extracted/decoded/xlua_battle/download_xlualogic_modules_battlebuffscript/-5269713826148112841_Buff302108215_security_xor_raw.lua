local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuff(e.buffId)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneDebuff()
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local t=#t
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2]*t)
elseif t.buffTriggerTime==BuffTriggerTime.skillPlay
or t.buffTriggerTime==BuffTriggerTime.skill2Play
or t.buffTriggerTime==BuffTriggerTime.skill3Play then
local t=302108211
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddKingPercent(e,a[3],"kv_a_battle_state_skillPlay")
end
elseif t.buffTriggerTime==BuffTriggerTime.attacked then
local t=302108211
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddKingPercent(e,a[4],"kv_a_battle_state_attacked")
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

