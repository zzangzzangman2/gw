local h=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local s=t[1]
local d=s
local n=0
local o={}
if t[3]>0 then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local i=h:GetHeroListByProfession(i,ProfessionType.Tank)
local i=#i
n=t[3]*t[4]*(i+1)
local e=e:GetLastBigSkillTargetHeroIds()
for t=1,#e do
local e=e[t]
if e==a.HeroId then
d=s+n
else
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
table.insert(o,e)
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local u=t[5]
local c=t[6]
local r=t[7]
local l=t[8]
local s=0
local t=302107823
local h=e.HeroBattleInfo:GetBuff(t)
if h then
local e={}
table.insert(e,a)
for t=1,#o do
table.insert(e,o[t])
end
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.StartAttackWithSmallSkill(h,e)
end
a:CheckAddBuff(c,e,r,l,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,d)
local t=#o
for t=1,t do
local t=o[t]
t:CheckAddBuff(u,e,r,l,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return c

