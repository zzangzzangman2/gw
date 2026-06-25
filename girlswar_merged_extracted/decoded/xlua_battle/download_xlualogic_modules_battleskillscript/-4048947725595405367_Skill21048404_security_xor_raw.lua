local o=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a={
attrId=e[1],
value=e[2],
}
t:AddAttrValueInBattle(a)
local a=e[3]
local n=e[4]
local i={e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,a,n,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=o:GetHeroWithProfession(a,e[19])
if#a>=e[18]then
local o=e[20]
local a=e[21]
local e={e[22]}
t:AddBuff(t,o,a,e)
end
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(e,t)
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
local n=t[12]
local i={t[13],t[14]}
for t=1,#a do
local t=a[t]
t:AddBuff(e,o,n,i)
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
