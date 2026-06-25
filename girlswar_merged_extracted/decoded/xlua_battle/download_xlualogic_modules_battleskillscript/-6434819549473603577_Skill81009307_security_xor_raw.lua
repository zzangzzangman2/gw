local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local s=e[3]
local d=e[4]
local h=e[5]
local n={}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for e=1,#o do
local e=o[e]
e:CheckAddBuff(s,t,d,h,n)
end
local n=e[6]
local o=e[7]
local s=e[8]
local h=math.floor(t:GetFinalAtk()*e[10]*MillionCoe)
local h={e[9],h}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(n,t,o,s,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r)
end
return nil
end
return d 
