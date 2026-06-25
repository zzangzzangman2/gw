local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfColumn)
for o=1,#a do
local i=t[1]
local n=t[2]
local t=math.floor(a[o].HeroBattleInfo.MaxHP*t[3]*MillionCoe)
local t={t}
a[o]:AddBuff(e.CurrHeroCtrl,i,n,t)
end
e.isExec=true
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

