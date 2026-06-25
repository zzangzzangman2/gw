local e={
}
local d=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=t[1]
local r=t[4]
local s=t[5]
local n=e:GetFinalAtk()
local i=t[6]*MillionCoe
local i=math.floor(n*i)
local i={i}
a:AddBuff(e,r,s,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h)
ModulesInit.ProcedureNormalBattle.StealFury(e,a,t[3],EBattleSrcType.SkillSmall,true)
e:FuryHealth(FuryHealthType.Attack)
end
return d 
