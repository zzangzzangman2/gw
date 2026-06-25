local n=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local r=e[1]*MillionCoe
local d=t:GetFinalAtk()
local s=e[4]
local h=e[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a~=nil)then
local i=#a
for i=1,i do
local a=a[i]
local i=a:CurrHPPer()
if i<e[3]*MillionCoe then
local o=math.floor(a.HeroBattleInfo.MaxHP*e[6]*MillionCoe)
local e={o,e[7],e[8]}
a:AddBuff(t,s,h,e)
end
a:AddBuff(t,308100504,1,0)
n:HpHealthWithBigSkillAndParam(t,o.skilltype,d,r,nil,nil,a)
end
end
return nil
end
return h 
