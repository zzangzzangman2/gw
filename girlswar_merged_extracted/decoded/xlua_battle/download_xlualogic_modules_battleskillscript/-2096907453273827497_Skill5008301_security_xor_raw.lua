local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=t.HeroBattleInfo.skillHurtRateAdd[5008301]
if(a==nil)then
a=e[1]
end
local i=e[3]
t.HeroBattleInfo.skillHurtRateAdd[5008301]=a+i
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local l=e[4]
local u=e[5]
local r=e[6]
local d={e[7],e[8]}
local h=e[9]
local n=e[10]
local i={e[11]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=#e
for s=1,s do
local e=e[s]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,a)
if(l>=RandomMgr:GetBattleRandom())then
e:AddBuff(t,u,r,d)
e:AddBuff(t,h,n,i)
end
end
end
return nil
end
return s 
