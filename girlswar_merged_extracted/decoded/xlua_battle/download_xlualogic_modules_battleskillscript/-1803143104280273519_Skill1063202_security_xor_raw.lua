local h=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=e[1]
if(a.profession==e[3])then
o=o+e[4]
end
local n=e[5]
local s=e[6]
local r={e[7],e[8]}
t:AddBuff(t,n,s,r)
local n=e[9]
local s=e[10]
local r={e[11],e[12]}
t:AddBuff(t,n,s,r)
local d=e[13]
local r=e[14]
local s=e[15]
local n={e[16],e[17],e[18]}
a:CheckAddBuff(d,t,r,s,n)
local n=t.HeroBattleInfo:GetMaxHP()*e[19]*MillionCoe
h:HpHealthWithSmallSkillAndParam(t,i.skilltype,n)
local n=math.max(e[20],a.HeroBattleInfo:GetCurrFury())
ModulesInit.ProcedureNormalBattle.StealFury(t,a,n,EBattleSrcType.SkillSmall,true,true)
local s=e[21]
local e=e[22]
local n={n}
t:AddBuff(t,s,e,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

