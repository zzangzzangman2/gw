local e={
}
local o=e
function e.DoAction(t,o,i)
local e=nil
local a={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,1)
if#a>0 then
e=a[1]
end
if e then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local a=i.skillParam
e:AddBuff(t,a[1],a[2],a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,t,o,0,0,0)
end
return nil
end
return o 
