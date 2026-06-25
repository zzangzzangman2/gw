local a=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local o=303111310
local o=t.HeroBattleInfo:GetBuff(o)
if(o)then
local t=e
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[9],nil,nil,EBattleSkillType.SkillBig,t)
end
local h=e[3]
local a=a:GetHeroNoBuff(t,h,1)
local a=a[1]
if(a==nil)then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
local s=0
local o=303111311
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
s=e.DoActionSmallSkill(i,{a})
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
t:ReduceFury(n.costMp)
t:RemoveOneBeans()
local r=e[1]
local i=e[4]
local o={e[5],e[6],e[7],e[8]}
a:AddBuff(t,h,i,o)
local i=303111308
local o=t.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddBuffFloatGuardRandomOne(o)
end
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.AddBuffPhotonCharging(o,e[14])
end
local o=e[15]
local i=e[16]
local h={e[17],e[18]}
t:AddBuff(t,o,i,h)
local o=e[19]
local i=e[20]
local e=e[21]
a:CheckAddBuff(o,t,i,e,0)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,r,0,s)
return nil
end
return d

