local h=require("Modules/Battle/BattleUtil")
local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now
or a.buffTriggerTime==BuffTriggerTime.addMyMate
or a.buffTriggerTime==BuffTriggerTime.removeMyMate then
local s=t[2]
local i=t[3]
local o={t[4],t[5]}
local a=t[1]
local n=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
local a=h:GetHeroWithProfession(n,a)
local a=#a
a=math.min(a,t[6])
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,s,i,o,a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return r

