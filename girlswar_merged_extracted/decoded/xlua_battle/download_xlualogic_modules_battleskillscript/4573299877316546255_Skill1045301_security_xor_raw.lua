local s=require("Modules/Battle/BattleUtil")
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
local i=t[3]
local h=t[4]
local r={t[5],t[6]}
e:AddBuff(e,i,h,r)
local i=e.HeroBattleInfo:GetMaxHP()-e.HeroBattleInfo:GetCurrHP()
local h=math.floor(i*t[7]*MillionCoe)
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30104505)
if i then
local t=i.GeHurtAddRate(e,a)
n=n+t
i.AddBoneCrashBuff(e,a)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n,0,h)
local a=a[1]
local t=t[8]*MillionCoe
s:HpHealthWithBigSkillAndParam(e,o.skilltype,a,t)
return nil
end
return d 
