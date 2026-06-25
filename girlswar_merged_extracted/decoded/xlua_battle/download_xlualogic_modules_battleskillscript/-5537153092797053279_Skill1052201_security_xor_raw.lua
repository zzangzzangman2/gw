local d=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local l=e[1]
local o=e[3]
local s=e[4]
local n={e[5],e[6]}
t:AddBuff(t,o,s,n)
local o=math.floor(t.HeroBattleInfo.MaxHP*e[9]*MillionCoe)
local n=e[7]
local u=e[8]
local r={o,e[10]}
local h=1
local s=a.HeroBattleInfo:GetBuff(n)
local o=0
if s then
o=s:GetFloors()
end
if o<e[10]then
a:AddBuff(t,n,u,r,h)
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local n=RandomTableWithSeed(o,#o)
local o=0
for t=1,#n do
if o>=e[11]then
break
end
local e=n[t]
local e=e.HeroBattleInfo:DispelAllGranBuff(false,false)
if#e>0 then
o=o+1
end
end
if o>0 then
local e=math.floor(t.HeroBattleInfo.MaxHP*e[12]*MillionCoe)
d:HpHealthWithSmallSkillAndParam(t,i.skilltype,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,l)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

