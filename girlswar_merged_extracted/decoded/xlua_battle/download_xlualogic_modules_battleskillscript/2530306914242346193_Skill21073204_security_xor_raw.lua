local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=t.HeroBattleInfo:GetBuff(302107313)
local n=false
local a=BattleHeroType.enemy
if i then
a=BattleHeroType.eMinHpPercent
n=true
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
if(a==nil)then
return nil
end
local i=e[1]
if e[3]>0 then
t:AddFuryWithSkill(e[3])
end
local h=e[4]
local d=e[5]
local s={e[6],e[7]}
local r=e[8]
t:AddBuffWithMaxFloor(t,h,d,s,1,r)
local h=e[9]
local r=e[10]
local s={e[11],e[12]}
t:AddBuff(t,h,r,s)
local r=e[13]
local h=e[14]
local s={e[15],e[16]}
t:AddBuff(t,r,h,s)
local s=e[17]
local h=e[18]
i=i+h
t:AddFuryWithSkill(e[19])
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(e,a)
for a=1,#e do
local e=e[a]
if n then
e.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s)
end
if n then
a.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302107315)
e.RecordSmall(t,0)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

