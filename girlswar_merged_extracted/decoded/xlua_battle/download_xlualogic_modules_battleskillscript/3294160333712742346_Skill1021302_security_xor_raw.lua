local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local s=e[1]
local n=e[3]
local i=e[4]
local a={e[5]}
t:AddBuff(t,n,i,a)
local n=e[6]
local a=e[7]
local i={e[8]}
t:AddBuff(t,n,a,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
local i=e[9]
local o=e[10]
local e=e[11]
local n=require("Modules/Battle/Formula")
if n:CalculateCtrlSuccess(o,i,t,a)then
a:AddBuff(t,o,e,nil)
end
return nil
end
return s 
