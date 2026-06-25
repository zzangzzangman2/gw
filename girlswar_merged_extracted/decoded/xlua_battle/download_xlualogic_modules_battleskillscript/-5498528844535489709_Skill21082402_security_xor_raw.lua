local o={
}
local h=o
function o.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#a>=e[8]then
for s=1,#a do
local n=e[9]
local i=e[10]
local o={}
for t=11,20 do
table.insert(o,e[t])
end
a[s]:AddBuff(t,n,i,o)
end
end
local a=e[21]
local o=e[22]
local i={}
t:AddBuff(t,a,o,i)
local o=e[23]
local n=e[24]
local a={}
for t=25,30 do
table.insert(a,e[t])
end
local i=t.HeroBattleInfo.MaxHP
local i=i*e[31]*MillionCoe
table.insert(a,i)
for t=47,84 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,o,n,a)
local o=e[32]
local i=e[33]
local a={}
for t=34,46 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,o,i,a)
local a=302108211
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t:ShowRageBar(true,EBattleRageBarType.Yellow)
a.RefreshKingValueBar(e)
end
return nil
end
function o.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function o.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFront)
else
a=e.CurrBattleTeam:GetFrontOrBackHeros(true)
end
if#a>0 then
local o=t[1]
local i=t[2]
local n={t[3],t[4],t[85]}
for t=1,#a do
local t=a[t]
t:AddBuff(e,o,i,n)
end
local n=t[5]
local i=t[6]
local a={t[7],o}
e:AddBuff(e,n,i,a)
local a=302108229
local o=4
local i={}
e:AddBuff(e,a,o,i)
return{
duration=t[7],
success=true
}
end
return{
duration=0,
success=true
}
end
return{
duration=0,
success=false
}
end
return h 
