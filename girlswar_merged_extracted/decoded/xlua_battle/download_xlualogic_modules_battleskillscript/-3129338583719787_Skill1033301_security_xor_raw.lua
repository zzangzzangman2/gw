local e={
}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local n=e[1]
local a=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for s,o in ipairs(o)do
if(e[3]>=RandomMgr:GetBattleRandom())then
local a=e[4]
local i=e[5]
local e={e[6],e[7]}
o:AddBuff(t,a,i,e)
end
if(e[8]>=RandomMgr:GetBattleRandom())then
local e=e[9]
local e=o.HeroBattleInfo:DispelGranBuff(true,e,nil,nil,t.HeroId)
if(e and#e>0)then
a=a+#e
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,n)
end
end
if a>0 then
t:CheckHpHealthByDispelBuff(a)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
