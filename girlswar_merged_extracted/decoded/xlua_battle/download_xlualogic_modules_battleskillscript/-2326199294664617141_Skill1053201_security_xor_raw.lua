local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(e,n)
local i=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=i[1]
local a=#t
for a=1,a do
local t=t[a]
local o=o
local a=t.HeroBattleInfo:GetBuffSortArr()
local i=math.min(#a*i[3],i[4])
o=o+i
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=""
for t=1,#a do
local t=a[t].buffId
if e==""then
e=t
else
e=e.."_"..t
end
end

end
e.IgnoreBlock=true
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,o)
e.IgnoreBlock=false
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

