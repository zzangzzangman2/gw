local s=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=t[1]
local i=t[3]
local d=t[4]
local l=t[5]
local o=302102908
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=t:GetBuffData()
i=e[1]
end
local h=#a
for h=1,h do
local a=a[h]
local i=a:CheckAddBuff(i,e,d,l)
if i then
local i=302102906
local e=e.HeroBattleInfo:GetBuff(i)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.AddCharonMarkStatCount(e,1)
end
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddBuffNetherWorld(t,a)
end
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,r)
local o=o[3]
local o=o.reduceHpValue
if t then
local t=t:GetBuffData()
local t=t[5]
local t=math.floor(o*t*MillionCoe)
s:AddSepsisHp(e,a,t)
end
end
return nil
end
return d 
