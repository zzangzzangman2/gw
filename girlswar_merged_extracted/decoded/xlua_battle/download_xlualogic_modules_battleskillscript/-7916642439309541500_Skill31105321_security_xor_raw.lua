local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,o,i,e)
local a=t:JudgeSkillPreView(o)
local e=nil
if i then
local t=i.defHeroIds
if t then
local t=t[1]
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
end
end
if e==nil then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBackMinHpPercentWithCount)
e=t[1]
end
if(e==nil)then
return nil
end
t:ReduceFury(o.costMp)
t:RemoveOneBeans()
local i=303110516
local n=t.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionBigSkill(n)
end
local u=a[1]
local i=t:GetFinalAtk()
local l=math.floor(i*a[3]*MillionCoe)
local h={e}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
table.appendList(h,n)
local r=303110501
local n=t.HeroBattleInfo:GetBuff(r)
if n then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local t=RandomMgr:GetBattleRandomWithRange(a[4],a[5])
if i>=e:GetFinalAtk()*a[7]*MillionCoe then
t=t+a[8]
end
o.CheckAddSwordMaster(n,t,a[6])
end
local d=303110520
local s=t.HeroBattleInfo:GetBuff(d)
if(s)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.AddBuffKnife(s,e)
end
local i={}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(h)
for a=1,#h do
local a=h[a]
local n=0
if a.HeroId==e.HeroId then
n=u
else
local e=303110523
local e=a.HeroBattleInfo:GetBuff(e)
if e then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t].HeroId
if i[e]==nil then
i[e]=1
else
i[e]=i[e]+1
end
end
end
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n,0,l)
local t=t[3]
if a.HeroId==e.HeroId then
local t=t.criticalOrBlock
if t==1 then
if(s)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.RandomAddBuffKnife(s,e.HeroId)
end
end
end
end
local s=303110525
local e=t.HeroBattleInfo:GetBuff(s)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.AddPursuitAttack(e,i)
end
if n and o.atkType==ETriggerSkillAtkType.Normal then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local e={}
for t=9,14 do
table.insert(e,a[t])
end
i.AddPursuitAttackIchinotaka(n,o.atkType,e)
end
return nil
end
return l

