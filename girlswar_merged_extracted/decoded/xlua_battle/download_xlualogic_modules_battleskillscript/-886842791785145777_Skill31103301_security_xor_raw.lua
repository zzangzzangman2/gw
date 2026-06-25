local i=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,s,e,e)
local e=t:JudgeSkillPreView(s)
local o=true
local a=303110307
local n=t.HeroBattleInfo:GetBuff(a)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
o=e.IsYoung(n)
end
local a=BattleHeroType.enemyAll
local h=0
if o then
a=BattleHeroType.eBack
h=e[1]
else
a=BattleHeroType.enemyAll
h=e[3]
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(s.costMp)
local a=e[5]
local n=e[6]
local r={e[7],e[8]}
t:AddBuff(t,a,n,r)
local r=e[9]
local n=e[10]
local a={e[11],e[12]}
t:AddBuff(t,r,n,a)
local a=e[13]
local r=e[14]
local n={e[15],e[16]}
t:AddBuff(t,a,r,n)
local a=e[17]
local n=e[18]
local r={e[19],e[20]}
t:AddBuff(t,a,n,r)
local r=true
local n=i:GetConCtrlAndStealHeroInTeam(t,1)
if#n<=0 then
r=false
n=i:GetStealHeroInTeam(t,false,1)
end
local a=table.lightCopyList(o)
local a=RandomTableWithSeed(a,e[21])
local n=n[1]
if n then
local e=n.HeroBattleInfo:GetGranBuffCanSteal(false,true)
for o=1,#e do
local e=e[o]
local o=e.buffId
local h=e:GetRound()
local i=e:GetBuffData()
local s=e:GetFloors()
local e=n.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.BeStolen)
if e then
for e=1,#a do
local e=a[e]
if e.HeroBattleInfo then
e:AddBuff(t,o,h,i,s)
if e.HeroBattleInfo then
e.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
end
end
end
end
if r==false then
for o=1,#a do
local a=a[o]
if(e[22]>=RandomMgr:GetBattleRandom())then
if a.HeroBattleInfo then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[25],EBattleSrcType.SkillBig)
local o=e[23]
local i=e[24]
local e={}
a:AddBuff(t,o,i,e)
if a.HeroBattleInfo then
a.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
end
end
end
local l=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local d={}
local r=303110321
local n=t.HeroBattleInfo:GetBuff(r)
local a=#o
for a=1,a do
local a=o[a]
local o=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[27]==1 then
local a=a.HeroBattleInfo:GetMaxHP()
o=math.floor(a*e[26]*MillionCoe)
local e=i:GetMinHpPercentHeroArr(l,1)
local e=e[1]
if e then
i:HpHealthWithBigSkillAndParam(t,s.skilltype,o,1,nil,nil,e)
end
end
local e=true
local i=false
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e,i=t.DoActionBigSkill(n)
end
local i={
openAddFury=e,
IgnoreDef=i,
}
if e==false then
a:SetDisableDefRage(true)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,h,0,o,i)
if e==false then
a:SetDisableDefRage(false)
end
local e=t[3]
local e=e.criticalOrBlock
if e==1 then
table.insert(d,a.HeroId)
end
end
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e.DoActionBigSkillWithEnemyCount(n,d)
end
return nil
end
return u 
