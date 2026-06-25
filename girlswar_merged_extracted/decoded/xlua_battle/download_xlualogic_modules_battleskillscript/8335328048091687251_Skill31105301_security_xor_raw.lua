local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(a,i,o,e)
local e=a:JudgeSkillPreView(i)
local t=nil
if o then
local e=o.defHeroIds
if e then
local e=e[1]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
end
if t==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eBackMinHpPercentWithCount)
t=e[1]
end
if(t==nil)then
return nil
end
a:ReduceFury(i.costMp)
local n=303110516
local o=a.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill(o)
end
local r=e[1]
local o=a:GetFinalAtk()
local d=math.floor(o*e[3]*MillionCoe)
local n={t}
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
table.appendList(n,s)
local h=303110501
local s=a.HeroBattleInfo:GetBuff(h)
if s then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(h)
local a=RandomMgr:GetBattleRandomWithRange(e[4],e[5])
if o>=t:GetFinalAtk()*e[7]*MillionCoe then
a=a+e[8]
end
i.CheckAddSwordMaster(s,a,e[6])
end
local o={}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(n)
for e=1,#n do
local e=n[e]
local n=0
if e.HeroId==t.HeroId then
n=r
else
local t=303110523
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t].HeroId
if o[e]==nil then
o[e]=1
else
o[e]=o[e]+1
end
end
end
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,n,0,d)
end
local n=303110525
local t=a.HeroBattleInfo:GetBuff(n)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddPursuitAttack(t,o)
end
if s and i.atkType==ETriggerSkillAtkType.Normal then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(h)
local t={}
for o=9,14 do
table.insert(t,e[o])
end
a.AddPursuitAttackIchinotaka(s,i.atkType,t)
end
return nil
end
return r 
