local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=e[1]
local c=e[3]
local u=e[4]
local d=e[5]
local i=#a
local o=a[1]
for e=1,i do
local t=a[e]
if t.battleStationRow==2 then
o=a[e]
break
end
end
local r=e[8]
local h=e[9]
local s={e[10],e[11]}
o:AddBuff(t,r,h,s)
local s=e[12]
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(t,s,o,e)
for e=1,i do
local e=a[e]
e:CheckAddBuff(c,t,u,d,0)
local a=0
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,l,nil,a)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

