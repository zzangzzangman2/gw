local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,i,s,t)
local t=e:JudgeSkillPreView(i)
local a=nil
local o=302108711
local n=e.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBackMinHpPercentWithCount)
a=e[1]
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionBigSkill(n,a)
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
local o=302108705
local n=e.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddBuffBlood(n,a)
end
local o=t[1]
local n=302108706
local n=a.HeroBattleInfo:GetBuff(n)
if n then
local e=n:GetFloors()
o=o+t[3]*e
o=math.min(o,t[4])
end
local h=t[5]
local s=t[6]
local n={t[7],t[8]}
e:AddBuff(e,h,s,n)
local n=t[9]
local s=t[10]
local t={t[11],t[12]}
e:AddBuff(e,n,s,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
return nil
end
return r 
