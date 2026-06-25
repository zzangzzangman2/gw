local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(a,i)
local t=a:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eOneBack)
if(e==nil)then
return
end
local n=t[1]
local o=e.HeroBattleInfo.CurrHP
local o=math.floor(o*t[3]*MillionCoe)
local s=a:GetFinalAtk()
local s=math.floor(s*t[4]*MillionCoe)
o=math.min(o,s)
e.HeroBattleInfo:DispelGranBuff(true,t[5])
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,n,0,o)
return nil
end
return h 
