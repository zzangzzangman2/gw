local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local s=t[1]
local h=t[3]
local r=t[4]
local n={t[5],t[6]}
local o=t[7]
e:AddBuffWithMaxFloor(e,h,r,n,1,o)
local o=e.HeroBattleInfo.MaxHP
local o=o*t[8]*MillionCoe
e:HpHealthSimple(e,o,EBattleSrcType.SkillSmall)
e:AddFuryWithSkill(t[9])
local t=302107610
local o=e.HeroBattleInfo:GetBuff(t)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.DoActionSmallSkill(o,a)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,s)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
