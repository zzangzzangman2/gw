local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a={
attrId=e[10],
value=e[11],
}
t:AddAttrValueInBattle(a)
local a=e[14]
if(a>=RandomMgr:GetBattleRandom())then
local a=e[12]
local o=e[13]
local e={e[15],e[16],e[17]}
t:AddBuff(t,a,o,e)
end
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
else
a=t.CurrBattleTeam:GetFrontOrBackHeros(false)
end
if#a>0 then
local o=e[1]
local i=e[2]
local n={e[3],e[4],e[5],e[6]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[7]
local i=e[8]
local o={e[9],o}
t:AddBuff(t,a,i,o)
return{
duration=e[9],
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
