local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
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
function t.DoActionWithKnightSun(a,t)
local e={}
table.insert(e,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
for a=1,#t do
table.insert(e,t[a])
end
local t=a:GetBuffData()
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=t[5]
local n=t[6]
local t=o*t[7]*MillionCoe
local o={t}
for t=1,#e do
e[t]:AddBuff(a.CurrHeroCtrl,i,n,o)
end
end
return i

