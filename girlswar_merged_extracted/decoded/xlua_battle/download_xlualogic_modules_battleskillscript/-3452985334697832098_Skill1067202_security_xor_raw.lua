local e=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,r)
local e=t:JudgeSkillPreView(r)
local s=e[8]
local l=e[9]
local c={e[10],e[11],e[12]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumnWithBuff,nil,nil,s)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local u=e[1]
local d=#a
local i=nil
local n=nil
for e=1,d do
local e=a[e]
if e.battleStationRow==1 then
i=e
else
n=e
end
end
if i and n then
local h=e[5]
local r=e[6]
local d={ModulesInit.ProcedureNormalBattle.CurrBattleBigRound}
local o=nil
local a=t.HeroBattleInfo:GetBuff(h)
if a then
local e=a:GetBuffData()
o=e[1]
end
if o==nil or ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-o>e[7]then
local e=i.HeroBattleInfo:GetBuff(s)
if e then
if a then
local e=a:GetBuffData()
e[1]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
else
t:AddBuff(t,h,r,d)
end
n:AddBuff(t,s,l,c)
end
end
end
for o=1,d do
local o=a[o]
local a=u
if(o.profession==e[3])then
a=a+e[4]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,r,a)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return c

