local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,a,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t==BuffRemoveType.Rout then
local t=302107909
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.EnergyDamageInExhaust(e)
end
end
end
function t.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.energy,t[1])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a.RefreshEnergyBar(e)
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
function t.AddEnergy(e,o)
local t=e:GetBuffData()
local i=e.CurrHeroCtrl.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t[1]=i+o
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,HeroAttrId.energy,t[1])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a.RefreshEnergyBar(e)
end
function t.RefreshEnergyBar(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
e.CurrHeroCtrl:SetRageBar(a,t[2])
end
end
return a

