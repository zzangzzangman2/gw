local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local r=e[1]
local h=e[4]
local d=e[5]
local s={e[6],e[7]}
local n=e[9]
local a=0
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(i~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
for l,i in ipairs(i)do
if(e[3]>=RandomMgr:GetBattleRandom())then
i:AddBuff(t,h,d,s)
end
if(e[8]>=RandomMgr:GetBattleRandom())then
local e=i.HeroBattleInfo:DispelGranBuff(true,n,nil,nil,t.HeroId)
if(e and#e>0)then
a=a+#e
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,r)
end
end
if a>0 then
t:CheckHpHealthByDispelBuff(a)
end
local n=e[10]
local o=e[11]
local a={e[12]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
if(e~=nil)then
local i=#e
for i=1,i do
local e=e[i]
e:AddBuff(t,n,o,a)
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
