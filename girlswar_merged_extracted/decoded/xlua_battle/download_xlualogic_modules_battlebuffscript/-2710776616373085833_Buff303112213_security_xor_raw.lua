local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t=t[1]
if type(t)=="table"then
e.CurrHeroCtrl:SetHpChainData(t)
end
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t=t[1]
if type(t)=="table"then
e.CurrHeroCtrl:ClearHpChainData(t)
end
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetDefHero(e)
if e==nil or e.CurrHeroCtrl==nil then
return nil
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMaxHpPercentWithCount,1)
if e and#e>0 then
return e[1]
end
return nil
end
function e.OnHpChainShared(e,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=e:GetBuffData()
if t==nil then
return
end
local a=t[2]
t[2]=0
if a and a>0 then
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,a)
end
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
return o

