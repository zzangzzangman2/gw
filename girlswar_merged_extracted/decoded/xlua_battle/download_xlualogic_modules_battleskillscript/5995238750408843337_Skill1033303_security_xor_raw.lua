local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local d=e[1]
local r=e[4]
local s=e[5]
local h={e[6],e[7]}
local n=e[9]
local o=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for l,a in ipairs(a)do
if(e[3]>=RandomMgr:GetBattleRandom())then
a:AddBuff(t,r,s,h)
end
if(e[8]>=RandomMgr:GetBattleRandom())then
local e=a.HeroBattleInfo:DispelGranBuff(true,n,nil,nil,t.HeroId)
if(e and#e>0)then
o=o+#e
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d)
end
end
local i=e[10]
local s=e[11]
local n={e[12]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
if(a~=nil)then
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,i,s,n)
end
end
local s=e[13]
local n=e[14]
local i={e[15]}
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
if(a~=nil)then
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,s,n,i)
end
end
if(o>0)then
t:CheckHpHealthByDispelBuff(o)
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local t={}
for a,e in ipairs(a)do
if(e.HeroBattleInfo:GetBuff(2043))then
table.add(t,e)
end
end
if(t and#t>0)then
t=RandomTableWithSeed(t,1)
local t=t[1].HeroBattleInfo:GetBuff(2043)
if(t)then
t:AddRound(e[16])
end
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
