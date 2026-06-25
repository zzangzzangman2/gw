local e={
}
local i=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local o=t[1]
local a=t[2]
local t={t[3]}
e:AddBuff(e,o,a,t)
local t=302107711
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.CheckResetState(e)
end
return nil
end
return i

