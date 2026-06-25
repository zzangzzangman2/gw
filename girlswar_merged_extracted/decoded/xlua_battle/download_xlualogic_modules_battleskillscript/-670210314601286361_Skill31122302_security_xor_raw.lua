local e={
}
local l=e
function e.DoAction(a,n,e)
local e=a:JudgeSkillPreView(n)
local r=303112206
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMostDebuff)
if t==nil then
return nil
end
a:ReduceFury(n.costMp)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
local s={}
if type(o)=="table"and#o>0 then
for e=1,#o do
local e=o[e]
if e and e.HeroId~=t.HeroId then
table.insert(s,e)
end
end
end
local d=e[6]
local l=e[7]
local o={}
local i={}
local h=#s
if h>0 and d>0 then
for e=1,d do
local e=RandomMgr:GetBattleRandomWithRange(1,h)
local t=s[e]
if t then
local e=t.HeroId
if i[e]==nil then
i[e]=1
table.insert(o,t)
else
i[e]=i[e]+1
end
end
end
end
if#o>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,t)
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
end
local s={
attrId=e[2],
value=e[3],
}
t:AddAttrValueInCurAttack(s)
local s={
attrId=e[4],
value=e[5],
}
t:AddAttrValueInCurAttack(s)
local s=e[1]
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,n,s)
local t=t[3]
local t=t.reduceHpValue
local t=math.floor(t*l*MillionCoe)
if t>0 and#o>0 then
for e=1,#o do
local o=o[e]
local e=i[o.HeroId]or 0
if e>0 then
local e=t*e
ModulesInit.ProcedureNormalBattle.SkillHurt(a,o,n,0,0,e)
end
end
end
local e=e[8]
if e==1 then
local t=a.HeroBattleInfo:GetBuff(r)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
if e and e.TriggerAllEmptyMarks then
e.TriggerAllEmptyMarks(t)
end
end
end
return nil
end
return l

