local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(e.CurrHeroCtrl,BattleHeroType.all,t[1])
if#a>0 then
if t[3]==nil then
t[3]=1
elseif t[2]~=nil and t[2]>0 then
e.CurrHeroCtrl:AddFuryWithSkill(t[2])
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

