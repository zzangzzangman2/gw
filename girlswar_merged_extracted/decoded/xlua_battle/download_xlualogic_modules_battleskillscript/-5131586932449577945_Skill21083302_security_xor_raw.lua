local r=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,a,i,t)
local t=e:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eState,1,nil,302108309)
local n=o[1]
if(n==nil)then
return nil
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,BattleHeroType.selfColumn)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(a.costMp)
local h=a.atkType
if i then
h=i.triggerSkillAtkType
end
local u=t[1]
local s=302108306
local i=e.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddLickBlood(i,t[3])
end
local d=e:GetLostHp()
local d=math.floor(d*t[4]*MillionCoe)
r:HpHealthWithBigSkillAndParam(e,a.skilltype,d,1)
local l=t[5]
local c=t[6]
local d={t[7],t[8],t[9],t[10]}
local r=e.HeroBattleInfo.CurrHP
local r=math.floor(r*t[11]*MillionCoe)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddPursuitAttack(i,t[12],n.HeroId,h)
end
local t=302108317
local i=e.HeroBattleInfo:GetBuff(t)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.DoActionBigSkill(i,n)
end
local t=#o
for t=1,t do
local t=o[t]
t:AddBuff(e,l,c,d)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,u,0,r)
end
e.IgnoreBlock=false
return nil
end
return d 
