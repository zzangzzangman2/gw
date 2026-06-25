local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local i=a[1]
if i then
local e=303107927
local t=t.HeroBattleInfo:GetBuff(e)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionWithKnightSun(t,i)
end
end
local l=e[1]
local i=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,i,n,s)
local i=e[7]
local s=e[8]
local n={e[9],e[10]}
t:AddBuff(t,i,s,n)
local n=e[11]
local s=e[12]
local i={e[13],e[14]}
if e[14]>0 then
t:AddBuff(t,n,s,i)
end
local s=e[15]
local n=e[16]
local i={e[17],e[18]}
if e[18]>0 then
t:AddBuff(t,s,n,i)
end
local i=t.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
local d=i*e[21]*MillionCoe
local i=e[22]
local s=e[23]
local r={e[24],math.floor(e[25]*e[28]*MillionCoe),e[26],math.floor(e[27]*e[28]*MillionCoe)}
local h={e[24],e[25],e[26],e[27]}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for e=1,#n do
local e=n[e]
if e:IsRealFirstRowHero()then
e:AddBuff(t,i,s,r)
else
e:AddBuff(t,i,s,h)
end
end
local s=e[29]
local n=e[30]
local h={e[31],e[32],e[33],e[34]}
local r={e[31],math.floor(e[32]*e[35]*MillionCoe),e[33],math.floor(e[34]*e[35]*MillionCoe)}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for a=1,#i do
local a=i[a]
if e[32]>0 or e[34]>0 then
if a:IsRealFirstRowHero()then
a:AddBuff(t,s,n,h)
else
a:AddBuff(t,s,n,r)
end
end
end
if e[36]>0 then
local o=303107909
local a=t.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local t=#t
o.AddEnergyByPercent(a,t*e[36])
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
return u 
