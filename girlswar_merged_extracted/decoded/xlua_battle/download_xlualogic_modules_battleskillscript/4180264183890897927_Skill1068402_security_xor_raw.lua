local e=require("Modules/Battle/BattleUtil")
local a={
}
local n=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[14]
local i=e[15]
local o={e[16],e[17],e[18],e[19]}
t:AddBuff(t,a,i,o)
local n=e[20]
local i=e[21]
local a={}
for o=22,29 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=t[1]
local i=t[2]
local o={}
for a=3,10 do
table.insert(o,t[a])
end
e:AddBuff(e,a,i,o)
local o=t[11]
local i=t[12]
local a={t[13],a}
e:AddBuff(e,o,i,a)
return{
duration=t[13],
success=true
}
end
return{
duration=0,
success=false
}
end
return n

