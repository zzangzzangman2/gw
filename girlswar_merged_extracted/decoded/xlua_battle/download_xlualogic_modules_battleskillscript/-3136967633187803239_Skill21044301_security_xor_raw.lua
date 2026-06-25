local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if a.HeroBattleInfo:IsFullHp()==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFrontMaxHpPercentWithCount,1)
a=e[1]
end
if(a==nil)then
return nil
end
local o={a}
e:ReduceFury(i.costMp)
local h=t[1]
local s=0
local n=302104418
local n=e.HeroBattleInfo:GetBuff(n)
if n and a.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
local a=n:GetBuffData()
s=a[1]
table.insert(o,e[t])
break
end
end
end
local n=t[3]
local r=t[4]
local d={t[5],t[6]}
e:AddBuff(e,n,r,d)
local d=t[7]
local n=t[8]
local r={t[9],t[10]}
e:AddBuff(e,d,n,r)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local n=#o
for n=1,n do
local o=o[n]
local n=o.HeroBattleInfo:GetMaxHP()
local n=math.floor(n*t[11]*MillionCoe)
local t=h
if o.HeroId~=a.HeroId then
t=s
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,t,nil,n)
local t=t[3]
local a=t.reduceHpValue
local t=302104413
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.HandleBuff(e,o,a)
end
end
return nil
end
return r

