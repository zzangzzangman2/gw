local e={
}
local r=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
local a={}
table.insert(a,o)
local i=e[1]
local h=e[10]
local n=e[11]
local r={e[12],e[13],e[14]}
local o=t.HeroBattleInfo:GetBuff(30103502)
if o==nil then
t:AddBuff(t,h,n,r)
else
local n=o:GetFloors()
o:AddFloors(1)
if n>=e[12]-1 then
i=i+e[13]
if e[14]==3 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
end
end
end
local r=e[3]
local o=e[4]
local n=e[5]
local h={e[6],e[7],e[8],e[9]}
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local h=e.GetBuffValue(t,n,h)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,o,n,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,s,i)
end
t:FuryHealth(FuryHealthType.Attack)
end
return r 
