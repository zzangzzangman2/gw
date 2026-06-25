local h=require("Modules/Battle/Formula")
local e={
}
local r=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local i=302110121
local a=t.HeroBattleInfo:GetBuff(i)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local t=t.DoActionBigSkill(a)
if t then
local e={drSkillArgs=e}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,21101304,nil,nil,EBattleSkillType.SkillBig,e)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local r=e[1]
local s=e[3]
local i=e[4]
local n={e[5],e[6]}
t:AddBuff(t,s,i,n)
local s=e[7]
local n=e[8]
local i={e[9],e[10]}
t:AddBuff(t,s,n,i)
local n=e[11]
local i=e[12]
local s={e[13],e[14]}
a:AddBuff(t,n,i,s)
local i=e[15]
local n=e[16]
local s={e[17],e[18]}
a:AddBuff(t,i,n,s)
local i=t.HeroBattleInfo.MaxHP
local s=math.floor(i*e[19]*MillionCoe)
local n=h:GetFinalThorn(t)
local i=e[20]
local h=e[21]
local e={e[22],math.floor(e[23]*n)}
t:AddBuff(t,i,h,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r,0,s)
return nil
end
return r 
