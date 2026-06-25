local e={}
local n=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,25 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,i,o,e)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function e.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
local o=303112301
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.CheckAddBuffDestiny(a,a:GetBuffData(),t[8])
end
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=t[26]
local i=t[27]
local o={t[28],t[29]}
e:AddBuff(e,a,i,o)
local i=t[30]
local o=t[31]
local t=t[32]
local a={t,a}
e:AddBuff(e,i,o,a)
return{
duration=t,
success=true,
}
end
return{
duration=0,
success=false,
}
end
return n

