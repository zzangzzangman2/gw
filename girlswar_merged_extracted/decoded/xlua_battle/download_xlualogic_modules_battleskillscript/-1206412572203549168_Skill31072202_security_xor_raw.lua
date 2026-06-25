local r=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(e,d,o,t)
local t=e:JudgeSkillPreView(d)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=nil
if o then
i=o.triggerSkillAtkType
end
local s=t[1]
local n=303107215
local o=e.HeroBattleInfo:GetBuff(n)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
s=e.DoBeansActionSmallSkill(o,a,s)
end
local n=t[3]
local h=t[4]
local o=t[5]
a:CheckAddBuff(n,e,h,o)
local n=303107205
local o=e.HeroBattleInfo:GetBuff(n)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddEnergyByPercent(o,t[6])
end
local l=t[7]
e:AddFuryWithSkill(t[8])
local o=a.HeroBattleInfo:GetCurrFury()
if o>t[9]then
local t=math.floor(o*t[10]*MillionCoe)
ModulesInit.ProcedureNormalBattle.StealFury(e,a,t,EBattleSrcType.SkillSmall,true)
end
local n=303107211
local o=e.HeroBattleInfo:GetBuff(n)
if(o)then
local e=o:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.DoActionForSkill(o,e)
end
local o=303107214
local n=e.HeroBattleInfo:GetBuff(o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local h=r.GetSepsisCount(o)
if h>=#o*t[11]*MillionCoe then
if n then
local o=n:GetBuffData()
local h=o[3]
local r=o[4]
local d={o[5],o[6]}
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local i=t-1
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxAddHpInBigRound,6,nil,nil,nil,{bigRound=i})
local t={}
for e=1,#a do
local e=a[e]
local a=e.HeroBattleInfo:GetBuff(h)
if a==nil then
table.insert(t,e)
end
end
local a={}
local s={}
local o=o[2]
if#t<=o then
a=t
else
local e=t[o]
local n=e:GetAddHpInBigRound(i)
for e=1,#t do
local e=t[e]
local t=e:GetAddHpInBigRound(i)
if t>n then
table.insert(a,e)
elseif t==n then
table.insert(s,e)
end
end
local e=o-#a
if e>0 then
local e=RandomTableWithSeed(s,e)
for t=1,#e do
table.insert(a,e[t])
end
end
end
for t=1,#a do
a[t]:AddBuff(e,h,r,d)
end
end
local u=t[12]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local h={
attrId=t[13],
value=t[14],
}
e:AddAttrValueInCurAttack(h)
local h=#o
for h=1,h do
local o=o[h]
local h=u
if o.HeroId==a.HeroId then
h=s
end
if o.HeroBattleInfo.CurrSepsisHp>0 then
h=h+l
local i=t[15]
local a=t[16]
local t=t[17]
o:CheckAddBuff(i,e,a,t)
end
local t=nil
if i~=nil then
t=false
o:SetDisableDefRage(true)
end
local t={
triggerSkillAtkType=i,
openAddFury=t,
}
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,d,h,0,0,t)
if i~=nil then
o:SetDisableDefRage(false)
end
local t=t[3]
local t=t.reduceHpValue
if n then
local a=n:GetBuffData()
local a=a[1]
local t=math.floor(t*a*MillionCoe)
r:AddSepsisHp(e,o,t)
end
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local t=s
if a.HeroBattleInfo.CurrSepsisHp>0 then
t=t+l
end
local o=nil
if i~=nil then
o=false
a:SetDisableDefRage(true)
end
local o={
triggerSkillAtkType=i,
openAddFury=o,
}
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,d,t,0,0,o)
if i~=nil then
a:SetDisableDefRage(false)
end
local t=t[3]
local o=t.reduceHpValue
if n then
local t=n:GetBuffData()
local t=t[1]
local t=math.floor(o*t*MillionCoe)
r:AddSepsisHp(e,a,t)
end
end
e:FuryHealth(FuryHealthType.Attack)
end
return c 
