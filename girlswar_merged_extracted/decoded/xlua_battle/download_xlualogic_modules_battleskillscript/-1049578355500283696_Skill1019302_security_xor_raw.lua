local e={}
local h=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local r=t[1]
local l=t[3]
local d=t[4]
local s=t[5]
local h=t[6]
local n={t[7]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local i=t[o]
local t=0
if(o==1)then
t=math.min(i.HeroBattleInfo.MaxHP*l*MillionCoe,e.HeroBattleInfo.MaxHP*d*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:HpHealthImmediately(t,EBattleSrcType.SkillBig,e.HeroId,0)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,a,r,nil,t)
local t=t[2]
if(t)then
e:AddBuff(e,s,h,n)
end
end
end
return nil
end
return h

