local l=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
e:ReduceFury(n.costMp)
local d=a[1]
local r=0
local o=302101209
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
r=e[1]
end
local o=302101210
local i=e.HeroBattleInfo:GetBuff(o)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(i)
end
local o=nil
local i=302101218
local i=e.HeroBattleInfo:GetBuff(i)
if(i)then
local e=i:GetBuffData()
o=e[1]
end
local h=0
local s=302101225
local i=e.HeroBattleInfo:GetBuff(s)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
local a=e.GetSkillRate(i,#t)
if a~=nil then
d=a
end
h=e.DoBuffWithBigSkill(i,t)
end
local i=a[3]
local s=a[4]
if o==nil then
o=a[5]
end
local o={o,r}
local a=a[6]
e:AddFuryWithSkill(a)
local a=#t
for a=1,a do
local t=t[a]
t:AddBuff(e,i,s,o)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,d,0,h)
local a=a[3]
local o=a.reduceHpValue
local a=302101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
l:AddSepsisHp(e,t,a)
end
end
return nil
end
return u 
