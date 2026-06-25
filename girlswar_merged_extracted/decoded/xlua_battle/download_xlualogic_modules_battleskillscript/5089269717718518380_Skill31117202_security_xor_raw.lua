local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,n,t,t)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=303111708
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(o)
end
local s=t[1]
local o=303111704
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
for o=1,#e do
a.AddBuffVijnanavada(i,e[o],t[3],true)
end
end
local o=0
local i=#a
for t=1,i do
local t=a[t]
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,s)
local e=e[1]
o=o+e
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLow,1,HeroAttrId.hpPer)
if(a~=nil and#a>0)then
local i=a[1]
local a=o*t[4]*MillionCoe
local o=e:GetFinalAtk()
local t=math.floor(o*t[5]*MillionCoe)
a=math.min(a,t)
i:HpHealthWithNormalSkill(e,a,false,EBattleSrcType.SkillSmall)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
