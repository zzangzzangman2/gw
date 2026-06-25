local e={
}
local r=e
function e.DoAction(e,i,s,t)
local t=e:JudgeSkillPreView(i)
local a=nil
local n=302108711
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBackMinHpPercentWithCount)
a=e[1]
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill(o,a)
end
else
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eOneBack)
end
if(a==nil)then
return nil
end
if s==nil or s.costMp~=false then
e:ReduceFury(i.costMp)
end
local n=302108705
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddBuffBlood(o,a)
end
local o=t[1]
local n=302108706
local n=a.HeroBattleInfo:GetBuff(n)
if n then
local e=n:GetFloors()
o=o+t[3]*e
o=math.min(o,t[4])
end
local n=t[5]
local s=t[6]
local h={t[7],t[8]}
e:AddBuff(e,n,s,h)
local n=t[9]
local s=t[10]
local t={t[11],t[12]}
e:AddBuff(e,n,s,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
return nil
end
return r 
