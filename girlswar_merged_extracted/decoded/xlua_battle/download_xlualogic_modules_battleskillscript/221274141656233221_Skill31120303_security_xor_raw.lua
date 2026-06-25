local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,n,t,t)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
e:ReduceFury(n.costMp)
local h=t[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=303112003
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local a=table.lightCopyList(a)
local a=RandomTableWithSeed(a,t[3])
for e=1,#a do
i.AddBuffFragileAlliance(o,a[e])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAllExcludeSelf)
local a=RandomTableWithSeed(a,t[6])
table.insert(a,e)
for e=1,#a do
i.AddBuffAlert(o,a[e],nil,t[7])
end
end
local o=303112001
local i,o=s:GetHeroNoBuffByType(e,BattleHeroType.enemyAll,o)
local i=#o
if(t[8]>=RandomMgr:GetBattleRandom())then
if i>1 then
local e=RandomTableWithSeed(o,1)
local e=e[1]
local t=RandomTableWithSeed(o,1)
local t=t[1]
if e and t then
local a=e.HeroBattleInfo:GetGranBuff(false)
local a=a[1]
if a then
s:AddBuffByBuffInfo(t,e,a)
end
end
end
end
local s=math.floor(e.HeroBattleInfo.MaxHP*t[5]*MillionCoe)
local o=#a
for o=1,o do
local o=a[o]
local a=0
if i>0 then
a=math.floor(o.HeroBattleInfo.CurrHP*i*t[4]*MillionCoe)
a=math.min(a,s)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,h,0,a)
end
return nil
end
return h 
