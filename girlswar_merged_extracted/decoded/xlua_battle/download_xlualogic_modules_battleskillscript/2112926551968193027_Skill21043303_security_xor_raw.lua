local s=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,h)
local t=e:JudgeSkillPreView(h)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(h.costMp)
local n=302104310
local a=e.HeroBattleInfo:GetBuff(n)
local d=t[1]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,t[5],HeroAttrId.fury)
if(i~=nil and#i>0)then
for e=1,#i do
local e=i[e]
if e:IsFullFury()==false then
local t=RandomMgr:GetBattleRandomWithRange(t[6],t[7])
e:AddFuryWithSkill(t)
end
if t[8]>=RandomMgr:GetBattleRandom()then
e.HeroBattleInfo:DispelAllGranBuff(false,false)
end
end
end
local i=0
local r=#o
for r=1,r do
local o=o[r]
local r=0
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
r=e.DoActionBigSkill1(a,o)
end
local n=d
if(o.profession==t[3])then
n=n+t[4]
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,h,n,0,r)
if a then
local t=t[3]
local n=t.reduceHpValue
local t=a:GetBuffData()
local t=t[9]
local t=math.floor(n*t*MillionCoe)
i=i+t
s:AddSepsisHp(e,o,t)
end
end
if a then
local a=a:GetBuffData()
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
