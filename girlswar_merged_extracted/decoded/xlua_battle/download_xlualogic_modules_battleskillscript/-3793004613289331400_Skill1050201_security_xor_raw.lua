local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(a,i)
local e=a:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eColumnWithBuff,nil,nil,e[6])
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local d=e[1]
local o=RandomMgr:GetBattleRandomWithRange(1,#t)
local o=t[o]
if o then
local t=e[3]
local i=e[4]
local e=e[5]
o:CheckAddBuff(t,a,i,e,0)
end
local o=a:GetFinalAtk()
local n=#t
for n=1,n do
local t=t[n]
local n=t.HeroBattleInfo:GetBuff(e[6])
if n then
local h=e[7]
local r=e[8]
local i=n:GetBuffData()
local n=math.floor(i[3]*e[9]*MillionCoe)
local s=math.floor(o*e[10]*MillionCoe)
local e=math.floor(o*e[11]*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local o=math.max(n,s)
local e=math.min(o,e)
local e={e}
t:AddBuff(a,h,r,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,i,d)
end
a:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

