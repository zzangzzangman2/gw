local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(a==nil)then
return
end
local h=e[1]
local o=a.HeroBattleInfo.CurrHP
local o=math.floor(o*e[3]*MillionCoe)
local n=t:GetFinalAtk()
local n=math.floor(n*e[4]*MillionCoe)
o=math.min(o,n)
a.HeroBattleInfo:DispelGranBuff(true,e[5])
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local n=RandomTableWithSeed(n,e[6])
for a=1,#n do
local o=n[a]
local i=e[7]
local n=e[8]
local a={}
for t=9,14 do
table.insert(a,e[t])
end
o:AddBuff(t,i,n,a)
end
local n=e[15]
local s=e[16]
local e=e[17]
a:CheckAddBuff(n,t,s,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,h,0,o)
return nil
end
return h 
