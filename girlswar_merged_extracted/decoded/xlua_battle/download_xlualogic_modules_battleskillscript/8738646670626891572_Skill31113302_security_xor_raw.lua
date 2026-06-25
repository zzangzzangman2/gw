local a=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local i=303111310
local i=t.HeroBattleInfo:GetBuff(i)
if(i)then
local t=e
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[9],nil,nil,EBattleSkillType.SkillBig,t)
end
local n=e[3]
local a=a:GetHeroNoBuff(t,n,1)
local a=a[1]
if(a==nil)then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
local s=0
local h=303111311
local i=t.HeroBattleInfo:GetBuff(h)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
s=e.DoActionSmallSkill(i,{a})
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
t:ReduceFury(o.costMp)
local h=e[1]
local i=e[4]
local e={e[5],e[6],e[7],e[8]}
a:AddBuff(t,n,i,e)
local e=303111308
local i=t.HeroBattleInfo:GetBuff(e)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddBuffFloatGuardRandomOne(i)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h,0,s)
return nil
end
return r 
