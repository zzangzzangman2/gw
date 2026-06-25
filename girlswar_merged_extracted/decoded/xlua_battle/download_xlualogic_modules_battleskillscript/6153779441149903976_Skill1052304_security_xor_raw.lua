local e={}
local n=e
function e.DoAction(t,i,o)
local a=t:JudgeSkillPreView(i)
local e
if o~=nil then
e=o[1]
end
if e==nil then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(e==nil)then
return
end
local o=a[1]
local a=a[2]
local n={0,0}
e:AddBuff(t,o,a,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,0)
return nil
end
return n

