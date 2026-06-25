local c=require("Modules/Battle/BattleUtil")
local e={}
local y=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local r=ModulesInit.BattleBuffMgr.GetBuffScript(303107315)
local a=r.CheckPlayBird(t)
if a==false then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[22])
end
local i=t.HeroBattleInfo:GetBuff(303107313)
local h=false
local a=BattleHeroType.enemy
if i then
a=BattleHeroType.eMinHpPercent
h=true
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
if(a==nil)then
return nil
end
local i={a}
local w=e[1]
if e[3]>0 then
t:AddFuryWithSkill(e[3])
end
local n=e[4]
local s=e[5]
local l={e[6],e[7]}
local d=e[8]
t:AddBuffWithMaxFloor(t,n,s,l,1,d)
local d=e[9]
local n=e[10]
local s={e[11],e[12]}
t:AddBuff(t,d,n,s)
local s=e[13]
local d=e[14]
local n={e[15],e[16]}
t:AddBuff(t,s,d,n)
local s=0
if a.battleStationRow==1 then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for a=1,#t do
if t[a].battleStationRow==2 then
s=e[17]
table.insert(i,t[a])
break
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local l=e[18]
local d=e[19]
local u=e[20]
local f=0
local n=0
local m=#i
for e=1,m do
local e=i[e]
e:CheckAddBuff(l,t,d,u,f)
if h then
e.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
local i
if e.HeroId~=a.HeroId then
local a={
openAddFury=false
}
e:SetDisableDefRage(true)
i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s,0,0,a)
e:SetDisableDefRage(false)
else
i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,w)
end
local e=i[1]
n=n+e
end
local e=math.floor(n*e[21]*MillionCoe)
c:HpHealthWithSmallSkillAndParam(t,o.skilltype,e)
r.RecordSmall(t,1)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return y

