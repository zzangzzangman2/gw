local o=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
e:ReduceFury(i.costMp)
e:RemoveOneBeans()
local m=t[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=303112114
local n=e.HeroBattleInfo:GetBuff(s)
for e=1,#a do
local e=a[e]
if o:IsNormalSkillAtkType(i.atkType)then
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.DoFire2ActionSkill(n,e)
end
end
end
local n=303112116
local s=e.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill(s,a)
end
local h=303112104
local r=e.HeroBattleInfo:GetBuff(h)
local d=t[5]
local l=t[6]
local n={t[7]}
local s={}
for e=1,#a do
table.insert(s,a[e].HeroId)
end
table.insert(n,s)
e:AddBuff(e,d,l,n)
local n=303112106
local n=o:GetHeroBuffFloor(e,n)
if n>0 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
for s=1,#a do
local a=a[s]
if a.HeroBattleInfo.SepsisHp>0 then
o:ReducePercentSepsisHp(e,a,t[9]*n,true,true)
end
local s=a.HeroBattleInfo.MaxHP
local n=t[10]
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[11]==1 then
n=t[12]
end
local t=math.floor(s*n*MillionCoe)
o:HpHealthWithBigSkillAndParam(e,i.skilltype,t,1,nil,nil,a)
end
end
local w=t[13]
local c=t[14]
local f=t[15]
local u={t[16]}
local s=t[17]
local d=t[18]
local l={t[19],t[20]}
e:AddBuff(e,s,d,l)
local s=#a
for s=1,s do
local a=a[s]
local d=0
local s=303112105
local s=a.HeroBattleInfo:GetBuff(s)
if s then
if r then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.AddBuffLightlessPear(r,a,t[4])
end
end
a:CheckAddBuff(w,e,c,f,u)
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,m,0,d)
if s then
local i=i[3]
local i=i.reduceHpValue
local t=t[3]
local t=math.floor(i*t*MillionCoe)
o:AddSepsisHp(e,a,t)
end
if n>0 then
local i=i[3]
local i=a.HeroBattleInfo.CurrHP
local t=t[8]*n
local t=math.floor(i*t*MillionCoe)
o:AddSepsisHp(e,a,t)
end
end
return nil
end
return m

