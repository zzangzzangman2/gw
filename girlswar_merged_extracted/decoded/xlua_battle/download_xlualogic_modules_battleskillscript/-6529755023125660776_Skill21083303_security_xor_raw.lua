local d=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,a,n,e)
local e=t:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eState,1,nil,302108309)
local i=o[1]
if(i==nil)then
return nil
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.selfColumn)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(a.costMp)
local s=a.atkType
if n then
s=n.triggerSkillAtkType
end
local u=e[1]
local h=302108306
local n=t.HeroBattleInfo:GetBuff(h)
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(h)
t.AddLickBlood(n,e[3])
end
local r=t:GetLostHp()
local r=math.floor(r*e[4]*MillionCoe)
d:HpHealthWithBigSkillAndParam(t,a.skilltype,r,1)
local c=e[5]
local d=e[6]
local l={e[7],e[8],e[9],e[10]}
local r=t.HeroBattleInfo.CurrHP
local r=math.floor(r*e[11]*MillionCoe)
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(h)
t.AddPursuitAttack(n,e[12],i.HeroId,s)
end
if s~=ETriggerSkillAtkType.FightBack then
local o=e[13]
local i=e[14]
local a={}
for t=15,21 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
t:AddBuffAfterRemove(t,o,i,a)
end
local e=302108317
local n=t.HeroBattleInfo:GetBuff(e)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionBigSkill(n,i)
end
local e=#o
for e=1,e do
local e=o[e]
e:AddBuff(t,c,d,l)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,u,0,r)
end
t.IgnoreBlock=false
return nil
end
return u 
