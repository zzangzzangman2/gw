local e=require("Modules/Battle/BattleUtil")
local e=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local e={}
local c=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
t:ReduceFury(s.costMp)
local u=e[1]
local a=e[3]
local h=e[4]
local i=e[5]
local n={e[6],e[7],e[8],e[9]}
local c=o:CheckAddBuff(a,t,h,i,n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.ourAllExcludeSelf)
local n=o.HeroBattleInfo:GetBuff(30105603)
local i=nil
if n and#a>0 then
local e={}
for t=1,#a do
local o=a[t].HeroBattleInfo:GetBuff(30105603)
if o==nil then
table.insert(e,a[t])
end
end
if#e>0 then
a=e
end
local e=RandomTableWithSeed(a,1)
if#e>0 then
i=e[1]
local e=n:GetRound()
local a=table.deepCopy(n:GetBuffData())
i:AddBuff(t,h,e,a)
end
end
local h=0
local n=30105612
local a=t.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
h=e.GetTotalBuffDamage(a)
end
local n=math.floor(h*e[10]*MillionCoe)
local a=0
local r=30105608
local l=t.HeroBattleInfo:GetBuff(r)
local d=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local r=e[13]
local r=d.ConsumeAllFloor(l,r)
if r>0 then
a=math.floor(h*r*e[11]*MillionCoe)
if c then
n=n+a
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,s,u,nil,n)
if i and a>0 then
local e=1056304
local t={}
local t={realhurt=a}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e,{i},nil,EBattleSkillType.SkillBig,t)
end
return nil
end
return c

