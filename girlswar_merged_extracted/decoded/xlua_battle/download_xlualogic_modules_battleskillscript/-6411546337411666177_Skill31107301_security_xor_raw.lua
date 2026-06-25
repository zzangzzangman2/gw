local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(t,n,e,e)
local e=t:JudgeSkillPreView(n)
local o={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for e=1,#a do
if a[e].HeroBattleInfo:GetBuff(303110709)==nil then
table.insert(o,a[e])
end
end
local i=nil
if#o>0 then
local e=RandomTableWithSeed(o,1)
i=e[1]
end
if i==nil then
i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(i==nil)then
return nil
end
local a={i}
t:ReduceFury(n.costMp)
local d=e[1]
local s=e[3]
local o=e[4]
local h={e[5],e[6]}
t:AddBuff(t,s,o,h)
local o=e[7]
local h=e[8]
local s={e[9],e[10]}
t:AddBuff(t,o,h,s)
local o=t:GetFinalAtk()
local r=math.floor(o*e[11]*MillionCoe)
local h=false
local s=303110703
local o=t.HeroBattleInfo:GetBuff(s)
if o then
local a=303110726
local a=t.HeroBattleInfo:GetBuff(a)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if a then
t.GainGodMusic(o,e[12])
end
h=t.isMaxGodMusic(o)
end
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.GainGodPunish(o,i,e[14])
local n=e[15]
for o=1,#a do
if a[o].HeroBattleInfo:GetBuff(303110709)then
n=n+e[16]
end
end
t.GainGodShield(o,n)
if t.IsFirstBigSkill(o)then
t.UseFirstBigSkill(o)
local a={}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.fHollow)
for e=1,#i do
local e=i[e]
table.insert(a,e.HeroId)
end
if#a>0 then
t.AddAttackTask(o,a,e[14])
end
end
end
local o=303110715
local s=t.HeroBattleInfo:GetBuff(o)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionBigSkill(s,a)
end
local o={}
local s={}
for e=1,#a do
local t=a[e].HeroId
s[t]=true
table.insert(o,a[e])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for s=1,#a do
local o=d
if a[s].HeroId==i.HeroId then
if h then
o=o+e[13]
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a[s],n,o,0,r)
end
return nil
end
return l 
