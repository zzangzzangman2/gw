local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local s=e[1]
local h=e[3]
local n=e[4]
local i={e[5],e[6]}
a:AddBuff(t,h,n,i)
local n=e[7]
local i={}
for t=7,13 do
table.insert(i,e[t])
end
table.insert(i,a.HeroId)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoAddChain(t,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
return nil
end
return r

