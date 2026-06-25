local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#a do
local o=a[o]
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[1]*MillionCoe)
local i=e.CurrHeroCtrl:GetFinalAtk()
local i=math.floor(i*t[2]*MillionCoe)
a=math.min(a,i)
o:RealHurtWithBuff(a,e)
o:ReduceFuryWithBuffImmediately(t[3])
local a=t[4]
local i=t[5]
local t={t[6],t[7]}
o:AddBuff(e.CurrHeroCtrl,a,i,t)
end
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

