local e={
}
local d=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=302104810
local o=t.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(o,a)
end
local l=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if#o<e[3]then
table.insert(o,t)
end
local o=RandomTableWithSeed(o,e[3])
for a=1,#o do
local o=o[a]
local i=e[4]
local a=e[5]
local e={e[6],e[7]}
o:AddBuff(t,i,a,e)
end
local o=e[8]
local d=e[9]
local h={e[10],e[11]}
local r=1
local i=true
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local t=n:GetFloors()
if t>=e[12]then
i=false
end
end
if i then
t:AddBuff(t,o,d,h,r)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,l)
t:FuryHealth(FuryHealthType.Attack)
end
return d 
