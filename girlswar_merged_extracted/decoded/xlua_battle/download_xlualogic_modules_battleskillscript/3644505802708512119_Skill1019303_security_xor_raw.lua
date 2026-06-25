local e={}
local h=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local h=t[1]
local d=t[3]
local r=t[4]
local s=t[5]
local n=t[6]
local i={t[7]}
local t
if(e.FirstAtkSelfHeroId>0)then
local a=ModulesInit.ProcedureNormalBattle.HeroDic[e.FirstAtkSelfHeroId]
if(a)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn,0,0,0,a.battleStationColumn)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
end
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local o=t[o]
local t=0
t=math.min(o.HeroBattleInfo.MaxHP*d*MillionCoe,e.HeroBattleInfo.MaxHP*r*MillionCoe)
e:HpHealthImmediately(t,EBattleSrcType.SkillBig,e.HeroId,0)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,a,h,nil,t)
local t=t[2]
if(t)then
e:AddBuff(e,s,n,i)
end
end
end
return nil
end
return h

