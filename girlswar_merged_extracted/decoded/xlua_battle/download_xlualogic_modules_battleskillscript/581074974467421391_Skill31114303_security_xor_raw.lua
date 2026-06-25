local s=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(o==nil)then
return nil
end
e:ReduceFury(n.costMp)
local h=a[1]
local d=a[3]
local r=a[4]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
local t=0
if(i)then
for e=1,#i do
local e=i[e]
local e=e.HeroBattleInfo:GetBuff(303111401)
if(e)then
t=t+1
end
end
end
local i={a[5],a[6]*t}
if t>0 then
e:AddBuff(e,d,r,i)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercent)
if t then
local n=a[7]
local o=a[8]
local r=a[9]
local h={a[10],a[11]}
local i,a=s:GetHeroNoBuffByType(e,BattleHeroType.ourAll,o)
local i=false
for e=1,#a do
if a[e].HeroId~=t.HeroId then
a[e].HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
else
i=true
end
end
if i==false then
local a=t:CheckAddBuff(n,e,o,r,h)
if a then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for a=1,#e do
local a=e[a]
local e=303111409
local a=a.HeroBattleInfo:GetBuff(e)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.ResetTarget(a,t)
end
end
end
end
end
local a=0
local i=303111414
local s=e.HeroBattleInfo:GetBuff(i)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
a=e.DoActionBigSkill(s,t)
end
local i=h
if a>0 and t then
local e=false
local a=#o
for a=1,a do
local a=o[a]
if a.HeroId==t.HeroId then
e=true
break
end
end
if e==false then
i=0
table.insert(o,t)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local s=#o
for s=1,s do
local s=o[s]
local r=0
local o=h
if t and s.HeroId==t.HeroId then
r=a
o=i
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,s,n,o,0,r)
end
return nil
end
return d 
