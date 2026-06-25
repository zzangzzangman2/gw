local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local i=t[1]
local s=t[3]
local n=t[4]
local a={t[5]}
e:AddBuff(e,s,n,a)
local a=t[6]
local n=t[7]
local s={t[8]}
e:AddBuff(e,a,n,s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
ModulesInit.ProcedureNormalBattle.StealFury(e,a,t[9],EBattleSrcType.SkillBig,true)
return nil
end
return s 
