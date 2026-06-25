local a=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionForBigSkill(t,e)
local i=RandomMgr:GetBattleRandomWithRange(e[1],e[2])
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=RandomTableWithSeed(o,i)
local i=math.floor(t.CurrHeroCtrl:GetFinalAtk()*e[3]*MillionCoe)
for n=1,#o do
local o=o[n]
o:RealHurtWithBuff(i,t)
local e=math.floor(i*e[4]*MillionCoe)
a:AddSepsisHp(t.CurrHeroCtrl,o,e,true,false)
end
local a=a:GetEnemySepsisCount(t.CurrHeroCtrl)
local a=a
local s=e[5]
local o=e[6]
local n={e[7],e[8]}
local i=math.min(a,e[9])
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,s,o,n,i)
local o=e[10]
local i=e[11]
local n={e[12],e[13]}
local e=math.min(a,e[14])
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,o,i,n,e)
return
end
return h

