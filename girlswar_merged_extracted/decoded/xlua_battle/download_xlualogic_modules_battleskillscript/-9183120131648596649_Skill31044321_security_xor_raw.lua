local o=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local a=nil
local l=303104422
local n=e.HeroBattleInfo:GetBuff(l)
if n then
local t=303104412
local e,t=o:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,t)
if e~=nil and t~=0 then
a=e
end
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if a.HeroBattleInfo:IsFullHp()==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFrontMaxHpPercentWithCount,1)
a=e[1]
end
end
if(a==nil)then
return nil
end
local o={a}
e:ReduceFury(s.costMp)
e:RemoveOneBeans()
local c=t[1]
local d=0
local i=303104418
local i=e.HeroBattleInfo:GetBuff(i)
if i and a.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
local a=i:GetBuffData()
d=a[1]
table.insert(o,e[t])
break
end
end
end
local h=t[3]
local i=t[4]
local r={t[5],t[6]}
e:AddBuff(e,h,i,r)
local i=t[7]
local r=t[8]
local h={t[9],t[10]}
e:AddBuff(e,i,r,h)
local h=t[16]
local r=t[17]
local i={t[18]}
e:AddBuff(e,h,r,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local i=e:GetFinalDef()
local u=math.floor(i*t[12]*MillionCoe)
local i=#o
for i=1,i do
local o=o[i]
local i=0
local h=303104412
local r=o.HeroBattleInfo:GetBuff(h)
if r then
local e=r:GetFloors()
if e>0 then
local a=o.HeroBattleInfo:GetMaxHP()
i=math.floor(a*t[11]*e*MillionCoe)
i=math.min(i,u)
end
o.HeroBattleInfo:RemoveBuffWithId(h,BuffRemoveType.Expire)
end
if t[13]>0 then
local a=math.floor(o.HeroBattleInfo.CurrFury*t[13]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.StealFury(e,o,a,EBattleSrcType.SkillBig,false)
if t[14]>0 and a<t[14]then
e:AddFuryWithSkill(t[15])
end
end
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(l)
e.DoBeansActionBigSkill(n,o)
end
local t=c
if o.HeroId~=a.HeroId then
t=d
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,s,t,nil,i)
local t=t[3]
local a=t.reduceHpValue
local t=303104413
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoActionBigSkill(e,o,a)
end
end
return nil
end
return m

