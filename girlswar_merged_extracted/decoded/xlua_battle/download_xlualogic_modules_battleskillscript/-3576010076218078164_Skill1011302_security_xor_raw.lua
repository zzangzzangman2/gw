local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local i=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
local o=e[3]
a.HeroBattleInfo:DispelGranBuff(true,o,nil,nil,t.HeroId)
local n=e[4]
local i=e[5]
local o={e[6]}
a:AddBuff(t,n,i,o)
local i=e[7]
local o=e[8]
local e=e[9]
local n=require("Modules/Battle/Formula")
if n:CalculateCtrlSuccess(o,i,t,a)then
a:AddBuff(t,o,e,nil)
end
return nil
end
return s 
