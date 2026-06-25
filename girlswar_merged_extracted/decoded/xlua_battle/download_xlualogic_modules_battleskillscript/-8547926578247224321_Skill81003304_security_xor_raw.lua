local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(a,h)
local e=a:JudgeSkillPreView(h)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMaxFinalAtk)
if(t==nil)then
return nil
end
local d=e[1]
local o=t.HeroBattleInfo:DispelGranBuff(true,e[3])
if(o and#o>0)then
local i=#o
local o=e[4]
local s=e[5]
local n={}
t:AddBuff(a,o,s,n,i)
local i=0
local h=t.HeroBattleInfo:GetBuff(o)
if h then
i=h:GetFloors()
end
if i>=e[6]then
local h=e[7]
local r=e[8]
local d={e[9],e[10]}
t:AddBuff(a,h,r,d)
local e=i-e[6]
t:AddBuffWithFinalFloor(a,o,s,n,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,h,d)
return nil
end
return l 
