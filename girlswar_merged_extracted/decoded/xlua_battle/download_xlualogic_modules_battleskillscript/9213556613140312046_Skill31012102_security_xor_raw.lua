local i=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,h,t)
local a=e:JudgeSkillPreView(h)
local n=0
local s=a[1]
local a=t.defHeroIds
local t=nil
if a then
local e=a[1]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
local a=303101229
local a=e.HeroBattleInfo:GetBuff(a)
if(a)then
local a=a:GetBuffData()
s=a[21]
local o=303101233
local i,o=i:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,o)
t=i
local e=e:GetFinalAtk()
if t and o>0 then
n=math.floor(e*o*a[22]*MillionCoe)
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
local a=e.HeroBattleInfo:GetBuff(o)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(a)
local t=a:GetBuffData()
e.AddEnergyByPercent(a,t[6])
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,h,s,0,n)
local a=a[3]
local o=a.reduceHpValue
local a=303101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
i:AddSepsisHp(e,t,a)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
