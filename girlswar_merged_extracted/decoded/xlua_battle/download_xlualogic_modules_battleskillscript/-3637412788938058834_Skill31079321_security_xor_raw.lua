local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
t:RemoveOneBeans()
local i=a[1]
if i then
local a=303107927
local e=t.HeroBattleInfo:GetBuff(a)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.DoActionWithKnightSun(e,i)
end
end
local n=303107924
local i=t.HeroBattleInfo:GetBuff(n)
if(i)then
if e[37]>=RandomMgr:GetBattleRandom()then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddBuffMoment(i,e[38])
end
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local s=t.HeroBattleInfo.MaxHP
local h=e[39]
local n=e[40]
local s=s*e[41]*MillionCoe
local s={s}
for e=1,#i do
local e=i[e]
e:AddBuff(t,h,n,s)
end
local l=e[1]
local i=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,i,n,s)
local n=e[7]
local s=e[8]
local i={e[9],e[10]}
t:AddBuff(t,n,s,i)
local i=e[11]
local n=e[12]
local s={e[13],e[14]}
if e[14]>0 then
t:AddBuff(t,i,n,s)
end
local s=e[15]
local i=e[16]
local n={e[17],e[18]}
if e[18]>0 then
t:AddBuff(t,s,i,n)
end
local i=t.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
local d=i*e[21]*MillionCoe
local s=e[22]
local i=e[23]
local h={e[24],math.floor(e[25]*e[28]*MillionCoe),e[26],math.floor(e[27]*e[28]*MillionCoe)}
local r={e[24],e[25],e[26],e[27]}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for e=1,#n do
local e=n[e]
if e:IsRealFirstRowHero()then
e:AddBuff(t,s,i,h)
else
e:AddBuff(t,s,i,r)
end
end
local i=e[29]
local s=e[30]
local h={e[31],e[32],e[33],e[34]}
local r={e[31],math.floor(e[32]*e[35]*MillionCoe),e[33],math.floor(e[34]*e[35]*MillionCoe)}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for a=1,#n do
local a=n[a]
if e[32]>0 or e[34]>0 then
if a:IsRealFirstRowHero()then
a:AddBuff(t,i,s,h)
else
a:AddBuff(t,i,s,r)
end
end
end
if e[36]>0 then
local a=303107909
local o=t.HeroBattleInfo:GetBuff(a)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local t=#t
a.AddEnergyByPercent(o,t*e[36])
end
end
local i=#a
for i=1,i do
local i=a[i]
local a=d
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[20]==1 then
a=a+math.floor(i.HeroBattleInfo.MaxHP*e[19]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,l,0,a)
end
return nil
end
return l

