local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
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
function t.DoActionSmallSkill(a)
local t=a:GetBuffData()
local e=o.GetBigSkillDamageInThisRound(a,t)
if e>0 then
local e=e*t[5]*MillionCoe
local o=t[6]*MillionCoe
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP*o
e=math.max(e,o)
local o=t[7]*MillionCoe
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP*o
e=math.min(e,o)
if a.CurrHeroCtrl.battleStationRow==2 then
e=e*t[8]/t[9]
end
e=math.floor(e)
local o=t[3]
local t=t[4]
local e={e}
a.CurrHeroCtrl:AddBuff(a.CurrHeroCtrl,o,t,e)
end
end
function t.GetBigSkillDamageInThisRound(t,e)
if e[10]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return e[11]
end
return 0
end
function t.SetBigSkillDamageInThisRound(e,t)
local e=e:GetBuffData()
if e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[11]=0
end
e[11]=e[11]+t
end
return o

