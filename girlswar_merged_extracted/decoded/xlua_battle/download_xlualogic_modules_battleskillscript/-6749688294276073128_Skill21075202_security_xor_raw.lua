local e=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(t,d,e,e)
local e=t:JudgeSkillPreView(d)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=302107511
local o=t.HeroBattleInfo:GetBuff(i)
local h=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local i=e[12]
local u=e[13]
local l=e[14]
local r=0
local n=302107515
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
r,i=e.DoActionSmallSkill(s,a)
end
local i=a:CheckAddBuff(i,t,u,l)
if i then
if o then
h.FrozenEnemy(o)
end
end
local i=e[1]
local n=e[3]
local l=e[4]
local s={e[5],e[6]}
t:AddBuff(t,n,l,s)
local s=e[7]
local l=e[8]
local n={e[9],e[10]}
t:AddBuff(t,s,l,n)
i=i+e[11]
if o then
h.GainSnowMan(o,e[15])
end
local o=t.HeroBattleInfo.MaxHP
local o=o*e[16]*MillionCoe
t:HpHealthSimple(t,o,EBattleSrcType.SkillSmall)
t:AddFuryWithSkill(e[17])
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,d,i,0,r)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return c 
