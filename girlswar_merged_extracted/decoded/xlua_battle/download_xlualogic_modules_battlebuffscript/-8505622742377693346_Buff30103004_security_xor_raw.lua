local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e.CurrHeroCtrl.appearBattleBigRound+1<=t[7])then
local a=t[1]
local o=t[2]
local t={t[3],t[4],t[5],t[6]}
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if i then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

