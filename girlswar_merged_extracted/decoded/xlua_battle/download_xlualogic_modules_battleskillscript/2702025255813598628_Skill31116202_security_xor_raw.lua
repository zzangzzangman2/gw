local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,n,t,t)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local r=t[1]
local o=303111609
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(i,a)
end
local i=303111606
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddBuffEnergyStorage(o,t[3])
end
local h=t[4]
local s=t[5]
local d=e:GetFinalAtk()
local d=math.floor(d*t[6]*MillionCoe)
local d={d}
a:AddBuff(e,h,s,d)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddAttackTaskScatteredCuts(o,t[7],n.atkType)
end
local t=0
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,r,nil,t)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return l 
