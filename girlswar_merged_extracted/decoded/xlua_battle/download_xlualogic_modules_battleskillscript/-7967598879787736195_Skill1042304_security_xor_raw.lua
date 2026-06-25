local e={}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local h=e[1]
local d=e[3]
local r=e[4]
local s={e[5]}
local n=e[6]
local i=e[7]
local a={e[8]}
t:AddBuff(t,d,r,s)
t:AddBuff(t,n,i,a)
local i=0
local a=t.HeroBattleInfo:GetBuff(e[9])
if(a)then
a:AddFloors(e[10])
i=a.floors
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
local e=t.HeroBattleInfo.Def*math.min((e[11]+(i*e[12])),e[13])*MillionCoe
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=#a
for i=1,i do
local a=a[i]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h,0,e)
end
end
return nil
end
return h

