local f=require("Modules/Battle/Formula")
local n=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,h,s,e)
local e=t:JudgeSkillPreView(h)
if s==nil or s.costMp~=false then
t:ReduceFury(h.costMp)
end
local a=nil
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if o==nil then
return nil
end
local i=o.HeroBattleInfo:GetBuff(e[3])
if i then
a=o
end
if a==nil then
local e=n:GetEnemysWithBuff(t,e[3],1)
a=e[1]
end
local i=302107511
local o=t.HeroBattleInfo:GetBuff(i)
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local r=nil
local n=0
if s then
r=s.triggerSkillAtkType
local e=s.alreadyReleaseSkillIndex
if e==1 then
n=2
elseif e==2 then
n=1
end
end
if n==0 then
if a then
n=1
else
n=2
end
end
if r==ETriggerSkillAtkType.FightBack then
if o then
i.DoActionFightBackOnSelf(o)
end
end
local d=302107515
local s=t.HeroBattleInfo:GetBuff(d)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.SaveExSkillIndex(s,n)
end
local d=302107520
local s=t.HeroBattleInfo:GetBuff(d)
if n==1 then
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
end
local l=0
if r==ETriggerSkillAtkType.FightBack then
if o then
l=i.DoActionFightBack(o,a)
end
end
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.DoActionBigSkill(s,a)
end
local u=0
if o then
u=i.GetFrozenCount(o)
end
local c=e[1]
local m=e[4]
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,a)
for e=1,#n do
local e=n[e]
local a=0
if r==ETriggerSkillAtkType.FightBack then
if o then
a=i.DoActionFightBack(o,e)
end
end
if s then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.DoActionBigSkill(s,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,m,0,a)
end
local s=e[5]
local n=e[6]
local r={e[7],e[8]+u*e[9]}
t:AddBuff(t,s,n,r)
local r=e[10]
local s=e[11]
local n={e[12],e[13]}
t:AddBuff(t,r,s,n)
local n=a.HeroBattleInfo:GetBuff(e[3])
if n then
if o then
i.AddSnowFrozenBuff(o,a)
end
local i=e[14]
local o=e[15]
local e={e[16],e[17]}
a:AddBuff(t,i,o,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,h,c,0,l)
else
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=#a
for e=1,l do
local e=a[e]
if s then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.DoActionBigSkill(s,e)
end
end
local n=0
if o then
n=i.GetFrozenCount(o)
end
local u=e[18]
local s=e[20]
local d=e[21]
local c={e[22],e[23]}
t:AddBuff(t,s,d,c)
local s=e[24]
local d=e[25]
local n={e[26],e[27]+n*e[28]}
t:AddBuff(t,s,d,n)
local n=f:GetHeroControlRate(t)
local s=n.attackFinalControlRate
local d=e[29]
local n=e[30]
local s={e[31],e[32]+math.floor(s*e[33])}
t:AddBuff(t,d,n,s)
local n=e[34]
local e=e[35]
local s={}
t:AddBuff(t,n,e,s)
for e=1,l do
local e=a[e]
local a=0
if r==ETriggerSkillAtkType.FightBack then
if o then
a=i.DoActionFightBack(o,e)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,u,0,a)
end
return nil
end
return nil
end
return m 
