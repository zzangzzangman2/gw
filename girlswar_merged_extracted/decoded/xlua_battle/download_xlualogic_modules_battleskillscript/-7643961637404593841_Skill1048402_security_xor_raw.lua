local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a={
attrId=e[1],
value=e[2],
}
t:AddAttrValueInBattle(a)
local o=e[3]
local a=e[4]
local e={e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,o,a,e)
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function t.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fBack)
else
a=e.CurrBattleTeam:GetFrontOrBackHeros(false)
end
if#a>0 then
local o=t[11]
local i=t[12]
local n={t[13],t[14]}
for t=1,#a do
local t=a[t]
t:AddBuff(e,o,i,n)
end
local a=t[15]
local i=t[16]
local o={t[17],o}
e:AddBuff(e,a,i,o)
return{
duration=t[17],
success=true
}
end
return{
duration=0,
success=true
}
end
return{
duration=0,
success=false
}
end
return s 
