local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,a)
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43088)
local o=0
if(a~=nil)then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
if#e==1 then
o=a.buffData[2]
end
end
if(t.CurrHeroCtrl:CurrHPPer()>e[1]*MillionCoe)then
if(e[2]>=RandomMgr:GetBattleRandom())then
local a=e[3]*(1+o*MillionCoe)
t.CurrHeroCtrl:AddFuryWithSkill(e[3])
end
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

