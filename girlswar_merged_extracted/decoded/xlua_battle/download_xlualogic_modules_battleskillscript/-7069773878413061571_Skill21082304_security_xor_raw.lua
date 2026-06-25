local e={
}
local s=e
function e.DoAction(t,n,i)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return
end
local o=0
local e=nil
for t=1,#a do
local a=a[t]
local t=302108225
local t=a.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetFloors()
if e==nil or t>o then
e=a
o=t
end
end
end
if e==nil then
e=a[1]
end
if(e==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local s=i.skillHurtRate
local i=i.realHurtRate
local a=t.HeroBattleInfo.MaxHP
local a=math.floor(o*i*a*MillionCoe)
local o=302108228
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
a=a+e.GetRealHurt(i)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,s,0,a)
return nil
end
return s 
