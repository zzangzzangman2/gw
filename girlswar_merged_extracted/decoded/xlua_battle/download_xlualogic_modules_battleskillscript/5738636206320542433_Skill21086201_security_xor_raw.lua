local s=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(a==nil)then
return nil
end
local n=302108614
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o)
end
local n=302108620
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o)
end
local r=e[1]
local o=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[4]==1 then
local a=a.HeroBattleInfo:GetMaxHP()
o=math.floor(a*e[3]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,i.skilltype,o)
end
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[5],EBattleSrcType.SkillSmall)
local h=e[6]
local n=e[7]
local s={e[8],e[9]}
t:AddBuff(t,h,n,s)
local n=e[10]
local s=e[11]
local e={e[12],e[13]}
a:AddBuff(t,n,s,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r,0,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
