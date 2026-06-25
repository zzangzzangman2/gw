local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,a)
e:ReduceFury(o.costMp)
local n=t[1]
local r=t[3]
local h=t[4]
local s=t[5]
a:CheckAddBuff(r,e,h,s,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n)
local t=n*t[6]*MillionCoe
if(i~=nil)then
for i,a in ipairs(i)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,t)
end
end
return nil
end
return r 
