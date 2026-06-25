local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if a.HeroBattleInfo:IsFullHp()==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFrontMaxHpPercentWithCount,1)
a=e[1]
end
if(a==nil)then
return nil
end
local o={a}
t:ReduceFury(i.costMp)
local r=e[1]
local s=0
local n=302104418
local n=t.HeroBattleInfo:GetBuff(n)
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
local d=e[3]
local n=e[4]
local h={e[5],e[6]}
t:AddBuff(t,d,n,h)
local d=e[7]
local h=e[8]
local n={e[9],e[10]}
t:AddBuff(t,d,h,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local n=#o
for n=1,n do
local o=o[n]
local n=o.HeroBattleInfo:GetMaxHP()
local n=math.floor(n*e[11]*MillionCoe)
local h=math.floor(o.HeroBattleInfo.CurrFury*e[12]*MillionCoe)
local h=ModulesInit.ProcedureNormalBattle.StealFury(t,o,h,EBattleSrcType.SkillBig,false)
if h<e[13]then
t:AddFuryWithSkill(e[14])
end
local e=r
if o.HeroId~=a.HeroId then
e=s
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,e,nil,n)
local e=e[3]
local i=e.reduceHpValue
local a=302104413
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.HandleBuff(e,o,i)
end
end
return nil
end
return d

