local e=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,o,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.IsOurHero==e.CurrHeroCtrl.IsOurHero and t.HeroId~=e.CurrHeroCtrl.HeroId then
if a[1]>=RandomMgr:GetBattleRandom()then
local o=1922101
local o=e.CurrHeroCtrl:GetTeamId()
local t=t:GetFinalAtk()
local t=math.floor(t*a[2]*MillionCoe)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle2511TreasureDamageEffect,e.x,e.y,50,3,0,false,function()
end)
end
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

