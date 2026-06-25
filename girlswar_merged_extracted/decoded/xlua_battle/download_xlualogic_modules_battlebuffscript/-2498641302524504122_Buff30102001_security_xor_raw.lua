local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.OnRemoveSelf(e,t)
if t==nil or#t<9 then
return
end
local e=t[4]
if e then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroId~=0 and e.HeroBattleInfo then
local a=t[5]
if a and a>0 then
e:AddFuryWithBuff(a)
end
local a=t[6]
local o=t[7]
local n={t[8]}
local i=e.HeroBattleInfo:GetBuff(a)
if i==nil then
e:AddBuff(e,a,o,n)
else
local i=i:GetFloors()
if i<t[9]then
local t=i+1
e:AddBuff(e,a,o,o,1)
end
end
end
end
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil then
GameInit.LogError("Buff30102001 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if#t<3 then
GameInit.LogError("Buff30102001 buffData 数量应该 大于 3")
return
end
local o=t[1]*MillionCoe
local a=t[3]
local t=t[2]
e.CurrHeroCtrl:ReduceFuryWithSkillImmediately(t,ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId),EBattleSrcType.Buff,false)
e.CurrHeroCtrl:RealHurtWithBuff(a*o,e,0)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

