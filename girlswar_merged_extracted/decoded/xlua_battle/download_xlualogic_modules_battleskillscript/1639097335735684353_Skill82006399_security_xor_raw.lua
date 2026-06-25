local o=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a,e)
local a=t:JudgeSkillPreView(a)
local e=e.cfgArgs
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a==nil)then
return nil
end
local a=o:FindMostBigAtk(a)
if a==nil then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls({})
local o=e[1]
local i=e[2]
local e={e[3],e[4],e[5]}
a:AddBuff(t,o,i,e)
return nil
end
return n 
