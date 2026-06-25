local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=math.floor(e.CurrHeroCtrl:GetFinalAtk()*t[1]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fHollow)
for i=1,#a do
a[i]:ReduceFuryWithBuffImmediately(math.abs(t[2]))
a[i]:RealHurtWithBuff(o,e)
end
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo and e.CurrHeroCtrl:IsNotUsualStateOrType()==false then
e.CurrHeroCtrl:ReduceFuryWithBuffImmediately(math.abs(t[2]))
e.CurrHeroCtrl:RealHurtWithBuff(o,e)
end
e.isExec=true
return{
ret=true
}
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

