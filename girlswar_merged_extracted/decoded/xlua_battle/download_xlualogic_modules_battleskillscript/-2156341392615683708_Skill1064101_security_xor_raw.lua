local e={
}
local n=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local n=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local a=0
local s=30106415
local o=e.HeroBattleInfo:GetBuff(30106415)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if e and e.GetRealHurt then
a=e.GetRealHurt(o,t)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n,0,a)
e:FuryHealth(FuryHealthType.Attack)
local t=nil
local e=e.HeroBattleInfo:GetBuff(30106417)
if e then
t=2
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillNomal,nil,t)
end
return nil
end
return n 
