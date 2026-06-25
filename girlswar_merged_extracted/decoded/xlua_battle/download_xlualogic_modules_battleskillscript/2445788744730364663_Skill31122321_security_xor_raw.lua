local e={
}
local d=e
function e.DoAction(t,n,e)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMostDebuff)
if a==nil then
return nil
end
t:ReduceFury(n.costMp)
t:RemoveOneBeans()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local s={}
if type(o)=="table"and#o>0 then
for e=1,#o do
local e=o[e]
if e and e.HeroId~=a.HeroId then
table.insert(s,e)
end
end
end
local r=e[6]
local d=e[7]
local o={}
local i={}
local h=#s
if h>0 and r>0 then
for e=1,r do
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
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
local s={
attrId=e[2],
value=e[3],
}
a:AddAttrValueInCurAttack(s)
local s={
attrId=e[4],
value=e[5],
}
a:AddAttrValueInCurAttack(s)
local s=e[1]
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,s)
local a=a[3]
local a=a.reduceHpValue
local a=math.floor(a*d*MillionCoe)
if a>0 and#o>0 then
for e=1,#o do
local e=o[e]
local o=i[e.HeroId]or 0
if o>0 then
local a=a*o
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,0,0,a)
end
end
end
local a=0
local o=e[8]
if o==1 then
local o=303112206
local e=t.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
a=t.TriggerAllEmptyMarks(e)
end
end
if a>0 then
local o=303112223
local t=t.HeroBattleInfo:GetBuff(o)
if t then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.DoActionPerEmptyMarkExplode(t,a,e[9])
end
end
return nil
end
return d

