local e={
}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=t[1]
local r=t[4]
local h=t[5]
local n=e:GetFinalAtk()
local s=t[6]*MillionCoe
local n=math.floor(n*s)
local n={n}
a:AddBuff(e,r,h,n)
if(a.profession~=ProfessionType.Mage)then
o=o+t[7]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
ModulesInit.ProcedureNormalBattle.StealFury(e,a,t[3],EBattleSrcType.SkillSmall,true)
e:FuryHealth(FuryHealthType.Attack)
end
return h 
