local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
e:ReduceFury(n.costMp)
local r=t[1]
local o=t[3]
ModulesInit.ProcedureNormalBattle.StealFury(e,a,o,EBattleSrcType.SkillBig)
local d=t[4]
local u=t[5]
local l=t[6]
local c=t[7]
local o=e:GetFinalAtk()
local o=math.floor(o*t[9]*MillionCoe)
local h={t[8],t[10],t[11],o}
e:SetMustSmallSkill()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.insert(t,a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=302108016
local o=e.HeroBattleInfo:GetBuff(s)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill1(o,t)
end
for i=1,#t do
local t=t[i]
local i
if t.HeroId==a.HeroId then
i=r
else
i=d
end
local a=t:CheckAddBuff(u,e,l,c,h)
if a then
local t=302108003
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddLightCount(e,1)
end
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,i)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(s)
local e=e[3]
local e=e.reduceHpValue
a.DoActionBigSkill2(o,t,e)
end
end
return nil
end
return d 
