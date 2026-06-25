local e={}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local o=t[3]
local r=t[4]
local d={t[5]}
local s=t[6]
local h=t[7]
local n={t[8]}
e:AddBuff(e,o,r,d)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fBack)
if(t~=nil)then
local a=#t
for a=1,a do
local t=t[a]
t:AddBuff(e,s,h,n)
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
return nil
end
return i

