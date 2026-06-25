local e=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(i,n,e,t)
local e=i:JudgeSkillPreView(n)
local s=t.skillHurtRate
local a=t.defHeroIds
local e=t.professionAddRates
local o=t.furyDamageValue
local t={}
if a then
for e=1,#a do
local e=a[e]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
table.insert(t,e)
end
end
end
if#t<=0 then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local a=#t
for a=1,a do
local a=t[a]
local t=0
if a.profession==e[1]then
t=math.floor(o*e[2]*MillionCoe)
elseif a.profession==e[3]then
t=math.floor(o*e[4]*MillionCoe)
elseif a.profession==e[5]then
t=math.floor(o*e[6]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(i,a,n,s,0,t)
end
return nil
end
return h

