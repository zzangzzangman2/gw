local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemy)
if(a==nil)then
return nil
end
if e.CurrHeroCtrl:IsOnAttack()then
local i=t[1]
local n=t[2]
local o=t[3]
local s=e.CurrHeroCtrl:GetFinalAtk()
local t=math.floor(s*t[4]*MillionCoe)
local t={t}
a:CheckAddBuff(i,e.CurrHeroCtrl,n,o,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

