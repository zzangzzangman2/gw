local r=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(o==nil)then
return nil
end
e:ReduceFury(n.costMp)
e:RemoveOneBeans()
local d=t[1]
local s=t[3]
local h=t[4]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
local a=0
if(i)then
for e=1,#i do
local e=i[e]
local e=e.HeroBattleInfo:GetBuff(303111401)
if(e)then
a=a+1
end
end
end
local i={t[5],t[6]*a}
if a>0 then
e:AddBuff(e,s,h,i)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercent)
if a then
local n=t[7]
local o=t[8]
local s=t[9]
local h={t[10],t[11]}
local i,t=r:GetHeroNoBuffByType(e,BattleHeroType.ourAll,o)
local i=false
for e=1,#t do
if t[e].HeroId~=a.HeroId then
t[e].HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
else
i=true
end
end
if i==false then
local t=a:CheckAddBuff(n,e,o,s,h)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for t=1,#e do
local e=e[t]
local t=303111409
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ResetTarget(e,a)
end
end
end
end
end
local i=0
local s=303111414
local h=e.HeroBattleInfo:GetBuff(s)
if h then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
i=e.DoActionBigSkill(h,a)
end
local s=d
if i>0 and a then
local e=false
local t=#o
for t=1,t do
local t=o[t]
if t.HeroId==a.HeroId then
e=true
break
end
end
if e==false then
s=0
table.insert(o,a)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local h=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for a=1,#h do
local i=h[a]
local n=t[13]
local o=t[14]
local a={}
for e=15,22 do
table.insert(a,t[e])
end
table.insert(a,0)
i:AddBuff(e,n,o,a)
end
local u=t[23]
local h=t[24]
local l=e:GetFinalAtk()
local l=math.floor(l*t[25]*MillionCoe)
local l={l}
e:AddBuff(e,u,h,l)
local h=#o
for h=1,h do
local o=o[h]
local l=0
local h=d
if a and o.HeroId==a.HeroId then
l=i
h=s
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,h,0,l)
local a=a[3]
local a=a.reduceHpValue
local t=t[12]
local t=math.floor(a*t*MillionCoe)
r:AddSepsisHp(e,o,t)
end
return nil
end
return c

