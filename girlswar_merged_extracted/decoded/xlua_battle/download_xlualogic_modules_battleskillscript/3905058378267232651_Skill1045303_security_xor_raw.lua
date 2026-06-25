local h=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=e[1]
local s=e[3]
local r=e[4]
local n={e[5],e[6]}
t:AddBuff(t,s,r,n)
local s=e[7]
local r=e[8]
local n={e[9],e[10]}
t:AddBuff(t,s,r,n)
local n=t.HeroBattleInfo:GetMaxHP()-t.HeroBattleInfo:GetCurrHP()
local s=math.floor(n*e[11]*MillionCoe)
local n=a.HeroBattleInfo:GetBuff(e[13])
if n~=nil then
local e={
attrId=e[14],
value=e[15],
}
a:AddAttrValueInBattle(e)
end
local n=ModulesInit.BattleBuffMgr.GetBuffScript(30104505)
if n then
local e=n.GeHurtAddRate(t,a)
i=i+e
n.AddBoneCrashBuff(t,a)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i,0,s)
local a=a[1]
local e=e[12]*MillionCoe
h:HpHealthWithBigSkillAndParam(t,o.skilltype,a,e)
return nil
end
return r 
