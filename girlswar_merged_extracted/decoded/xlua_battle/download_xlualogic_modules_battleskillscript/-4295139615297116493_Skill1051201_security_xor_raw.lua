local e=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(t,n,o,e)
local e=t:JudgeSkillPreView(n)
local a=nil
if o and o.defHeroIds then
local e=o.defHeroIds[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
end
end
local i=nil
if o and o.isFightBack==true then
i=ETriggerSkillAtkType.FightBack
end
if a==nil or#a<=0 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
end
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local r=e[3]
local s=e[4]
local o={e[5],e[6]}
t:AddBuff(t,r,s,o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for i=1,#o do
local a=e[7]
local n=e[8]
local e={e[9],e[10]}
o[i]:AddBuff(t,a,n,e)
end
local o=#a
for o=1,o do
local a=a[o]
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[11],EBattleSrcType.SkillSmall,true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,h,0,0,{triggerSkillAtkType=i})
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

