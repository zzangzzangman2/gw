local s=require("Modules/Battle/BattleUtil")
local e={}
local n=e
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
function e.DoActionBigSkill(t)
local e=t:GetBuffData()
local a=e[1]
local o=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=303110503
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=e[9]
local o=e[10]
local i={e[11],e[12]}
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,a,o,i,e)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fMostDebuff)
if a~=nil then
a.HeroBattleInfo:DispelGranBuff(false,e[13],true)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local t=s:GetMaxFuryHeroArrByHeroArr(t,e[14])
for a=1,#t do
if t[a]:IsFullFury()==false then
t[a]:AddFuryWithBuff(e[15])
end
end
end
return n

