local e=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,n,o,e)
local e=t:JudgeSkillPreView(n)
local a=nil
if o then
if o.defHeroIds then
for e=1,#o.defHeroIds do
local e=o.defHeroIds[e]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
break
end
end
end
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
end
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local u=e[1]
local s=e[3]
local d=e[4]
local l=e[5]
local o=303107025
local i=t.HeroBattleInfo:GetBuff(o)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
s=e.DoBeansActionSmallSkill(i)
end
local r=e[6]
local h=e[7]
local i={e[8],e[9]}
local o=e[10]
t:AddBuffWithMaxFloor(t,r,h,i,1,o)
local h=e[11]
local i=e[12]
local o={e[13],e[14]}
local e=e[15]
t:AddBuffWithMaxFloor(t,h,i,o,1,e)
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(s,t,d,l,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,u)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

