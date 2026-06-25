local u=require("Modules/Battle/BattleUtil")
local h={302110416,302110417,302110418,302110419}
local e={}
local c=e
function e.DoAction(e,r,s,t)
local t=e:JudgeSkillPreView(r)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=0
local i=302110407
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
l=e.DoActionSmallSkill(o)
end
local n=r.atkType
if s then
n=s.triggerSkillAtkType
end
local i=302110409
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.GetWineBibberBuffOneFloor(o,{triggerSkillAtkType=n})
end
local s=t[1]
local i=0
local d={302110406,302110404,302110415}
for t=1,#d do
local o=d[t]
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local t=0
if o==302110406 then
t=a:GetFloors()
else
local e=a:GetBuffData()
t=e[3]
end
if n==ETriggerSkillAtkType.Normal then
local a=302110405
local e=e.HeroBattleInfo:GetBuff(a)
if e then
if t>0 then
i=t
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=t.GetWineKnifeSkillHurtRate(e)
s=s+e*i
break
end
end
end
end
end
local c=t[3]
local n=t[4]
local d={t[5],t[6]}
e:AddBuff(e,c,n,d)
local d=t[7]
local n=t[8]
local t={t[9],t[10]}
e:AddBuff(e,d,n,t)
local n=true
local t={302110406,302110404,302110415}
for a=1,#t do
local t=t[a]
local t=e.HeroBattleInfo:GetBuff(t)
if t then
e.HeroBattleInfo:DispelAllGranBuff(false)
n=false
break
end
end
local t=#a
for t=1,t do
local t=a[t]
if i>0 and(t:IsRealFirstRowHero()or#a==1)then
local a=h[i]
if a==nil then
local e=#h
a=h[e]
end
local i=1
local o={}
t:AddBuff(e,a,i,o)
end
local a={
openAddFury=false
}
if n==false then
t:SetDisableDefRage(true)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,r,s,0,l)
if n==false then
t:SetDisableDefRage(false)
end
local a=a[3]
local a=a.reduceHpValue
if o then
local o=o:GetBuffData()
local o=o[4]
local a=math.floor(a*o*MillionCoe)
u:AddSepsisHp(e,t,a)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return c

