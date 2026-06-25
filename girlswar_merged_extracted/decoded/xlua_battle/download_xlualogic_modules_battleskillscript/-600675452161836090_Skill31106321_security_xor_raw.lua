local d=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,n)
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
t:RemoveOneBeans()
local l=e[1]
local o=e[3]
local i=e[4]
local s=math.floor(t.HeroBattleInfo.MaxHP*e[6]*MillionCoe)
local s={e[5],s,e[7],e[8]}
a:AddBuff(t,o,i,s)
local r=0
local o={}
local s=303110603
local i=t.HeroBattleInfo:GetBuff(s)
if i then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if n.atkType==ETriggerSkillAtkType.FightBack then
local h=s.GetSwordPerseusCount(i)
if h>0 then
s.ConsumeAllSwordPerseus(i)
local r=math.floor(t.HeroBattleInfo.MaxHP*e[10]*MillionCoe)
local d=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAllExcludeSelf)
o=RandomTableWithSeed(d,h)
if#o>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
for a=1,#o do
local a=o[a]
local o=math.floor(a.HeroBattleInfo.MaxHP*e[9]*MillionCoe)
o=math.min(o,r)
local i={
openAddFury=false
}
a:SetDisableDefRage(true)
local i=0
local s=a.HeroBattleInfo:GetBuff(303110607)
if s then
i=s:GetFloors()
end
local e={
attrId=e[19],
value=e[20]*i,
}
a:AddAttrValueInCurAttack(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,0,0,o)
a:SetDisableDefRage(false)
end
end
local a=math.max(0,h-#o)
if a>0 then
s.GeneratePowerPerseus(i,a*e[11],1)
end
local a=e[12]
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(t,a,o,e,h)
end
else
local o=s.GenerateSwordPerseus(i,e[16])
if o>0 then
local t=math.floor(t.HeroBattleInfo.MaxHP*e[18]*MillionCoe)
r=math.floor(a.HeroBattleInfo.MaxHP*e[17]*MillionCoe)
r=math.min(r,t)
end
end
end
local s=303110618
local i=t.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill(i,a)
end
local s=0
local i=a.HeroBattleInfo:GetBuff(303110607)
if i then
s=i:GetFloors()
end
local i={
attrId=e[19],
value=e[20]*s,
}
a:AddAttrValueInCurAttack(i)
local s=t
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if#i>0 then
local e=d:GetMinHpPercentHeroArr(i,1)
local e=e[1]
if e then
s=e
end
end
local d=e[21]
local h=e[22]
local i={}
for t=23,27 do
table.insert(i,e[t])
end
s:AddBuffAfterRemove(t,d,h,i)
if#o<=0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,l,0,r)
return nil
end
return u

