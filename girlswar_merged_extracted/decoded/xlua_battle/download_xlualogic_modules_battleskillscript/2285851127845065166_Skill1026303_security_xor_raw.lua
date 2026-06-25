local n=require("Modules/BattleSkillScript/1026/SkillUtil1026")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfRow)
local s=#i
if(s>1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,1026304,i)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local r=e[1]
local s=e[3]
local i=n.GetBuffData(e,e[4],5,16)
for e=1,#i do
local e=i[e]
local o=e.buffId
local e=e.buffData
a:AddBuff(t,o,s,e)
end
local i=e[17]
local n=e[18]
local h=e[19]
local s={t.HeroId,e[20],e[21],e[22],e[23]}
a:CheckAddBuff(i,t,n,h,s)
local i=e[24]
local n=e[25]
local e=e[26]
a:CheckAddBuff(i,t,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
return nil
end
return r

