local n=require("Modules/Battle/BattleUtil")
local i={
}
local c=i
function i.DoAction(t,u,a,e)
local e=t:JudgeSkillPreView(u)
local o=0
if a then
o=a.defHeroId
end
local a=n:GetTargetHeroCtrl(o)
if(a==nil)then
return nil
end
local o={a}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.appendList(o,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local c=e[3]
local i=e[5]
local l=e[6]
local d=e[7]
local r={e[8],e[9]}
a:CheckAddBuff(i,t,l,d,r)
local h=e[10]
local n=e[11]
local s={e[12]}
a:CheckAddBuff(i,t,h,n,s)
local i=e[13]
local e=#o
for e=1,e do
local e=o[e]
if e.HeroId~=a.HeroId and i>0 then
if RandomMgr:GetBattleRandom()>5000 then
e:CheckAddBuff(i,t,l,d,r)
else
e:CheckAddBuff(i,t,h,n,s)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,u,c)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[4]}
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,i,e)
return nil
end
return c 
