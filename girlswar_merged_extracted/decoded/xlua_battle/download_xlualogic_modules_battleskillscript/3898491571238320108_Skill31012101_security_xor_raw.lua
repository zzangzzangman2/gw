local i=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
local t=nil
local s=0
local h=o[1]
local o=303101229
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local a=o:GetBuffData()
h=a[21]
local o=303101233
local i,o=i:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,o)
t=i
local e=e:GetFinalAtk()
if t and o>0 then
s=math.floor(e*o*a[22]*MillionCoe)
end
end
if t==nil then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local o=303101210
local n=e.HeroBattleInfo:GetBuff(o)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(n)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h,0,s)
local o=o[3]
local n=o.reduceHpValue
local o=303101201
local o=e.HeroBattleInfo:GetBuff(o)
if o then
local a=o:GetBuffData()
local a=a[5]
local a=math.floor(n*a*MillionCoe)
i:AddSepsisHp(e,t,a)
end
local i=303101229
local o=e.HeroBattleInfo:GetBuff(i)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddAttackTaskSmallSkill(o,{triggerSkillAtkType=a.atkType},t.HeroId)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
