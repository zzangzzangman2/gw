local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local s=t[1]
local h=t[3]
local n=t[5]
local i=t[6]
local a={t[7]}
e:AddBuff(e,n,i,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandom,3)
if(a~=nil)then
local i=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for t,a in ipairs(a)do
local t=s
if(a.profession==ProfessionType.Warrior)then
t=t+h
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,t)
local e=e[2]
if(e)then
i=i+1
end
end
e:HpHealthImmediately(e.HeroBattleInfo.MaxHP*t[4]*i*MillionCoe,EBattleSrcType.SkillBig,e.HeroId,0)
end
return nil
end
return s 
