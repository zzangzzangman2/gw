local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i,o,e)
local a=t:JudgeSkillPreView(i)
local e=nil
if o then
if o.defHeroIds then
local t=o.defHeroIds[1]
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
end
end
if(e==nil)then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(e==nil)then
return nil
end
local o=302109008
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.DoActionSmallSkill(n,e)
end
local h=a[1]
local n=a[3]
local s=a[4]
local o={a[5],a[6]}
t:AddBuff(t,n,s,o)
local o=a[7]
local n=302109011
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddSuperIsolatedBuff(s,e,o)
else
local i=302109016
local i=t.HeroBattleInfo:GetBuff(i)
if i==nil then
local i=a[8]
local n=a[9]
local a=0
e:CheckAddBuff(o,t,i,n,a)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h,0,0)
return nil
end
return h 
