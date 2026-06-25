local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local s=t[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBack)
if(o~=nil)then
local i=t[3]
local n=t[4]
local d={t[5]}
local r=t[6]
local l=t[7]
local h={t[8]}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,t in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,s)
t:AddBuff(e,i,n,d)
t:AddBuff(e,r,l,h)
end
end
local o=e.CurrBattleTeam:GetBeControlHeros()
if(o)then
o=RandomTableWithSeed(o,t[9])
for i,o in ipairs(o)do
o.HeroBattleInfo:RemoveControlBuff()
local o=0
if(a.skilltype and a.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
o=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*t[10]*MillionCoe*(1+o),false,EBattleSrcType.SkillBig)
e:AddFuryWithSkill(t[11])
end
end
return nil
end
return n 
