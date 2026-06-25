local o=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local i=true
local n=303110307
local a=t.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.IsYoung(a)
end
local a=BattleHeroType.enemyAll
local d=0
if i then
a=BattleHeroType.eBack
d=e[1]
else
a=BattleHeroType.enemyAll
d=e[3]
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(s.costMp)
t:RemoveOneBeans()
local h=e[5]
local i=e[6]
local n={e[7],e[8]}
t:AddBuff(t,h,i,n)
local h=e[9]
local n=e[10]
local i={e[11],e[12]}
t:AddBuff(t,h,n,i)
local i=e[13]
local n=e[14]
local h={e[15],e[16]}
t:AddBuff(t,i,n,h)
local i=e[17]
local h=e[18]
local n={e[19],e[20]}
t:AddBuff(t,i,h,n)
local h=true
local n=o:GetConCtrlAndStealHeroInTeam(t,1)
if#n<=0 then
h=false
n=o:GetStealHeroInTeam(t,false,1)
end
local i=table.lightCopyList(a)
local i=RandomTableWithSeed(i,e[21])
local n=n[1]
if n then
local e=n.HeroBattleInfo:GetGranBuffCanSteal(false,true)
for a=1,#e do
local e=e[a]
local a=e.buffId
local h=e:GetRound()
local o=e:GetBuffData()
local s=e:GetFloors()
local e=n.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.BeStolen)
if e then
for e=1,#i do
local e=i[e]
if e.HeroBattleInfo then
e:AddBuff(t,a,h,o,s)
if e.HeroBattleInfo then
e.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
end
end
end
end
end
if h==false then
for a=1,#i do
local a=i[a]
if(e[22]>=RandomMgr:GetBattleRandom())then
if a.HeroBattleInfo then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[25],EBattleSrcType.SkillBig)
local o=e[23]
local e=e[24]
local i={}
a:AddBuff(t,o,e,i)
if a.HeroBattleInfo then
a.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
end
end
end
local u=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local c={}
local h=303110321
local n=t.HeroBattleInfo:GetBuff(h)
local i=#a
for i=1,i do
local a=a[i]
local r=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[27]==1 then
local a=a.HeroBattleInfo:GetMaxHP()
r=math.floor(a*e[26]*MillionCoe)
local e=o:GetMinHpPercentHeroArr(u,1)
local e=e[1]
if e then
o:HpHealthWithBigSkillAndParam(t,s.skilltype,r,1,nil,nil,e)
end
end
local i=t:GetFinalAtk()
local u=math.floor(i*e[34]*MillionCoe)
local i=true
local l=false
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
i,l=e.DoActionBigSkill(n)
end
local n={
realHurtInCrit=u,
openAddFury=i,
IgnoreDef=l,
}
if i==false then
a:SetDisableDefRage(true)
end
local n=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,d,0,r,n)
if i==false then
a:SetDisableDefRage(false)
end
local i=n[3]
local n=i.criticalOrBlock
if n==1 then
table.insert(c,a.HeroId)
end
local i=i.reduceHpValue
local e=e[28]
local e=math.floor(i*e*MillionCoe)
o:AddSepsisHp(t,a,e)
end
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoActionBigSkillWithEnemyCount(n,c)
end
local a=RandomTableWithSeed(u,1)
local a=a[1]
if a then
local o=e[29]
local h=e[30]
local s={e[31],0,0}
local i=false
local n=t.HeroBattleInfo:GetBuff(o)
if n==nil then
a:AddBuff(t,o,h,s)
i=true
else
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e=e.CheckTriggerBuff(n)
if e then
i=true
end
end
if i then
local o=e[32]
local e=e[33]
local i={}
a:AddBuff(t,o,e,i)
end
end
return nil
end
return m

