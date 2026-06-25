local s=require("Modules/BattleSkillScript/1026/SkillUtil1026")
local e={}
local r=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
local h=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(e,BattleHeroType.ourAll,1027)
local i=t[3]
local t=s.GetBuffData(t,t[4],5,16)
for o=1,#t do
local t=t[o]
local o=t.buffId
local t=t.buffData
e:AddBuff(e,o,i,t)
if a then
for n=1,#a do
a[n]:AddBuff(e,o,i,t)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

