local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local o=t[3]
a.HeroBattleInfo:DispelGranBuff(true,o,nil,nil,e.HeroId)
local o=t[4]
local i=t[5]
local t={t[6]}
a:AddBuff(e,o,i,t)
return nil
end
return n 
