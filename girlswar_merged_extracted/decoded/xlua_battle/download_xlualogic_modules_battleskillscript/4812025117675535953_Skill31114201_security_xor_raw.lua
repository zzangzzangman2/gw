local i=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,s,o,e)
local a=t:JudgeSkillPreView(s)
local e=nil
if o then
local t=o.defHeroId
e=i:GetTargetHeroCtrl(t)
end
if e==nil then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local h=a[1]
e.HeroBattleInfo:DispelGranBuff(true,a[3])
local n=a[4]
local o=0
local i=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(t:GetTeamId(),BattleHeroType.enemyAll,nil,nil,true)
if(i)then
for e=1,#i do
local e=i[e]
local e=e.HeroBattleInfo:GetBuff(n)
if e then
o=o+1
end
end
end
if o<a[10]then
local s=a[5]
local o={}
for e=6,10 do
table.insert(o,a[e])
end
local a=a[8]*MillionCoe
local i=t:GetFinalAtk()
local a=math.floor(i*a)
table.insert(o,a)
table.insert(o,0)
table.insert(o,0)
table.insert(o,0)
e:AddBuff(t,n,s,o)
end
local o=0
local a=303111412
local i=t.HeroBattleInfo:GetBuff(a)
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
o=t.DoActionSmallSkill(i,e)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,s,h,nil,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
