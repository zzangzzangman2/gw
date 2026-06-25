local i=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,11 do
table.insert(e,t[a])
end
for a=17,23 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
table.insert(e,a.HeroBattleInfo:GetMaxHP())
table.insert(e,0)
table.insert(e,0)
table.insert(e,t[31])
a:AddBuff(a,i,o,e)
local n=t[12]
local i=t[13]
local e={}
for o=14,16 do
table.insert(e,t[o])
end
a:AddBuff(a,n,i,e)
return nil
end
function o.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function o.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local a=i:GetHeroByFinalHighAtk(a)
local o=e[24]
local n=e[25]
local i={e[26],e[27]}
if a then
local e=a
a:AddBuff(t,o,n,i)
end
local a=e[28]
local i=e[29]
local o={e[30],o}
t:AddBuff(t,a,i,o)
return{
duration=e[30],
success=true
}
end
return{
duration=0,
success=false
}
end
return s 
