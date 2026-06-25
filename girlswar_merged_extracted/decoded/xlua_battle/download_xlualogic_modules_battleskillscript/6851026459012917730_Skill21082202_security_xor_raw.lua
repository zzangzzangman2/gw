local h=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i,e,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=0
local n=302108228
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
o=o+e.GetRealHurt(s)
end
local n=302108218
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(s)
end
local d=e[1]
local s=e[3]
local r=e[4]
local n={e[5],e[6]}
t:AddBuff(t,s,r,n)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for a=1,#n do
local o=e[7]
local i=e[8]
local s={e[9],e[10]}
n[a]:AddBuff(t,o,i,s)
local i=e[14]
local o=e[15]
local e={e[16],e[17],e[18],e[19]}
n[a]:AddBuff(t,i,o,e)
end
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[11]==1 then
local a=a.HeroBattleInfo.MaxHP
local e=math.floor(a*e[12]*MillionCoe)
h:HpHealthWithSmallSkillAndParam(t,i.skilltype,e)
end
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[13],EBattleSrcType.SkillSmall,true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d,0,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
