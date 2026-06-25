local e=require("Modules/Battle/Formula")
local e={}
local l=e
function e.DoAction(t,s,o,e)
local e=t:JudgeSkillPreView(s)
local a
if o and o.defHeroIds then
local e=o.defHeroIds[1]
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
if a==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eState,1,nil,30106422)
a=e[1]
end
if(a==nil)then
return nil
end
if o==nil or o.costMp~=false then
t:ReduceFury(s.costMp)
end
local h=nil
if o and o.isFightBack==true then
h=ETriggerSkillAtkType.FightBack
end
local i=e[1]
local r=e[3]
local d=e[4]
local o=e[5]
local n={e[6],e[7]}
t:AddBuff(t,r,o,n)
a:AddBuff(t,d,o,n)
local r=e[8]
local d=e[9]
local n=e[10]
local o={e[11],e[12]}
t:AddBuff(t,r,n,o)
a:AddBuff(t,d,n,o)
local r=e[13]
local d=e[14]
local n=e[15]
local o={e[16],e[17]}
t:AddBuff(t,r,n,o)
a:AddBuff(t,d,n,o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.all)
local o=#o
local n=0
for t=18,39,2 do
if o==e[t]then
n=e[t+1]
break
end
end
local r=e[40]
local d=e[41]
a:CheckAddBuff(n,t,r,d,0)
local n=0
if a.battleStationRow==2 then
for t=42,63,2 do
if o==e[t]then
n=e[t+1]
break
end
end
else
for t=64,85,2 do
if o==e[t]then
n=e[t+1]
break
end
end
end
i=i+n
local n=0
local r=30106415
local o=t.HeroBattleInfo:GetBuff(30106415)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
if e and e.GetRealHurt then
n=e.GetRealHurt(o,a)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,i,0,n,{triggerSkillAtkType=h})
local n=o[1]
local i=o[3]
local o=nil
local t=t.HeroBattleInfo:GetBuff(30106417)
if t then
o=2
end
if i.criticalOrBlock==1 then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
if#t>0 then
local a={}
for e=1,#t do
table.insert(a,t[e].HeroId)
end
local t=1064304
local e={realHurt=n*e[86]*MillionCoe,defHeroIds=a}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,t,nil,nil,EBattleSkillType.SkillBig,e,o)
end
end
if o~=nil then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,o)
end
return nil
end
return l

