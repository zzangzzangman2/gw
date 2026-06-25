local r=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,a,n,t)
local t=e:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eState,1,nil,302108309)
local i=o[1]
if(i==nil)then
return nil
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.selfColumn)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(a.costMp)
local s=a.atkType
if n then
s=n.triggerSkillAtkType
end
local d=t[1]
local n=302108306
local s=e.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddLickBlood(s,t[3])
end
local n=e:GetLostHp()
local n=math.floor(n*t[4]*MillionCoe)
r:HpHealthWithBigSkillAndParam(e,a.skilltype,n,1)
local l=t[5]
local r=t[6]
local h={t[7],t[8],t[9],t[10]}
local n=e.HeroBattleInfo.CurrHP
local s=math.floor(n*t[11]*MillionCoe)
local t=302108317
local n=e.HeroBattleInfo:GetBuff(t)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.DoActionBigSkill(n,i)
end
local t=#o
for t=1,t do
local t=o[t]
t:AddBuff(e,l,r,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,d,0,s)
end
e.IgnoreBlock=false
return nil
end
return h 
