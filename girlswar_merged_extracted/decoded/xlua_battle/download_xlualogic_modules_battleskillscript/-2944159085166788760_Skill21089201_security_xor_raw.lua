local h=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=false
local n=302108911
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
o=e.DoActionSmallSkill(i,a)
end
local r=t[1]
local i=t[3]
local l=t[4]
local d=t[5]
local n=0
a:CheckAddBuff(i,e,l,d,n)
if e.HeroBattleInfo.SepsisHp>0 then
local a=e.HeroBattleInfo.MaxHP
local t=math.floor(a*t[6]*MillionCoe)
h:ReduceSepsisHp(e,e,t,true,true)
end
local h=t[7]
local i=t[8]
local n={t[9],t[10]}
e:AddBuff(e,h,i,n)
local n=302108905
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.GainJinBuff(i,t[11])
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
return r 
