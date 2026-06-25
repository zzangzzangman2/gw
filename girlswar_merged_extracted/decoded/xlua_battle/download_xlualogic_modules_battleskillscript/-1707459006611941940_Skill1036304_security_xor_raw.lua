local e={}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local l=e[1]
local r=e[3]
local d=e[4]
local h={e[5]}
local i=e[6]
local n=e[7]
local s={e[8]}
t:AddBuff(t,r,d,h)
t:AddBuff(t,i,n,s)
local i=0
if(a:CurrHPPer()>t:CurrHPPer())then
if(e[9]>=RandomMgr:GetBattleRandom())then
local o=e[10]
local e=e[11]
a:AddBuff(t,o,e,0)
end
else
i=e[12]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,l+i)
return nil
end
return l

