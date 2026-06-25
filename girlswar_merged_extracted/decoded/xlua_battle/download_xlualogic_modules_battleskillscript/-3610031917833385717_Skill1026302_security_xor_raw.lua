local i=require("Modules/BattleSkillScript/1026/SkillUtil1026")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local r=e[1]
local n=e[3]
local i=i.GetBuffData(e,e[4],5,16)
for e=1,#i do
local e=i[e]
local o=e.buffId
local e=e.buffData
a:AddBuff(t,o,n,e)
end
local s=e[17]
local i=e[18]
local n=e[19]
local h={t.HeroId,e[20],e[21],e[22],e[23]}
a:CheckAddBuff(s,t,i,n,h)
local i=e[24]
local n=e[25]
local e=e[26]
a:CheckAddBuff(i,t,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
return nil
end
return r

