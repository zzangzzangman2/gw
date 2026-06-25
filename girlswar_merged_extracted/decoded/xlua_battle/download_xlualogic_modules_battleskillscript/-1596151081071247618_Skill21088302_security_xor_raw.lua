local h=require("Modules/Battle/BattleUtil")
local u=require("Modules/BattleSkillScript/21088/Skill21088Util")
local e={
}
local c=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local n=0
local l=e[1]
local i=e[3]
local s=e[4]
local r={e[5],e[6]}
t:AddBuff(t,i,s,r)
local i=e[7]
local r=e[8]
local s={e[9],e[10]}
t:AddBuff(t,i,r,s)
local f=e[11]
local m=e[12]
local c={e[13],e[14]}
local s=e[15]
local r=e[16]
local d={e[17],e[18]}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for e=1,#i do
i[e]:AddBuff(t,f,m,c)
i[e]:AddBuff(t,s,r,d)
end
local s=302108815
local i=t.HeroBattleInfo:GetBuff(s)
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.GainEnergy(i,e[19])
end
local i={}
for t=20,33 do
table.insert(i,e[t])
end
local s=h:GetDataByWeight(i)
local i={}
for t=37,61 do
table.insert(i,e[t])
end
u.AddMultiMusicBuff(t,i,s)
local s=e[34]
local h=1
local e={e[35],e[36],i}
t:AddBuff(t,s,h,e)
local i=302108828
local e=t.HeroBattleInfo:GetBuff(i)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
n=t.DoActionBigSkill(e)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,l,0,n)
end
return nil
end
return c 
