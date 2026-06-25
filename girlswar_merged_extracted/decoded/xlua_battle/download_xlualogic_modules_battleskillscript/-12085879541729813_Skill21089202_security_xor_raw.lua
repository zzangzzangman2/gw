local h=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(e,s,t,t)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=false
local i=302108911
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
o=e.DoActionSmallSkill(n,a)
end
local r=t[1]
local d=t[3]
local l=t[4]
local i=t[5]
local n=0
a:CheckAddBuff(d,e,l,i,n)
if e.HeroBattleInfo.SepsisHp>0 then
local a=e.HeroBattleInfo.MaxHP
local t=math.floor(a*t[6]*MillionCoe)
h:ReduceSepsisHp(e,e,t,true,true)
end
local n=t[7]
local i=t[8]
local h={t[9],t[10]}
e:AddBuff(e,n,i,h)
local i=302108905
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.GainJinBuff(n,t[11])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local t
if o==true then
t={
openAddFury=false,
}
a:SetDisableDefRage(true)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,s,r,0,0,t)
if o==true then
a:SetDisableDefRage(false)
end
e:FuryHealth(FuryHealthType.Attack)
end
return u 
