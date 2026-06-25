local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local r=e[1]
local o=e[3]
ModulesInit.ProcedureNormalBattle.StealFury(t,a,o,EBattleSrcType.SkillBig)
local d=e[4]
local u=e[5]
local l=e[6]
local c=e[7]
local o=t:GetFinalAtk()
local o=math.floor(o*e[9]*MillionCoe)
local h={e[8],e[10],e[11],o}
t:SetMustSmallSkill()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.insert(e,a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=302108016
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.DoActionBigSkill1(o,e)
end
for s=1,#e do
local e=e[s]
local s
if e.HeroId==a.HeroId then
s=r
else
s=d
end
local a=e:CheckAddBuff(u,t,l,c,h)
if a then
local e=302108003
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddLightCount(t,1)
end
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local a=a[3]
local a=a.reduceHpValue
t.DoActionBigSkill2(o,e,a)
end
end
return nil
end
return d 
