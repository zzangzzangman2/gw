local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,a,t,t)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local n=303111006
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(i,t,a.atkType)
end
local n=o[1]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fMinHpPercentWithCount)
if#i>0 then
local a=i[1]
local t=303111003
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffBabai(e,a,o[4])
end
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
local a=a[3]
local a=a.reduceHpValue
local o=o[3]
local a=math.floor(a*o*MillionCoe)
s:AddSepsisHp(e,t,a)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
