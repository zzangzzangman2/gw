local s=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumnWithBuff,nil,nil,e[8])
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local o=t:GetFinalAtk()
local n=RandomMgr:GetBattleRandomWithRange(1,#a)
local n=a[n]
if n then
local a=e[3]
local r=e[4]
local h=e[5]
local a=n:CheckAddBuff(a,t,r,h,0)
if a then
local a=math.floor(o*e[6]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,i.skilltype,a)
t:AddFuryWithSkill(e[7])
end
end
local n=#a
for n=1,n do
local a=a[n]
local n=a.HeroBattleInfo:GetBuff(e[8])
if n then
local h=e[9]
local r=e[10]
local s=n:GetBuffData()
local i=math.floor(s[3]*e[11]*MillionCoe)
local n=math.floor(o*e[12]*MillionCoe)
local e=math.floor(o*e[13]*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local o=math.max(i,n)
local e=math.min(o,e)
local e={e}
a:AddBuff(t,h,r,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

