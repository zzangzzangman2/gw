local s=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(a==nil)then
return nil
end
local n=302108614
local i=t.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(i)
end
local i=302108620
local n=t.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n)
end
local r=e[1]
local i=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[4]==1 then
local a=a.HeroBattleInfo:GetMaxHP()
i=math.floor(a*e[3]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,o.skilltype,i)
end
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[5],EBattleSrcType.SkillSmall)
local n=e[6]
local h=e[7]
local s={e[8],e[9]}
t:AddBuff(t,n,h,s)
local n=e[10]
local s=e[11]
local e={e[12],e[13]}
a:AddBuff(t,n,s,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r,0,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
