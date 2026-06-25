local i=require("Modules/Battle/BattleUtil")
local n=require("DataNode/DataManager/DataMgr/DataUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if ModulesInit.ProcedureNormalBattle.IsPVE()and t[5]==0 then
return false
end
if a.buffHeroId==e.CurrHeroCtrl.HeroId then
local s=a.addBuffId
local a=t[2]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local o=n:GetBuffCfg(s)
if(o.isGran==0)then
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,1)
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[1]*MillionCoe
e.CurrHeroCtrl:RealHurtWithBuff(t,e,nil,nil,nil,nil,{notDead=true})
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

