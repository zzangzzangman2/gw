local e={}
local h=e
function e.DoAction(e,n)
local a=e:JudgeSkillPreView(n)
local i=a[1]
local r=a[3]
local s=a[4]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(o==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local t=e.HeroBattleInfo:GetBuff(3084)
if t~=nil then
local a=t:GetBuffData()
local e=t:GetFloors()
e=math.min(e,a[2])
i=i+a[1]*e
end
local h=#o
for a=1,h do
local t=o[a]
if(a==1)then
if(r>=RandomMgr:GetBattleRandom())then
t:ReduceFuryWithSkill(s,e,EBattleSrcType.SkillSmall,true)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,i)
end
if t==nil then
local o=a[5]
local t=a[6]
local a={a[7],a[8]}
e:AddBuff(e,o,t,a)
else
local e=t:GetBuffData()
local a=t:GetFloors()
if a<e[2]then
t:AddFloors(1)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

