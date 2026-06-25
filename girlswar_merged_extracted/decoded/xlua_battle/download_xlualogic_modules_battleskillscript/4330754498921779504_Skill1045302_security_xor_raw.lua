local h=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local e={
}
local d=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=t[1]
local r=t[3]
local i=t[4]
local s={t[5],t[6]}
e:AddBuff(e,r,i,s)
local r=t[7]
local s=t[8]
local i={t[9],t[10]}
e:AddBuff(e,r,s,i)
local i=e.HeroBattleInfo:GetMaxHP()-e.HeroBattleInfo:GetCurrHP()
local s=math.floor(i*t[11]*MillionCoe)
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30104505)
if i then
local t=i.GeHurtAddRate(e,a)
n=n+t
i.AddBoneCrashBuff(e,a)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n,0,s)
local a=a[1]
local t=t[12]*MillionCoe
h:HpHealthWithBigSkillAndParam(e,o.skilltype,a,t)
return nil
end
return d 
