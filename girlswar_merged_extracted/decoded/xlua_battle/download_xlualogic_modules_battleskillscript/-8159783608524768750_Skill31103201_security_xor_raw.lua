local h=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local e={
}
local r=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local a=nil
if o then
local e=o.defHeroIds
if e then
local e=RandomTableWithSeed(e,1)
local e=e[1]
if e then
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
end
end
if(a==nil)then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
local o=303110314
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(n,a)
end
local n=e[1]
local o=t.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*e[3]*MillionCoe)
h:HpHealthWithSmallSkillAndParam(t,i.skilltype,o)
t:AddFuryWithSkill(e[4])
local o=s:GetInjureData(a)
local o=o.attackFinalInjureRate*OneMillion
o=math.min(o,e[5])
if o>0 then
local a=e[6]
local i=e[7]
local e={e[8],o}
t:AddBuff(t,a,i,e)
end
local o=s:CalculateHeroAttackCriticalRate(a)
local o=o.attackCriticalRate*OneMillion
o=math.min(o,e[5])
if o>0 then
local a=e[9]
local i=e[10]
local e={e[11],o}
t:AddBuff(t,a,i,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,n,0,0)
return nil
end
return r 
