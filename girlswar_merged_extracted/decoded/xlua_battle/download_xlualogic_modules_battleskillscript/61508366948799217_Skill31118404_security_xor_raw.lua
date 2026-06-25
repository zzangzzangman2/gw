local i=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,e)
local a=t:JudgeSkillPreView(e)
local i=a[1]
local o=a[2]
local e={}
for t=3,23 do
table.insert(e,a[t])
end
table.insert(e,0)
t:AddBuff(t,i,o,e)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function e.DoAfterAction(e,t)
local o=e:JudgeSkillPreView(t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBack)
if#t>0 then
local a=i:FindMostBigAtk(t)
if a then
local t=303111801
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffFlaw(e,a,o[7])
end
end
end
return{
duration=0,
success=true
}
end
return n 
