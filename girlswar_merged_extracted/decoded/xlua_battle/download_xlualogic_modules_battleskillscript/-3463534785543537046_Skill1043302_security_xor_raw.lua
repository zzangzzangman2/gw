local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eAttrLow,e[2],HeroAttrId.hpPer)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local n=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fAttrLowExcludeSelf,e[5],HeroAttrId.fury)
if(o~=nil and#o>0)then
for t=1,#o do
local t=o[t]
if t:IsFullFury()==false then
local e=RandomMgr:GetBattleRandomWithRange(e[6],e[7])
t:AddFuryWithSkill(e)
end
end
end
local o=#a
for o=1,o do
local o=a[o]
local a=n
if(o.profession==e[3])then
a=a+e[4]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,a)
end
return nil
end
return s 
