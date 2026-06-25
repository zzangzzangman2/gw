local e=require("Modules/Battle/BattleUtil")
local i={
}
local m=i
function i.DoAction(t,h,a)
local e=t:JudgeSkillPreView(h)
local a=a.triggerType
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local c=e[6]
local a={308201202,308201203,308201204}
local a=RandomTableWithSeed(a,1)
local a=a[1]
local i=e[7]
local f=e[8]
local m=e[9]
local s={}
for t=10,14 do
table.insert(s,e[t])
end
local w=e[15]
local l=e[16]
local r={}
for t=17,21 do
table.insert(r,e[t])
end
local u=e[22]
local d=e[23]
local n={}
for t=24,25 do
table.insert(n,e[t])
end
local e=#o
for e=1,e do
local e=o[e]
if a==308201202 then
e:CheckAddBuff(i,t,f,m,s)
elseif a==308201203 then
e:CheckAddBuff(i,t,w,l,r)
elseif a==308201204 then
e:CheckAddBuff(i,t,u,d,n)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,c)
end
if a==308201203 then
local e=82012491
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
elseif a==308201204 then
local e=82012492
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local n=t[1]
local i=t[2]
local e={e.id}
table.insert(e,0)
table.insert(e,0)
for o=3,25 do
table.insert(e,t[o])
end
a:AddBuff(a,n,i,e)
return nil
end
return m 
