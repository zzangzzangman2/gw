local e={}
local i=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local l=e[1]
local i=e[3]
local o=e[4]
local h={e[5]}
local d=e[6]
local u=e[7]
local c={e[8]}
local s=e[9]
local r=e[10]
local n={e[11]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
if(e~=nil)then
local a=#e
for a=1,a do
local e=e[a]
e:AddBuff(t,d,u,c)
end
end
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
if(e~=nil)then
local a=#e
for a=1,a do
local e=e[a]
e:AddBuff(t,i,o,h)
e:AddBuff(t,s,r,n)
end
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,l)
return nil
end
return i

