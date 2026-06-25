local n=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,o,t,t)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
e:ReduceFury(o.costMp)
local d=a[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=303112114
local i=e.HeroBattleInfo:GetBuff(s)
for e=1,#t do
local e=t[e]
if n:IsNormalSkillAtkType(o.atkType)then
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.DoFire2ActionSkill(i,e)
end
end
end
local s=303112116
local i=e.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill(i,t)
end
local r=303112104
local i=e.HeroBattleInfo:GetBuff(r)
local u=a[5]
local l=a[6]
local h={a[7]}
local s={}
for e=1,#t do
table.insert(s,t[e].HeroId)
end
table.insert(h,s)
e:AddBuff(e,u,l,h)
local s=#t
for s=1,s do
local t=t[s]
local h=0
local s=303112105
local s=t.HeroBattleInfo:GetBuff(s)
if s then
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e.AddBuffLightlessPear(i,t,a[4])
end
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,d,0,h)
if s then
local o=o[3]
local o=o.reduceHpValue
local a=a[3]
local a=math.floor(o*a*MillionCoe)
n:AddSepsisHp(e,t,a)
end
end
return nil
end
return d 
