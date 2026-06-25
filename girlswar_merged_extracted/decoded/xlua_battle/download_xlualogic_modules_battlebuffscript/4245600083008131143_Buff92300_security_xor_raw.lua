local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[1]==1 or ModulesInit.ProcedureNormalBattle.IsPVE()==false then
local o=t[2]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=a*o
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local o=t[3]
local n=t[4]
local a=0
local i=i.HeroBattleInfo:GetBuff(o)
if i then
local e=i:GetBuffData()
a=e[2]
end
local a=a+t[6]
a=math.min(a,t[7])
local t={t[5],a}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,t)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.teamHeroDead
)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

