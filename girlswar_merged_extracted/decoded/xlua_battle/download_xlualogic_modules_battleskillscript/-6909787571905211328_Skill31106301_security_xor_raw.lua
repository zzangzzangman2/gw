local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(t,n,e,e)
local e=t:JudgeSkillPreView(n)
local o={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
for e=1,#a do
if a[e].HeroBattleInfo:GetBuff(303110601)==nil then
table.insert(o,a[e])
end
end
local a=nil
if#o>0 then
local e=RandomTableWithSeed(o,1)
a=e[1]
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
t:ReduceFury(n.costMp)
local l=e[1]
local i=e[3]
local s=e[4]
local o=math.floor(t.HeroBattleInfo.MaxHP*e[6]*MillionCoe)
local o={e[5],o,e[7],e[8]}
a:AddBuff(t,i,s,o)
local s=0
local o={}
local h=303110603
local i=t.HeroBattleInfo:GetBuff(h)
if i then
local h=ModulesInit.BattleBuffMgr.GetBuffScript(h)
if n.atkType==ETriggerSkillAtkType.FightBack then
local s=h.GetSwordPerseusCount(i)
if s>0 then
h.ConsumeAllSwordPerseus(i)
local d=math.floor(t.HeroBattleInfo.MaxHP*e[10]*MillionCoe)
local r=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAllExcludeSelf)
o=RandomTableWithSeed(r,s)
if#o>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
for a=1,#o do
local a=o[a]
local e=math.floor(a.HeroBattleInfo.MaxHP*e[9]*MillionCoe)
e=math.min(e,d)
local o={
openAddFury=false
}
a:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,0,0,e)
a:SetDisableDefRage(false)
end
end
local a=math.max(0,s-#o)
if a>0 then
h.GeneratePowerPerseus(i,a*e[11],1)
end
local o=e[12]
local a=e[13]
local e={e[14],e[15]}
t:AddBuff(t,o,a,e,s)
end
else
local o=h.GenerateSwordPerseus(i,e[16])
if o>0 then
local t=math.floor(t.HeroBattleInfo.MaxHP*e[18]*MillionCoe)
s=math.floor(a.HeroBattleInfo.MaxHP*e[17]*MillionCoe)
s=math.min(s,t)
end
end
end
local e=303110618
local i=t.HeroBattleInfo:GetBuff(e)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionBigSkill(i,a)
end
if#o<=0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,l,0,s)
return nil
end
return l 
