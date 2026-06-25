local i=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o,e,e)
local a=t:JudgeSkillPreView(o)
local h=0
local e=303112105
local e=i:GetHeroNoBuff(t,e,1,true)
local e=e[1]
if e==nil then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local n=303112116
local n=t.HeroBattleInfo:GetBuff(n)
if n then
if e.HeroBattleInfo.SepsisHp>0 then
local a=n:GetBuffData()
if e:CurrSepsisHPPer()>=a[8]*MillionCoe then
local e=t:GetFinalAtk()
h=math.floor(e*a[9]*MillionCoe)
end
end
end
local r=a[1]
if i:IsNormalSkillAtkType(o.atkType)then
local a=303112114
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.DoFire2ActionSkill(t,e)
end
end
local s=303112104
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.AddBuffLightlessPear(n,e,a[4])
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r,nil,h)
t:FuryHealth(FuryHealthType.Attack)
local o=o[3]
local o=o.reduceHpValue
local a=a[3]
local a=math.floor(o*a*MillionCoe)
i:AddSepsisHp(t,e,a)
return nil
end
return r 
