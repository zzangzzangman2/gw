local o=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=nil
local l=303104422
local s=t.HeroBattleInfo:GetBuff(l)
if s then
local e=303104412
local e,t=o:GetHeroMostBuffFloor(t,BattleHeroType.enemyAll,e)
if e~=nil and t~=0 then
a=e
end
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if a.HeroBattleInfo:IsFullHp()==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFrontMaxHpPercentWithCount,1)
a=e[1]
end
end
if(a==nil)then
return nil
end
local o={a}
t:ReduceFury(n.costMp)
local c=e[1]
local h=0
local i=303104418
local i=t.HeroBattleInfo:GetBuff(i)
if i and a.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
local a=i:GetBuffData()
h=a[1]
table.insert(o,e[t])
break
end
end
end
local d=e[3]
local r=e[4]
local i={e[5],e[6]}
t:AddBuff(t,d,r,i)
local r=e[7]
local d=e[8]
local i={e[9],e[10]}
t:AddBuff(t,r,d,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local i=t:GetFinalDef()
local u=math.floor(i*e[12]*MillionCoe)
local i=#o
for i=1,i do
local o=o[i]
local i=0
local r=303104412
local d=o.HeroBattleInfo:GetBuff(r)
if d then
local t=d:GetFloors()
if t>0 then
local a=o.HeroBattleInfo:GetMaxHP()
i=math.floor(a*e[11]*t*MillionCoe)
i=math.min(i,u)
end
o.HeroBattleInfo:RemoveBuffWithId(r,BuffRemoveType.Expire)
end
if e[13]>0 then
local a=math.floor(o.HeroBattleInfo.CurrFury*e[13]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.StealFury(t,o,a,EBattleSrcType.SkillBig,false)
if e[14]>0 and a<e[14]then
t:AddFuryWithSkill(e[15])
end
end
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
e.DoBeansActionBigSkill(s,o)
end
local e=c
if o.HeroId~=a.HeroId then
e=h
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,e,nil,i)
local e=e[3]
local a=e.reduceHpValue
local e=303104413
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionBigSkill(t,o,a)
end
end
return nil
end
return m

