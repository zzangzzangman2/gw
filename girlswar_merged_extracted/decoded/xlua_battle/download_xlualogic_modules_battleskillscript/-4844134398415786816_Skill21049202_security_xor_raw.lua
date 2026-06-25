local e={
}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=t[1]
local o=e.HeroBattleInfo:GetBuff(302104907)
if o==nil then
local o=t[3]
local i=t[4]
local t=t[5]
a:CheckAddBuff(o,e,i,t)
else
local o=o:GetBuffData()
local i=t[3]
local t=o[1]
local n=o[2]
local o={o[3],o[4]}
a:CheckAddBuff(i,e,t,n,o)
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local o=RandomTableWithSeed(o,t[6])
for a=1,#o do
local i=o[a]
local o=t[7]
local a=t[8]
local t={t[9]}
i:AddBuff(e,o,a,t)
end
local t=e.HeroBattleInfo:GetBuff(302104913)
if t then
local t=t:GetBuffData()
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
local s=t[5]
local n=t[6]
local h={t[7],t[8]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAllExcludeSelf)
for r=1,#t do
local t=t[r]
if t.battleStationRow==e.battleStationRow then
t:AddBuff(e,a,o,i)
elseif t.battleStationColumn==e.battleStationColumn then
t:AddBuff(e,s,n,h)
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,n)
e:FuryHealth(FuryHealthType.Attack)
end
return h 
