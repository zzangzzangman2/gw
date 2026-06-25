local e={
}
local h=e
function e.DoAction(e,n)
local a=e:JudgeSkillPreView(n)
local s=a[1]
local h=a[4]
local t=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for i,o in ipairs(o)do
local i=s
if(o.profession==ProfessionType.Tank)then
i=s+a[5]
end
if(a[3]>=RandomMgr:GetBattleRandom())then
local e=o.HeroBattleInfo:DispelGranBuff(true,h,nil,nil,e.HeroId)
if(e and#e>0)then
t=t+#e
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,i)
end
end
if t>0 then
e:CheckHpHealthByDispelBuff(t)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
