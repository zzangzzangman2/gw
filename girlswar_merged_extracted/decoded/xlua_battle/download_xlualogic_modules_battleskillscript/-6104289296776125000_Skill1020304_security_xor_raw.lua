local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local r=e[1]
local n=e[3]
local s=e[4]
local h=e[5]
local o=ModulesInit.BattleBuffMgr.GetBuffScript(30102003)
local o=o.GetBuffValue(t,e)
a:CheckAddBuff(n,t,s,h,o)
local s=e[8]
local n=e[9]
local o={e[10]}
t:AddBuff(t,s,n,o)
local h=e[11]
local n=e[12]
local s={e[13]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(o)then
for a,e in ipairs(o)do
if e.HeroId~=t.HeroId and e.profession==ProfessionType.Warrior then
e:AddBuff(t,h,n,s)
end
end
end
local o=r
local n=e[14]
if a.HeroBattleInfo:GetBuff(n)~=nil then
o=o+e[15]
t:AddFuryWithSkill(e[16])
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
return nil
end
return r 
