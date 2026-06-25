local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,s,t,t)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=0
local i=302108228
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
o=o+e.GetRealHurt(n)
end
local i=302108218
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n)
end
local r=t[1]
local h=t[3]
local n=t[4]
local i={t[5],t[6]}
e:AddBuff(e,h,n,i)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
for a=1,#i do
local o=t[7]
local n=t[8]
local t={t[9],t[10]}
i[a]:AddBuff(e,o,n,t)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,s,r,0,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
