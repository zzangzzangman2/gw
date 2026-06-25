local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=e[1]
local r=e[3]
local s=e[4]
local n=e[5]
local i=t:GetFinalAtk()
local i=math.floor(i*e[6]*MillionCoe)
local i={i}
a:CheckAddBuff(r,t,s,n,i)
local i=e[7]
local n=e[8]
local s={e[9],e[10],e[11],e[12]}
t:AddBuff(t,i,n,s)
local i=a.HeroBattleInfo:GetBuff(e[13])
local n=e[15]
local s=e[16]
a:AddBuff(t,n,s,0)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
t:FuryHealth(FuryHealthType.Attack)
if i then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e[14],nil,nil,EBattleSkillType.SkillNomal)
end
return nil
end
return h 
