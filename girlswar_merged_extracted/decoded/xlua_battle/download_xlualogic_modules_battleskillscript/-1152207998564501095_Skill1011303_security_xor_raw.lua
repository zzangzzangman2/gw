local e={
}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local n=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=t[3]
local i=a.HeroBattleInfo:DispelGranBuff(true,i,nil,nil,e.HeroId)
if(t[4]>=RandomMgr:GetBattleRandom())then
if(type(i)=="table"and#i>0)then
local t=RandomTableWithSeed(i,1)
local t=t[1]
if t then
local a=t.buffId
local o=t.round
local t=t.buffData
e:AddBuff(e,a,o,t)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n)
local s=t[5]
local n=t[6]
local i={t[7]}
a:AddBuff(e,s,n,i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
if(o)then
for a,t in ipairs(o)do
t:AddBuff(e,s,n,i)
end
end
local i=t[8]
local o=t[9]
local t=t[10]
local n=require("Modules/Battle/Formula")
if n:CalculateCtrlSuccess(o,i,e,a)then
a:AddBuff(e,o,t,nil)
end
return nil
end
return h 
