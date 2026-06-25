local h=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(e,r,o,t)
local t=e:JudgeSkillPreView(r)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=nil
if o then
i=o.triggerSkillAtkType
end
local l=t[1]
local s=t[3]
local o=t[4]
local n=t[5]
a:CheckAddBuff(s,e,o,n)
local n=302107205
local o=e.HeroBattleInfo:GetBuff(n)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddEnergyByPercent(o,t[6])
end
local d=t[7]
e:AddFuryWithSkill(t[8])
local o=a.HeroBattleInfo:GetCurrFury()
if o>t[9]then
local t=math.floor(o*t[10]*MillionCoe)
ModulesInit.ProcedureNormalBattle.StealFury(e,a,t,EBattleSrcType.SkillSmall,true)
end
local n=302107211
local o=e.HeroBattleInfo:GetBuff(n)
if(o)then
local e=o:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.DoActionForSkill(o,e)
end
local o=302107214
local n=e.HeroBattleInfo:GetBuff(o)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local o=h.GetSepsisCount(s)
if o>=#s*t[11]*MillionCoe then
if n then
local o=n:GetBuffData()
local h=o[3]
local d=o[4]
local r={o[5],o[6]}
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local i=t-1
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxAddHpInBigRound,6,nil,nil,nil,{bigRound=i})
local a={}
for e=1,#t do
local e=t[e]
local t=e.HeroBattleInfo:GetBuff(h)
if t==nil then
table.insert(a,e)
end
end
local t={}
local n={}
local o=o[2]
if#a<=o then
t=a
else
local e=a[o]
local s=e:GetAddHpInBigRound(i)
for e=1,#a do
local e=a[e]
local a=e:GetAddHpInBigRound(i)
if a>s then
table.insert(t,e)
elseif a==s then
table.insert(n,e)
end
end
local e=o-#t
if e>0 then
local e=RandomTableWithSeed(n,e)
for a=1,#e do
table.insert(t,e[a])
end
end
end
for a=1,#t do
t[a]:AddBuff(e,h,d,r)
end
end
local u=t[12]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(s)
local o={
attrId=t[13],
value=t[14],
}
e:AddAttrValueInCurAttack(o)
local o=#s
for o=1,o do
local o=s[o]
local s=u
if o.HeroId==a.HeroId then
s=l
end
if o.HeroBattleInfo.CurrSepsisHp>0 then
s=s+d
local a=t[15]
local i=t[16]
local t=t[17]
o:CheckAddBuff(a,e,i,t)
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
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,r,s,0,0,t)
if i~=nil then
o:SetDisableDefRage(false)
end
local t=t[3]
local a=t.reduceHpValue
if n then
local t=n:GetBuffData()
local t=t[1]
local t=math.floor(a*t*MillionCoe)
h:AddSepsisHp(e,o,t)
end
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local t=l
if a.HeroBattleInfo.CurrSepsisHp>0 then
t=t+d
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
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,r,t,0,0,o)
if i~=nil then
a:SetDisableDefRage(false)
end
local t=t[3]
local o=t.reduceHpValue
if n then
local t=n:GetBuffData()
local t=t[1]
local t=math.floor(o*t*MillionCoe)
h:AddSepsisHp(e,a,t)
end
end
e:FuryHealth(FuryHealthType.Attack)
end
return c 
