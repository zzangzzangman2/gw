local r=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,h)
local e=t:JudgeSkillPreView(h)
local a={}
local o=true
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for e=1,#i do
if i[e].HeroBattleInfo:GetBuff(303110709)==nil then
o=false
table.insert(a,i[e])
end
end
local o=nil
if#a>0 then
local e=RandomTableWithSeed(a,1)
o=e[1]
end
if o==nil then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(o==nil)then
return nil
end
local a={o}
t:ReduceFury(h.costMp)
t:RemoveOneBeans()
local d=e[1]
local u=h.atkType
local s=303110725
local n=t.HeroBattleInfo:GetBuff(s)
if u==ETriggerSkillAtkType.PursuitAttack then
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
a=i
d=e[17]
o=r:FindMostBigAtk(a)
end
end
local i={}
table.appendList(i,a)
local i=RandomTableWithSeed(i,1)
local i=i[1]
if i then
local a=e[18]
local o=e[19]
local e=e[20]
i:CheckAddBuff(a,t,o,e,0)
end
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.CheckUpSmallSkillRate(n)
end
local r=e[3]
local i=e[4]
local l={e[5],e[6]}
t:AddBuff(t,r,i,l)
local l=e[7]
local i=e[8]
local r={e[9],e[10]}
t:AddBuff(t,l,i,r)
local i=t:GetFinalAtk()
local c=math.floor(i*e[11]*MillionCoe)
local l=false
local r=303110703
local i=t.HeroBattleInfo:GetBuff(r)
if i then
local a=303110726
local a=t.HeroBattleInfo:GetBuff(a)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
if a then
t.GainGodMusic(i,e[12])
end
l=t.isMaxGodMusic(i)
end
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
t.GainGodPunish(i,o,e[14])
local n=e[15]
for o=1,#a do
if a[o].HeroBattleInfo:GetBuff(303110709)then
n=n+e[16]
end
end
t.GainGodShield(i,n)
if t.IsFirstBigSkill(i)then
t.UseFirstBigSkill(i)
local a={}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.fHollow)
for e=1,#o do
local e=o[e]
table.insert(a,e.HeroId)
end
if#a>0 then
t.AddAttackTask(i,a,e[14])
end
end
end
local r=303110715
local i=t.HeroBattleInfo:GetBuff(r)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e.DoActionBigSkill(i,a)
end
local i={}
local r={}
for e=1,#a do
local t=a[e].HeroId
r[t]=true
table.insert(i,a[e])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
for n=1,#a do
local i=d
if a[n].HeroId==o.HeroId then
if l then
i=i+e[13]
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a[n],h,i,0,c)
end
if u==ETriggerSkillAtkType.Normal then
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if e.CheckAttackAll(n)then
local a=303110725
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddAttackTask(e)
end
end
end
end
return nil
end
return c

