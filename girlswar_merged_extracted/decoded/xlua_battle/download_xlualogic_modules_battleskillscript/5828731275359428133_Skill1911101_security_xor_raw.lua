local h=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(a,s,t)
local e=a:JudgeSkillPreView(s)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local d=t.realhurt
local t=t.skillParam
local r=0
local i=t[3]
local n=t[4]
local o={}
local l=#e
for t=1,l do
local e=e[t]
table.insert(o,e.HeroId)
local e=e.HeroBattleInfo:GetBuff(n)
if e then
local e=e:GetBuffData()
i=e[1]
end
table.insert(o,i)
end
local o=h:GetDataByWeight(o)
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if o then
local e=o.HeroBattleInfo:GetBuff(n)
if e then
local e=e:GetBuffData()
e[1]=math.ceil(e[1]/2)
else
local e=t[5]
local t={i}
o:AddBuff(a,n,e,t)
end
local e=t[6]
local i=t[7]
local t={t[8],0}
o:AddBuff(a,e,i,t)
end
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,s,r,0,d)
end
return nil
end
return r 
