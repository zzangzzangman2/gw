local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,#e do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function e.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
local t=303112216
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddbuffInBattle(e)
end
return{
duration=0,
success=true
}
end
return i

