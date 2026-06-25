local e={
}
local h=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local n=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=t.HeroBattleInfo:GetBuff(30105502)
local i=0
if o then
local e=o:GetBuffData()
local a=o:GetFloors()
if a>=e[1]then
n=n+e[2]
end
if a>=e[3]then
i=e[4]
end
if a>=e[5]then
if a>1 then
o:ReduceFloors(e[6])
else
t.HeroBattleInfo:RemoveBuffWithId(30105502,BuffRemoveType.Expire)
end
local o=e[7]
local a=e[8]
local e={e[9]}
t:AddBuff(t,o,a,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,n)
t:FuryHealth(FuryHealthType.Attack)
if i and i>0 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
if#e>0 then
local t={}
for a=1,#e do
table.insert(t,e[a].HeroId)
end
local e=1055102
local t={skillHurtRate=i,defHeroIds=t}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e,nil,nil,EBattleSkillType.SkillNomal,t)
else
return nil
end
else
return nil
end
end
return h 
