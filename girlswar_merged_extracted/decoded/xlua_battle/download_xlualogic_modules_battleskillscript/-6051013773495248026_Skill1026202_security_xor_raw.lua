local s=require("Modules/BattleSkillScript/1026/SkillUtil1026")
local e={}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local r=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.ourAll,1027)
local n=e[3]
local s=s.GetBuffData(e,e[4],5,16)
for e=1,#s do
local e=s[e]
local a=e.buffId
local e=e.buffData
t:AddBuff(t,a,n,e)
if o then
for i=1,#o do
o[i]:AddBuff(t,a,n,e)
end
end
end
local h=e[17]
local s=e[18]
local o=e[19]
local n={t.HeroId,e[20],e[21],e[22],e[23]}
a:CheckAddBuff(h,t,s,o,n)
local o=e[24]
local n=e[25]
local e=e[26]
a:CheckAddBuff(o,t,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

