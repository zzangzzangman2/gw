local s=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,h)
local a=e:JudgeSkillPreView(h)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(h.costMp)
local n=302104310
local t=e.HeroBattleInfo:GetBuff(n)
local d=a[1]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,a[5],HeroAttrId.fury)
if(i~=nil and#i>0)then
for e=1,#i do
local e=i[e]
if e:IsFullFury()==false then
local t=RandomMgr:GetBattleRandomWithRange(a[6],a[7])
e:AddFuryWithSkill(t)
end
end
end
local i=0
local r=#o
for r=1,r do
local o=o[r]
local r=0
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
r=e.DoActionBigSkill1(t,o)
end
local n=d
if(o.profession==a[3])then
n=n+a[4]
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,h,n,0,r)
if t then
local a=a[3]
local a=a.reduceHpValue
local t=t:GetBuffData()
local t=t[9]
local t=math.floor(a*t*MillionCoe)
i=i+t
s:AddSepsisHp(e,o,t)
end
end
if t then
local a=t:GetBuffData()
local t=a[10]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local t=s:GetMaxSepsisHpPercentHeroArrByHeroArr(t,1)
for o=1,#t do
local t=t[o]
local a=math.floor(i*a[10]*MillionCoe)
if t.HeroBattleInfo.SepsisHp>0 then
s:ReduceSepsisHp(e,t,a,true,true,n)
end
end
end
return nil
end
return l 
